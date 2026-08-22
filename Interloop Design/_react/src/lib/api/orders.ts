import { api, type PagedResult } from './axios';
import { getEnv } from '@/env';
import { ORDERS, ORDER_ITEMS, PRODUCTION, MILESTONES, STAKEHOLDERS, ACTIVITIES, STAGES } from './mock-data';
import type { NewOrderInput, Order, OrderQuery } from './types';

/**
 * Typed API module. Rendering components never see axios — they consume these
 * through TanStack Query. Endpoints omit `/api`; the base URL supplies it.
 */

const numericOp = (q: string, n: number) => {
  const range = q.match(/^(-?[\d.]+)\s*(?:-|\.\.|to)\s*(-?[\d.]+)$/i);
  if (range) return n >= +range[1] && n <= +range[2];
  const m = q.match(/^(>=|<=|>|<|=)?\s*(-?[\d.]+)$/);
  if (!m) return String(n).includes(q);
  const t = +m[2];
  switch (m[1]) {
    case '>': return n > t;
    case '<': return n < t;
    case '>=': return n >= t;
    case '<=': return n <= t;
    default: return n === t;
  }
};

/** Stands in for the backend while `useMocks` is on. Same shape as ABP's paged result. */
export function queryMockOrders(q: OrderQuery): PagedResult<Order> {
  let out = ORDERS;
  const term = q.filter.trim().toLowerCase();
  if (term) {
    out = out.filter((o) =>
      `${o.id}${o.client}${o.division}${o.owner}${o.status}`.toLowerCase().includes(term));
  }
  for (const [key, value] of Object.entries(q.columnFilters)) {
    if (!value) continue;
    out = out.filter((o) => {
      const cell = o[key as keyof Order];
      return typeof cell === 'number'
        ? numericOp(value, cell)
        : String(cell).toLowerCase().includes(value.toLowerCase());
    });
  }
  if (q.sorting) {
    const [key, dir] = q.sorting.split(' ');
    const sign = dir === 'desc' ? -1 : 1;
    out = [...out].sort((a, b) => {
      const x = a[key as keyof Order];
      const y = b[key as keyof Order];
      if (typeof x === 'number' && typeof y === 'number') return sign * (x - y);
      return sign * String(x).localeCompare(String(y));
    });
  }
  const skip = (q.page - 1) * q.pageSize;
  return { items: out.slice(skip, skip + q.pageSize), totalCount: out.length };
}

const delay = (ms: number) => new Promise((r) => setTimeout(r, ms));

export const ordersApi = {
  async list(q: OrderQuery): Promise<PagedResult<Order>> {
    if (getEnv().useMocks) {
      await delay(260);
      return queryMockOrders(q);
    }
    const { data } = await api.get<PagedResult<Order>>('/app/order', {
      params: {
        skipCount: (q.page - 1) * q.pageSize,
        maxResultCount: q.pageSize,
        sorting: q.sorting ?? undefined,
        filter: q.filter || undefined,
        ...q.columnFilters,
      },
    });
    return data;
  },

  async get(id: string): Promise<Order> {
    if (getEnv().useMocks) {
      await delay(120);
      const found = ORDERS.find((o) => o.id === id);
      if (!found) throw new Error(`Order ${id} not found`);
      return found;
    }
    const { data } = await api.get<Order>(`/app/order/${id}`);
    return data;
  },

  async create(input: NewOrderInput): Promise<Order> {
    if (getEnv().useMocks) {
      await delay(320);
      const created: Order = {
        id: `ILP-${20000 + Math.floor(Math.random() * 9999)}`,
        client: input.client,
        division: input.division,
        plant: input.plant,
        status: input.rush ? 'In production' : 'Planned',
        units: input.units,
        value: Math.round(input.units * 3.4),
        defects: 0,
        owner: 'Bilal Raza',
        ship: input.ship,
      };
      ORDERS.unshift(created);
      return created;
    }
    const { data } = await api.post<Order>('/app/order', input);
    return data;
  },

  /** Order-detail aggregate: items, production matrix, milestones, people, feed. */
  async detail(id: string) {
    if (getEnv().useMocks) {
      await delay(180);
      return {
        id,
        po: {
          number: '8757222', opo: null, type: 'Other', commit: '310016',
          line: 'Apparel', category: 'Socks & hosiery',
          inStore: '2027-01-08', shipBegin: '2026-10-20', shipEnd: '2026-10-25',
        },
        items: ORDER_ITEMS,
        production: PRODUCTION,
        stages: STAGES,
        milestones: MILESTONES,
        stakeholders: STAKEHOLDERS,
        activities: ACTIVITIES,
      };
    }
    const { data } = await api.get(`/app/order/${id}/detail`);
    return data;
  },
};

export const orderKeys = {
  all: ['orders'] as const,
  list: (q: OrderQuery) => [...orderKeys.all, 'list', q] as const,
  detail: (id: string) => [...orderKeys.all, 'detail', id] as const,
};
