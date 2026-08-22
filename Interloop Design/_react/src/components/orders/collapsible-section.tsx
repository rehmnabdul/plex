import * as React from 'react';
import { ChevronRight } from 'lucide-react';
import { cn } from '@/lib/utils';
import { Card } from '@/components/ui/card';

export interface CollapsibleSectionProps {
  title: string;
  tail?: React.ReactNode;
  defaultOpen?: boolean;
  children: React.ReactNode;
  className?: string;
}

/** Card with a disclosure header — the order-detail page's structural unit. */
export function CollapsibleSection({ title, tail, defaultOpen = true, children, className }: CollapsibleSectionProps) {
  const [open, setOpen] = React.useState(defaultOpen);
  return (
    <Card className={className}>
      <button
        type="button"
        aria-expanded={open}
        onClick={() => setOpen((o) => !o)}
        className="flex w-full items-center gap-2.5 rounded-t-lg px-5 py-4 text-left text-base font-bold hover:bg-[var(--il-grayblue-50)]"
      >
        <ChevronRight className={cn('size-4 text-muted-foreground transition-transform', open && 'rotate-90')} />
        {title}
        {tail && <span className="ml-auto flex items-center gap-2.5 text-xs font-semibold text-muted-foreground">{tail}</span>}
      </button>
      {open && <div className="border-t border-[var(--il-grayblue-100)] p-5">{children}</div>}
    </Card>
  );
}

/** Labelled fact grid — replaces a one-row table that can't survive a narrow screen. */
export function FactGrid({ facts }: { facts: Array<{ label: string; value?: React.ReactNode }> }) {
  return (
    <dl className="grid grid-cols-[repeat(auto-fit,minmax(150px,1fr))] gap-x-6 gap-y-[18px]">
      {facts.map((f) => (
        <div key={f.label}>
          <dt className="mb-1 text-[10px] font-bold uppercase tracking-[0.08em] text-muted-foreground">{f.label}</dt>
          <dd className={cn('m-0 text-sm font-bold tabular-nums', !f.value && 'font-normal text-muted-foreground/60')}>
            {f.value ?? '—'}
          </dd>
        </div>
      ))}
    </dl>
  );
}
