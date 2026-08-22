import * as React from 'react';
import { ArrowDownRight, ArrowUpRight } from 'lucide-react';
import { cn } from '@/lib/utils';
import { Card } from '@/components/ui/card';

export interface StatCardProps extends React.HTMLAttributes<HTMLDivElement> {
  label: string;
  value: React.ReactNode;
  /** Secondary line under the value. */
  hint?: string;
  /** Signed change, e.g. "+12.4%". `direction` colours it. */
  delta?: string;
  direction?: 'up' | 'down' | 'flat';
  /** "up is bad" metrics — defect rate, returns. @default false */
  invert?: boolean;
  icon?: React.ReactNode;
  /** Accent stripe down the left edge. */
  tone?: 'brand' | 'success' | 'warning' | 'danger' | 'none';
}

const STRIPE = {
  brand: 'var(--primary)', success: 'var(--success)',
  warning: 'var(--warning)', danger: 'var(--destructive)', none: 'transparent',
} as const;

export function StatCard({
  label, value, hint, delta, direction = 'flat', invert = false,
  icon, tone = 'none', className, ...props
}: StatCardProps) {
  const good = direction === 'flat' ? null : invert ? direction === 'down' : direction === 'up';
  const Arrow = direction === 'down' ? ArrowDownRight : ArrowUpRight;
  return (
    <Card className={cn('relative overflow-hidden p-5', className)} {...props}>
      {tone !== 'none' && (
        <span className="absolute inset-y-0 left-0 w-1" style={{ background: STRIPE[tone] }} aria-hidden />
      )}
      <div className="flex items-start gap-3">
        <div className="min-w-0 flex-1">
          <p className="text-[11px] font-bold uppercase tracking-[0.07em] text-muted-foreground">{label}</p>
          <p className="mt-1.5 text-3xl font-extrabold tabular-nums leading-none tracking-tight">{value}</p>
          <div className="mt-2 flex items-center gap-2">
            {delta && (
              <span
                className={cn(
                  'inline-flex items-center gap-0.5 rounded-full px-1.5 py-0.5 text-xs font-bold',
                  good === null && 'bg-secondary text-muted-foreground',
                  good === true && 'bg-success-soft text-success-ink',
                  good === false && 'bg-danger-soft text-danger-ink',
                )}
              >
                {direction !== 'flat' && <Arrow className="size-3" />}
                {delta}
              </span>
            )}
            {hint && <span className="truncate text-xs text-muted-foreground">{hint}</span>}
          </div>
        </div>
        {icon && (
          <span className="flex size-10 shrink-0 items-center justify-center rounded-lg bg-info-soft text-info-ink [&_svg]:size-5">
            {icon}
          </span>
        )}
      </div>
    </Card>
  );
}
