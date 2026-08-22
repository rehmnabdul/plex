import { z } from 'zod';

export const divisions = ['Hosiery', 'Denim', 'Apparel', 'Activewear', 'Yarns'] as const;
export const orderStatuses = ['Planned', 'In production', 'QC hold', 'Shipped', 'Delayed'] as const;
export const plants = ['Faisalabad I', 'Faisalabad II', 'Lahore', 'Sialkot'] as const;

export const orderSchema = z.object({
  id: z.string(),
  client: z.string(),
  division: z.enum(divisions),
  plant: z.enum(plants),
  status: z.enum(orderStatuses),
  units: z.number().int().nonnegative(),
  value: z.number().nonnegative(),
  defects: z.number().min(0).max(100),
  owner: z.string(),
  ship: z.string(),
});
export type Order = z.infer<typeof orderSchema>;

export const orderQuerySchema = z.object({
  page: z.number().int().positive().default(1),
  pageSize: z.number().int().positive().default(25),
  sorting: z.string().nullable().default(null),
  filter: z.string().default(''),
  columnFilters: z.record(z.string()).default({}),
});
export type OrderQuery = z.infer<typeof orderQuerySchema>;

/** New-order form — React Hook Form + zodResolver consume this directly. */
export const newOrderSchema = z.object({
  client: z.string().min(2, 'Client name is required'),
  division: z.enum(divisions, { required_error: 'Pick a division' }),
  plant: z.enum(plants, { required_error: 'Pick a plant' }),
  units: z.coerce.number().int().positive('Units must be greater than zero'),
  ship: z.string().min(1, 'Ship date is required'),
  rush: z.boolean().default(false),
  notes: z.string().max(280, 'Keep notes under 280 characters').optional(),
});
export type NewOrderInput = z.infer<typeof newOrderSchema>;

export const orderItemSchema = z.object({
  id: z.string(),
  pack: z.string(),
  department: z.string(),
  klass: z.string(),
  line: z.string(),
  category: z.string(),
  brand: z.string(),
  style: z.string(),
  color: z.string(),
  size: z.string(),
  casePack: z.number(),
  qty: z.number(),
  cartons: z.number(),
});
export type OrderItem = z.infer<typeof orderItemSchema>;

export type MilestoneState = 'done' | 'late' | 'planned' | 'integration' | 'none';
export interface Milestone {
  name: string;
  required: boolean;
  start: string | null;
  end: string | null;
  state: MilestoneState;
}

export interface StageCell { pct: number; qty: number }
export interface ProductionRow { id: string; style: string; qty: number; stages: Record<string, StageCell> }
export interface Stage { key: string; label: string }

export interface Stakeholder { role: string; name: string; org: string; email: string }
