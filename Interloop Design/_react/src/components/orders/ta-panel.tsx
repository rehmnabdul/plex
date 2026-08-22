import * as React from 'react';
import { Check, Pencil, Plug, Square } from 'lucide-react';
import { useTranslation } from 'react-i18next';
import { cn, formatDate } from '@/lib/utils';
import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import { UserAvatar } from '@/components/ui/avatar';
import { Card } from '@/components/ui/card';
import { ActivityFeed, type ActivityItem } from '@/components/data/activity-feed';
import type { Milestone, MilestoneState } from '@/lib/api/types';

const DATE_TONE: Record<string, string> = {
  done: 'text-success-ink', late: 'text-warning-ink',
  planned: 'text-muted-foreground', none: 'text-muted-foreground/60',
};

function MilestoneDate({ value, state, caption }: { value: string | null; state: MilestoneState; caption?: string | null }) {
  const Glyph = state === 'done' || state === 'late' ? Check : state === 'integration' ? Plug : Square;
  return (
    <span className={cn('inline-flex items-start gap-1.5 tabular-nums leading-snug', DATE_TONE[state === 'integration' ? 'planned' : state])}>
      <Glyph className="mt-px size-3.5 shrink-0" />
      <span>
        {value ? formatDate(value) : 'Not specified'}
        {caption && <em className="block text-[10px] not-italic text-muted-foreground">{caption}</em>}
      </span>
    </span>
  );
}

export interface TAPanelProps {
  order: { form: string; contact: string; plannedShip: string };
  milestones: Milestone[];
  activities: ActivityItem[];
  now?: Date;
}

export function TAPanel({ order, milestones, activities, now }: TAPanelProps) {
  const { t } = useTranslation();
  const [done, setDone] = React.useState<Set<string>>(
    () => new Set(milestones.filter((m) => m.state === 'done' || m.state === 'late').map((m) => m.name)),
  );

  const toggle = (name: string) =>
    setDone((s) => {
      const next = new Set(s);
      next.has(name) ? next.delete(name) : next.add(name);
      return next;
    });

  return (
    <>
      <Card>
        <header className="flex items-center gap-3 px-4.5 pb-3 pt-4">
          <span className="mr-auto text-base font-bold">{t('LoopConsole::Order:TimeAndAction')}</span>
          <Badge variant="warning">In progress</Badge>
        </header>

        <dl className="flex flex-col gap-2.5 px-4.5 pb-4 text-sm">
          <Row label="Form name"><span className="font-semibold">{order.form}</span></Row>
          <Row label="Brand contact">
            <span className="flex min-w-0 items-center gap-1.5 font-semibold">
              <UserAvatar name={order.contact} size={20} />
              <span className="truncate">{order.contact}</span>
            </span>
            <EditButton label="Edit brand contact" />
          </Row>
          <Row label="Planned ship begin">
            <span className="font-semibold">{formatDate(order.plannedShip)}</span>
            <EditButton label="Edit planned ship date" />
          </Row>
          <Row label="On-time shipment plan"><Badge variant="success" dot>On time</Badge></Row>
          <Row label="Late reason code"><span className="text-muted-foreground/70">Not applicable</span></Row>
        </dl>

        <div className="border-t border-[var(--il-grayblue-100)]">
          <div className="max-h-[340px] overflow-y-auto">
            <table className="w-full border-collapse">
              <thead>
                <tr>
                  {['Milestone', 'Start date', 'End date'].map((h, i) => (
                    <th key={h} className={cn('sticky top-0 z-10 border-b border-border bg-[var(--il-grayblue-50)] px-3.5 py-2.5 text-left text-[10px] font-bold uppercase tracking-[0.06em] text-muted-foreground', i === 0 && 'w-[46%]')}>
                      {h}
                    </th>
                  ))}
                </tr>
              </thead>
              <tbody>
                {milestones.map((m) => {
                  const checked = done.has(m.name);
                  const state: MilestoneState = checked
                    ? (m.state === 'late' ? 'late' : 'done')
                    : m.state === 'integration' ? 'integration' : m.state === 'planned' ? 'planned' : 'none';
                  const caption = state === 'planned' ? 'Planned' : state === 'integration' ? 'From integration' : null;
                  return (
                    <tr key={m.name} className="hover:bg-[var(--il-grayblue-50)]">
                      <td className="border-b border-[var(--il-grayblue-100)] px-3.5 py-2.5 align-top text-xs font-semibold leading-snug">
                        {m.required && <span className="font-bold text-destructive">* </span>}
                        {m.name}
                      </td>
                      <td className="border-b border-[var(--il-grayblue-100)] px-3.5 py-2.5 align-top text-xs">
                        <MilestoneDate value={m.start} state={m.start ? state : 'none'} />
                      </td>
                      <td className="border-b border-[var(--il-grayblue-100)] px-3.5 py-2.5 align-top text-xs">
                        <button type="button" onClick={() => toggle(m.name)} aria-pressed={checked} aria-label={`Toggle ${m.name}`}>
                          <MilestoneDate value={m.end} state={state} caption={m.end && !checked ? caption : null} />
                        </button>
                      </td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
          </div>

          <div className="flex items-center gap-3 border-t border-[var(--il-grayblue-100)] px-4 py-3">
            <a href="#bulk" className="text-sm">{t('LoopConsole::Order:BulkComplete')}</a>
            <Button size="sm" className="ml-auto">{t('LoopConsole::Common:Complete')}</Button>
          </div>

          <div className="flex flex-wrap gap-3.5 px-4 pb-3.5 text-[10px] text-muted-foreground">
            <Legend className="text-success-ink">On time</Legend>
            <Legend className="text-warning-ink">Late completion</Legend>
            <Legend className="text-danger-ink">Overdue</Legend>
            <span><b className="text-destructive">*</b> is required</span>
            <span className="ml-auto tabular-nums">{done.size} of {milestones.length} complete</span>
          </div>
        </div>
      </Card>

      <Card>
        <header className="flex items-center gap-3 px-4.5 pb-3 pt-4">
          <span className="mr-auto text-base font-bold">{t('LoopConsole::Order:Activities')}</span>
          <a href="#all" className="text-xs">View all</a>
        </header>
        <div className="px-4.5 pb-3.5">
          <ActivityFeed items={activities} now={now} dense maxHeight={300} endMessage="" />
        </div>
      </Card>
    </>
  );
}

const Row = ({ label, children }: { label: string; children: React.ReactNode }) => (
  <div className="grid grid-cols-[130px_minmax(0,1fr)] items-baseline gap-3">
    <dt className="text-xs text-muted-foreground">{label}</dt>
    <dd className="m-0 flex min-w-0 items-center gap-1.5">{children}</dd>
  </div>
);

const EditButton = ({ label }: { label: string }) => (
  <button type="button" aria-label={label} className="grid size-5 shrink-0 place-items-center rounded-xs text-primary hover:bg-info-soft">
    <Pencil className="size-3" />
  </button>
);

const Legend = ({ className, children }: { className?: string; children: React.ReactNode }) => (
  <span className={cn('inline-flex items-center gap-1.5', className)}>
    <i className="inline-block size-2.5 rounded-[3px] border-[1.5px] border-current" />
    {children}
  </span>
);
