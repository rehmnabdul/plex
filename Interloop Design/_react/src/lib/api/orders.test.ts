import { describe, expect, it } from 'vitest';
import { queryMockOrders, orderKeys } from '@/lib/api/orders';
import { orderSchema, newOrderSchema } from '@/lib/api/types';
import { ORDERS } from '@/lib/api/mock-data';
import { dayLabel, formatMoney, formatNumber, relativeTime, cn } from '@/lib/utils';

const query = { page: 1, pageSize: 25, sorting: null, filter: '', columnFilters: {}, grouping: [] };

describe('orders API module', () => {
  it('returns an ABP-shaped paged result', () => {
    const res = queryMockOrders(query);
    expect(res.items).toHaveLength(25);
    expect(res.totalCount).toBe(ORDERS.length);
  });

  it('pages without overlapping', () => {
    const p1 = queryMockOrders(query);
    const p2 = queryMockOrders({ ...query, page: 2 });
    expect(p1.items[0].id).not.toBe(p2.items[0].id);
  });

  it('applies the global filter across searchable fields', () => {
    const res = queryMockOrders({ ...query, filter: 'nordstrom' });
    expect(res.totalCount).toBeGreaterThan(0);
    expect(res.items.every((o) => o.client.toLowerCase().includes('nordstrom'))).toBe(true);
  });

  it('applies numeric operators in column filters', () => {
    const res = queryMockOrders({ ...query, columnFilters: { units: '>80000' } });
    expect(res.items.every((o) => o.units > 80000)).toBe(true);
  });

  it('sorts descending', () => {
    const res = queryMockOrders({ ...query, sorting: 'value desc' });
    const values = res.items.map((o) => o.value);
    expect([...values].sort((a, b) => b - a)).toEqual(values);
  });

  it('builds stable query keys', () => {
    expect(orderKeys.detail('ILP-1')).toEqual(['orders', 'detail', 'ILP-1']);
    expect(orderKeys.list(query)[1]).toBe('list');
  });

  it('produces rows that satisfy the Zod schema', () => {
    expect(() => orderSchema.parse(ORDERS[0])).not.toThrow();
  });
});

describe('newOrderSchema', () => {
  const valid = { client: 'Nordstrom', division: 'Denim', plant: 'Lahore', units: 1000, ship: '2026-11-30', rush: false };

  it('accepts a valid order', () => {
    expect(newOrderSchema.safeParse(valid).success).toBe(true);
  });

  it('coerces numeric strings from the input element', () => {
    const parsed = newOrderSchema.parse({ ...valid, units: '2500' });
    expect(parsed.units).toBe(2500);
  });

  it('rejects an unknown division', () => {
    expect(newOrderSchema.safeParse({ ...valid, division: 'Footwear' }).success).toBe(false);
  });

  it('caps note length', () => {
    expect(newOrderSchema.safeParse({ ...valid, notes: 'x'.repeat(281) }).success).toBe(false);
  });
});

describe('formatters', () => {
  const now = new Date('2026-08-02T14:20:00');

  it('formats numbers and money', () => {
    expect(formatNumber(84000)).toBe('84,000');
    expect(formatMoney(1500)).toBe('$1,500.00');
  });

  it('labels today, yesterday and older days', () => {
    expect(dayLabel(now, now)).toBe('Today');
    expect(dayLabel(new Date('2026-08-01T09:00:00'), now)).toBe('Yesterday');
    expect(dayLabel(new Date('2026-07-28T09:00:00'), now)).toMatch(/Jul/);
  });

  it('renders relative time inside today and clock time before it', () => {
    expect(relativeTime(new Date('2026-08-02T13:20:00'), now)).toBe('1h ago');
    expect(relativeTime(new Date('2026-08-02T14:19:30'), now)).toBe('just now');
    expect(relativeTime(new Date('2026-08-01T15:00:00'), now)).toMatch(/3:00/);
  });

  it('merges conflicting tailwind classes', () => {
    expect(cn('px-2', 'px-4')).toBe('px-4');
  });
});
