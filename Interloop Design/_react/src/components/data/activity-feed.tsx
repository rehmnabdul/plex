import * as React from 'react';
import {
  AlertTriangle, ArrowRight, AtSign, Check, Clock, Cog,
  Flag, Inbox, MessageSquare, Upload, X,
} from 'lucide-react';
import { cn, dayLabel, relativeTime } from '@/lib/utils';
import { UserAvatar } from '@/components/ui/avatar';
import { Button } from '@/components/ui/button';
import { Skeleton } from '@/components/ui/skeleton';

export type ActivityTone = 'neutral' | 'info' | 'success' | 'warning' | 'danger' | 'brand';
export type ActivityType =
  | 'comment' | 'mention' | 'upload' | 'approval' | 'rejected'
  | 'status' | 'flag' | 'alert' | 'schedule' | 'system';

export interface ActivityItem {
  id: string;
  type?: ActivityType;
  tone?: ActivityTone;
  actor?: { name: string; src?: string; role?: string };
  /** Verb phrase in past tense — the component supplies actor and target. */
  action: string;
  target?: string;
  targetHref?: string;
  time: string | Date;
  body?: React.ReactNode;
  from?: string;
  to?: string;
  toTone?: ActivityTone;
  stats?: Array<{ label: string; value: string; trend?: 'up' | 'down' }>;
  attachments?: Array<{ name: string; size?: string; href?: string }>;
  tags?: string[];
  actions?: Array<{ id: string; label: string; primary?: boolean }>;
}

export interface ActivityFeedTab {
  id: string;
  label: string;
  types?: ActivityType[];
  count?: number;
}

const TYPES: Record<ActivityType, { icon: React.ElementType; tone: ActivityTone }> = {
  comment: { icon: MessageSquare, tone: 'info' },
  mention: { icon: AtSign, tone: 'info' },
  upload: { icon: Upload, tone: 'neutral' },
  approval: { icon: Check, tone: 'success' },
  rejected: { icon: X, tone: 'danger' },
  status: { icon: ArrowRight, tone: 'brand' },
  flag: { icon: Flag, tone: 'warning' },
  alert: { icon: AlertTriangle, tone: 'danger' },
  schedule: { icon: Clock, tone: 'neutral' },
  system: { icon: Cog, tone: 'neutral' },
};

const NODE_TONE: Record<ActivityTone, string> = {
  neutral: 'bg-card border-border text-muted-foreground',
  info: 'bg-info-soft border-[var(--il-blue-200)] text-[var(--il-blue-700)]',
  success: 'bg-success-soft border-[#dcebb4] text-success-ink',
  warning: 'bg-warning-soft border-[#fbdcc7] text-warning-ink',
  danger: 'bg-danger-soft border-[#f8cfcb] text-danger-ink',
  brand: 'bg-[var(--il-air-soft)] border-[#c8e2e2] text-[var(--il-air-ink)]',
};

const PILL_TONE: Record<string, string> = {
  info: 'bg-info-soft text-info-ink',
  success: 'bg-success-soft text-success-ink',
  warning: 'bg-warning-soft text-warning-ink',
  danger: 'bg-danger-soft text-danger-ink',
};

const EXT_COLOR: Record<string, string> = {
  pdf: 'bg-[var(--il-red)]', png: 'bg-[var(--il-air)]', jpg: 'bg-[var(--il-air)]',
  jpeg: 'bg-[var(--il-air)]', xlsx: 'bg-success-ink', csv: 'bg-success-ink',
};

export interface ActivityFeedProps {
  items: ActivityItem[];
  title?: string;
  tabs?: ActivityFeedTab[];
  activeTab?: string;
  onTabChange?: (id: string) => void;
  now?: Date;
  groupByDay?: boolean;
  dense?: boolean;
  hasMore?: boolean;
  loading?: boolean;
  onLoadMore?: () => void;
  onItemAction?: (actionId: string, item: ActivityItem) => void;
  endMessage?: string;
  emptyTitle?: string;
  emptyMessage?: string;
  maxHeight?: number | string;
  className?: string;
}

