import type {
  Milestone, Order, OrderItem, ProductionRow, Stage, Stakeholder,
} from './types';
import { divisions, orderStatuses, plants } from './types';

/* Deterministic pseudo-random so screenshots and tests are stable. */
const seeded = (seed: number) => {
  let x = (seed * 16807) % 2147483647;
  return () => (x = (x * 16807) % 2147483647) / 2147483647;
};

const CLIENTS = ['Nordstrom', 'Uniqlo', 'Adidas', 'Puma', 'H&M', 'Target', 'Decathlon', 'Zara', 'Levi’s', 'Muji'];
const OWNERS = ['Ayesha Khan', 'Bilal Raza', 'Sana Iqbal', 'Usman Tariq', 'Hina Malik', 'Zain Abbas'];

export const ORDERS: Order[] = (() => {
  const r = seeded(7);
  return Array.from({ length: 4820 }, (_, i) => {
    const units = Math.round(2000 + r() * 88000);
    const d = new Date(2026, 0, 1 + Math.floor(r() * 210));
    return {
      id: `ILP-${10240 + i}`,
      client: CLIENTS[Math.floor(r() * CLIENTS.length)],
      division: divisions[Math.floor(r() * divisions.length)],
      plant: plants[Math.floor(r() * plants.length)],
      status: orderStatuses[Math.floor(r() * orderStatuses.length)],
      units,
      value: Math.round(units * (1.8 + r() * 4.2)),
      defects: Number((r() * 3.4).toFixed(2)),
      owner: OWNERS[Math.floor(r() * OWNERS.length)],
      ship: d.toISOString().slice(0, 10),
    };
  });
})();

const ITEM_IDS = ['040-13-0001', '040-13-0007', '040-13-0009', '040-13-0010', '040-13-0286', '040-13-1986', '040-13-3568', '040-13-3577', '040-13-4863', '040-13-5120'];
const QTY = [816, 240, 624, 288, 240, 960, 384, 240, 960, 432];
const COLORS = ['Multicolored', 'Charcoal / Ecru', 'Black', 'Heather grey', 'Multicolored', 'Navy / White', 'Multicolored', 'Oatmeal', 'Black / Red', 'Multicolored'];
const SIZES = ['6-12', '6-12', '6-12', '6-12', '10-13', '6-12', '6-12', '10-13', '6-12', '6-12'];

export const ORDER_ITEMS: OrderItem[] = ITEM_IDS.map((id, i) => ({
  id,
  pack: i < 7 ? 'SOLID' : 'ASSORTED',
  department: '40 — Mens essentials',
  klass: '13 — Performance socks',
  line: 'Apparel',
  category: 'Socks & hosiery',
  brand: 'All in Motion',
  style: 'PID-3G679W',
  color: COLORS[i],
  size: SIZES[i],
  casePack: 24,
  qty: QTY[i],
  cartons: Math.round(QTY[i] / 24),
}));

export const STAGES: Stage[] = [
  { key: 'rm', label: 'Raw material arrival' },
  { key: 'trims', label: 'Production trims & accessories' },
  { key: 'cut', label: 'Cutting' },
  { key: 'print', label: 'Cutting printing' },
  { key: 'knit', label: 'Sewing / knitting / weaving' },
  { key: 'asm', label: 'Assembly' },
  { key: 'fin', label: 'Finishing' },
  { key: 'pack', label: 'Packing' },
];

const PATTERN = [100, 100, 100, 0, 100, 62, 24, 0];

export const PRODUCTION: ProductionRow[] = (() => {
  const r = seeded(23);
  return ORDER_ITEMS.map((it) => {
    const stages: Record<string, { pct: number; qty: number }> = {};
    STAGES.forEach((s, si) => {
      let pct = PATTERN[si];
      if (pct > 0 && pct < 100) pct = Math.max(0, Math.min(100, Math.round((pct + (r() * 40 - 20)) / 4) * 4));
      stages[s.key] = { pct, qty: Math.round((it.qty * pct) / 100) };
    });
    return { id: it.id, style: it.style, qty: it.qty, stages };
  });
})();