export function ActivityFeed({
  items, title, tabs, activeTab, onTabChange, now = new Date(),
  groupByDay = true, dense = false, hasMore = false, loading = false,
  onLoadMore, onItemAction,
  endMessage = 'You have reached the beginning of this activity log.',
  emptyTitle = 'Nothing here yet',
  emptyMessage = 'Activity on this record will appear as your team works on it.',
  maxHeight, className,
}: ActivityFeedProps) {
  const [internalTab, setInternalTab] = React.useState(activeTab ?? tabs?.[0]?.id ?? 'all');
  const current = activeTab ?? internalTab;

  const shown = React.useMemo(() => {
    const list = [...items].sort((a, b) => new Date(b.time).getTime() - new Date(a.time).getTime());
    if (!tabs || activeTab !== undefined) return list;
    const def = tabs.find((tab) => tab.id === current);
    if (!def?.types) return list;
    return list.filter((i) => def.types!.includes(i.type ?? 'system'));
  }, [items, tabs, current, activeTab]);

  const groups = React.useMemo(() => {
    if (!groupByDay) return [{ key: 'all', label: null as string | null, items: shown }];
    const map = new Map<string, { key: string; label: string; items: ActivityItem[] }>();
    for (const it of shown) {
      const key = new Date(it.time).toDateString();
      if (!map.has(key)) map.set(key, { key, label: dayLabel(it.time, now), items: [] });
      map.get(key)!.items.push(it);
    }
    return [...map.values()];
  }, [shown, groupByDay, now]);

  return (
    <div className={cn('flex min-h-0 flex-col', className)} style={maxHeight ? { maxHeight, height: maxHeight } : undefined}>
      {(title || tabs) && (
        <div className="flex flex-wrap items-center gap-3 pb-4">
          {title && <h3 className="mr-auto text-lg font-bold tracking-tight">{title}</h3>}
          {tabs && (
            <div className="flex gap-0.5 rounded-full bg-secondary p-[3px]" role="tablist">
              {tabs.map((tab) => (
                <button
                  key={tab.id} type="button" role="tab" aria-selected={current === tab.id}
                  onClick={() => { setInternalTab(tab.id); onTabChange?.(tab.id); }}
                  className={cn(
                    'inline-flex h-7 items-center gap-1.5 rounded-full px-3.5 text-sm font-semibold text-muted-foreground transition-colors hover:text-foreground',
                    current === tab.id && 'bg-card text-foreground shadow-[var(--shadow-xs)]',
                  )}
                >
                  {tab.label}
                  {tab.count != null && <span className="text-xs font-bold tabular-nums text-muted-foreground">{tab.count}</span>}
                </button>
              ))}
            </div>
          )}
        </div>
      )}

      <div className="min-h-0 flex-1 overflow-y-auto overscroll-contain pr-0.5">
        {loading && shown.length === 0 ? (
          Array.from({ length: 4 }, (_, i) => (
            <div key={i} className="mb-5 grid grid-cols-[34px_minmax(0,1fr)] gap-4">
              <Skeleton className="size-[34px] rounded-full" />
              <div className="space-y-2 pt-2">
                <Skeleton className="h-3 w-[62%]" />
                <Skeleton className="h-3 w-[38%]" />
              </div>
            </div>
          ))
        ) : shown.length === 0 ? (
          <div className="flex flex-col items-center gap-2 py-14 text-center text-muted-foreground">
            <Inbox className="size-6 opacity-50" />
            <b className="text-base text-foreground/70">{emptyTitle}</b>
            <span className="max-w-[34ch] text-sm">{emptyMessage}</span>
          </div>
        ) : (
          groups.map((group) => (
            <section key={group.key}>
              {group.label && (
                <header className="sticky top-0 z-10 flex items-center gap-3 bg-gradient-to-b from-card from-[62%] to-transparent pb-3.5 pt-1.5">
                  <span className={cn('whitespace-nowrap text-[11px] font-bold uppercase tracking-[0.08em] text-muted-foreground', group.label === 'Today' && 'text-[var(--il-blue-600)]')}>
                    {group.label}
                  </span>
                  <span className="h-px flex-1 bg-[var(--il-grayblue-100)]" />
                  <span className="text-[11px] font-semibold tabular-nums text-muted-foreground/70">{group.items.length}</span>
                </header>
              )}
              <div className="flex flex-col">
                {group.items.map((item, index) => {
                  const def = TYPES[item.type ?? 'system'];
                  const Icon = def.icon;
                  const tone = item.tone ?? def.tone;
                  const last = index === group.items.length - 1;
                  return (
                    <article key={item.id} className={cn('relative grid gap-4', dense ? 'grid-cols-[26px_minmax(0,1fr)] pb-4' : 'grid-cols-[34px_minmax(0,1fr)] pb-5')}>
                      <div className="relative flex justify-center">
                        {!last && <span className={cn('absolute left-1/2 -ml-px w-0.5 bg-[var(--il-grayblue-100)]', dense ? 'top-[26px] -bottom-4' : 'top-[34px] -bottom-5')} />}
                        {item.actor?.src ? (
                          <UserAvatar name={item.actor.name} src={item.actor.src} size={dense ? 26 : 34} className="relative z-[1]" />
                        ) : (
                          <span className={cn('relative z-[1] grid shrink-0 place-items-center rounded-full border', dense ? 'size-[26px]' : 'size-[34px]', NODE_TONE[tone])}>
                            <Icon className={dense ? 'size-3' : 'size-[15px]'} />
                          </span>
                        )}
                      </div>

                      <div className={cn('min-w-0', dense ? 'pt-0.5' : 'pt-1')}>
                        <div className="flex flex-wrap items-baseline gap-1.5 text-sm leading-relaxed text-muted-foreground">
                          {item.actor && <span className="font-bold text-foreground">{item.actor.name}</span>}
                          <span>{item.action}</span>
                          {item.target && (item.targetHref
                            ? <a href={item.targetHref} className="font-semibold">{item.target}</a>
                            : <span className="font-semibold text-[var(--il-blue-600)]">{item.target}</span>)}
                          {item.actor?.role && <span className="text-xs text-muted-foreground">· {item.actor.role}</span>}
                          <time dateTime={new Date(item.time).toISOString()} className="ml-auto whitespace-nowrap pl-3 text-xs text-muted-foreground">
                            {relativeTime(item.time, now)}
                          </time>
                        </div>

                        {item.body && (
                          <div className="mt-2.5 rounded-md border border-[var(--il-grayblue-100)] bg-[var(--il-grayblue-50)] px-3.5 py-2.5 text-sm leading-relaxed text-foreground">
                            {item.body}
                          </div>
                        )}

                        {(item.from || item.to) && (
                          <div className="mt-2.5 inline-flex items-center gap-2 rounded-md border border-[var(--il-grayblue-100)] bg-card px-2.5 py-1.5">
                            {item.from && <span className="inline-flex h-5.5 items-center rounded-full bg-secondary px-2.5 text-xs font-semibold text-muted-foreground line-through opacity-75">{item.from}</span>}
                            <ArrowRight className="size-3.5 text-muted-foreground/60" />
                            {item.to && <span className={cn('inline-flex h-5.5 items-center rounded-full px-2.5 text-xs font-semibold', PILL_TONE[item.toTone ?? ''] ?? 'bg-secondary text-muted-foreground')}>{item.to}</span>}
                          </div>
                        )}

                        {item.stats && (
                          <div className="mt-3 flex flex-wrap gap-5 rounded-md bg-[var(--il-grayblue-50)] px-3.5 py-2.5">
                            {item.stats.map((s) => (
                              <div key={s.label} className="flex flex-col gap-0.5">
                                <span className="text-[10px] font-bold uppercase tracking-[0.07em] text-muted-foreground">{s.label}</span>
                                <b className={cn('text-base font-bold tabular-nums', s.trend === 'up' && 'text-success-ink', s.trend === 'down' && 'text-danger-ink')}>{s.value}</b>
                              </div>
                            ))}
                          </div>
                        )}

                        {item.attachments && (
                          <div className="mt-2.5 flex flex-wrap gap-2">
                            {item.attachments.map((f) => {
                              const ext = (f.name.split('.').pop() ?? '').toLowerCase();
                              return (
                                <a key={f.name} href={f.href ?? '#'} className="inline-flex items-center gap-2.5 rounded-md border border-border bg-card py-1.5 pl-2 pr-3 no-underline transition-colors hover:border-[var(--il-blue-300)]">
                                  <span className={cn('grid size-6.5 place-items-center rounded-sm text-[9px] font-bold uppercase text-white', EXT_COLOR[ext] ?? 'bg-[var(--il-grayblue-400)]')}>
                                    {ext.slice(0, 3)}
                                  </span>
                                  <span className="flex min-w-0 flex-col">
                                    <span className="max-w-[170px] truncate text-xs font-semibold text-foreground">{f.name}</span>
                                    {f.size && <span className="text-[10px] text-muted-foreground">{f.size}</span>}
                                  </span>
                                </a>
                              );
                            })}
                          </div>
                        )}

                        {item.tags && (
                          <div className="mt-2.5 flex flex-wrap gap-1.5">
                            {item.tags.map((tag) => (
                              <span key={tag} className="inline-flex h-5.5 items-center rounded-full border border-border bg-card px-2.5 text-xs font-semibold text-muted-foreground">{tag}</span>
                            ))}
                          </div>
                        )}

                        {item.actions && (
                          <div className="mt-3 flex gap-2">
                            {item.actions.map((a) => (
                              <Button key={a.id} size="sm" variant={a.primary ? 'default' : 'outline'} onClick={() => onItemAction?.(a.id, item)}>
                                {a.label}
                              </Button>
                            ))}
                          </div>
                        )}
                      </div>
                    </article>
                  );
                })}
              </div>
            </section>
          ))
        )}

        {shown.length > 0 && (hasMore ? (
          <div className="flex justify-center py-4">
            <Button variant="outline" className="rounded-full" disabled={loading} onClick={onLoadMore}>
              {loading ? 'Loading…' : 'Load earlier activity'}
            </Button>
          </div>
        ) : endMessage ? (
          <p className="py-4 text-center text-xs text-muted-foreground/70">{endMessage}</p>
        ) : null)}
      </div>
    </div>
  );
}