export const MILESTONES: Milestone[] = [
  { name: 'Placement meeting', required: false, start: null, end: null, state: 'none' },
  { name: 'TPR meeting pass', required: false, start: null, end: null, state: 'none' },
  { name: 'Raw material arrival', required: true, start: '2026-05-05', end: '2026-05-10', state: 'done' },
  { name: 'Production trims & accessories', required: true, start: '2026-05-17', end: '2026-05-18', state: 'done' },
  { name: 'Cutting', required: false, start: null, end: null, state: 'none' },
  { name: 'Cutting printing (placement)', required: false, start: null, end: null, state: 'none' },
  { name: 'Sewing / knitting / weaving', required: true, start: '2026-06-01', end: '2026-06-28', state: 'done' },
  { name: 'Assembly', required: true, start: '2026-07-04', end: '2026-07-19', state: 'late' },
  { name: 'Finishing (plating, painting)', required: true, start: '2026-07-24', end: '2026-08-07', state: 'planned' },
  { name: 'DUPRO pass', required: false, start: null, end: null, state: 'none' },
  { name: 'Packing', required: true, start: '2026-08-30', end: '2026-09-01', state: 'planned' },
  { name: 'Top testing pass', required: false, start: null, end: null, state: 'none' },
  { name: 'FRI pass', required: true, start: null, end: '2026-10-19', state: 'planned' },
  { name: 'Shipment booking', required: true, start: null, end: '2026-10-10', state: 'integration' },
  { name: 'Cargo ready date', required: true, start: null, end: null, state: 'integration' },
];

export const STAKEHOLDERS: Stakeholder[] = [
  { role: 'Brand / retailer contact', name: 'Zia Mohyuddin', org: 'Target Corporation', email: 'z.mohyuddin@target.com' },
  { role: 'Merchandiser', name: 'Bilal Raza', org: 'Interloop — Apparel', email: 'b.raza@interloop.com.pk' },
  { role: 'Quality manager', name: 'Ayesha Khan', org: 'Interloop — Quality', email: 'a.khan@interloop.com.pk' },
  { role: 'Production planner', name: 'Zain Abbas', org: 'Interloop — Plant 4', email: 'z.abbas@interloop.com.pk' },
  { role: 'Vendor QA', name: 'Hina Malik', org: 'Loop Industries (sub-contract)', email: 'h.malik@loopind.pk' },
  { role: 'Logistics', name: 'Usman Tariq', org: 'Interloop — Export', email: 'u.tariq@interloop.com.pk' },
];

const at = (dayOffset: number, hh: number, mm: number) => {
  const d = new Date('2026-08-02T14:20:00');
  d.setDate(d.getDate() - dayOffset);
  d.setHours(hh, mm, 0, 0);
  return d.toISOString();
};

export const ACTIVITIES = [
  { id: 'o1', type: 'status' as const, actor: { name: 'Zain Abbas', role: 'Planner' }, action: 'moved milestone', target: 'Assembly', time: at(0, 11, 20), from: 'In progress', to: 'Completed late', toTone: 'warning' as const },
  { id: 'o2', type: 'comment' as const, actor: { name: 'Zia Mohyuddin', role: 'Target' }, action: 'commented on', target: 'PO 8757222', time: at(0, 9, 5), body: 'Please confirm the revised cargo-ready date before Friday — the DC appointment is already booked.' },
  { id: 'o3', type: 'upload' as const, actor: { name: 'Ayesha Khan' }, action: 'attached the DUPRO worksheet to', target: 'INSP-77219', time: at(1, 16, 40), attachments: [{ name: 'dupro-040-13.pdf', size: '412 KB' }] },
  { id: 'o4', type: 'flag' as const, actor: { name: 'Sana Iqbal', role: 'QA Lead' }, action: 'raised a defect on lot', target: 'ILP-10482', time: at(1, 13, 55), body: 'Third roll shows bowing on the left selvedge. Holding the pallet.', tags: ['Skewness', 'AQL 2.5'] },
  { id: 'o5', type: 'system' as const, action: 'Production status synced from', target: 'HMS Oracle', time: at(2, 5, 30) },
];
