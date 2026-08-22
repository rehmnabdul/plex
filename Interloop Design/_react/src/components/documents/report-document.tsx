import * as React from 'react';
import { Printer } from 'lucide-react';
import { cn } from '@/lib/utils';
import { Button } from '@/components/ui/button';

export type DocumentTone = 'neutral' | 'info' | 'success' | 'warning' | 'danger';

export interface DocumentColumn<T = Record<string, unknown>> {
  key: string;
  header: string;
  numeric?: boolean;
  align?: 'left' | 'center' | 'right';
  width?: string | number;
  format?: (value: any, row: T) => React.ReactNode;
  render?: (value: any, row: T) => React.ReactNode;
}

export interface DocumentParty {
  label: string;
  name: string;
  address?: string;
  rows?: Array<{ label: string; value: React.ReactNode }>;
}

export interface ReportDocumentProps<T extends Record<string, any> = Record<string, any>> {
  /** Document class — the eyebrow, not the title. */
  kind?: string;
  number?: string;
  status?: { label: string; tone?: DocumentTone };
  logo?: React.ReactNode;
  issuer?: { name: string; lines?: string[] };
  parties?: DocumentParty[];
  meta?: Array<{ label: string; value: React.ReactNode; hint?: string }>;
  columns?: DocumentColumn<T>[];
  items?: T[];
  /** Field to band the line-item table by. */
  groupBy?: keyof T & string;
  summary?: Array<{ label: string; value: React.ReactNode; rule?: boolean }>;
  total?: { label?: string; value: React.ReactNode; note?: string };
  notes?: Array<{ title: string; body: React.ReactNode }>;
  blocks?: Array<{ title: string; rows: Array<{ label: string; value: React.ReactNode }> }>;
  signatures?: Array<{ role: string; name?: string; date?: string; mark?: string }>;
  footerNote?: React.ReactNode;
  footerRight?: React.ReactNode;
  paper?: 'a4' | 'letter' | 'fluid';
  toolbarTitle?: string;
  actions?: React.ReactNode;
  showPrint?: boolean;
  className?: string;
}

const STAMP: Record<DocumentTone, string> = {
  neutral: 'bg-secondary text-muted-foreground',
  info: 'bg-info-soft text-info-ink',
  success: 'bg-success-soft text-success-ink',
  warning: 'bg-warning-soft text-warning-ink',
  danger: 'bg-danger-soft text-danger-ink',
};

const PAPER = { a4: 794, letter: 816, fluid: undefined } as const;

const align = (c: DocumentColumn<any>) =>
  c.align === 'center' ? 'text-center' : c.align === 'right' || c.numeric ? 'text-right tabular-nums whitespace-nowrap' : 'text-left';

const Eyebrow = ({ children }: { children: React.ReactNode }) => (
  <span className="mb-1 block text-[10px] font-bold uppercase tracking-[0.08em] text-muted-foreground">{children}</span>
);

/**
 * Printable business document — invoice, inspection report, packing list.
 * The screen sheet is a preview; `Print / PDF` is the deliverable.
 */
export function ReportDocument<T extends Record<string, any>>({
  kind = 'Invoice', number, status, logo, issuer, parties = [], meta = [],
  columns = [], items = [], groupBy, summary = [], total, notes = [], blocks = [],
  signatures = [], footerNote, footerRight, paper = 'a4',
  toolbarTitle, actions, showPrint = true, className,
}: ReportDocumentProps<T>) {
  const grouped = React.useMemo(() => {
    if (!groupBy) return [{ key: null as string | null, items }];
    const map = new Map<string, T[]>();
    for (const item of items) {
      const key = String(item[groupBy] ?? '—');
      if (!map.has(key)) map.set(key, []);
      map.get(key)!.push(item);
    }
    return [...map.entries()].map(([key, list]) => ({ key, items: list }));
  }, [items, groupBy]);

  const width = PAPER[paper];

  return (
    <div className="flex flex-col items-center gap-5 bg-background px-4 py-6 print:block print:bg-white print:p-0">
      {(showPrint || actions || toolbarTitle) && (
        <div className="no-print flex w-full items-center gap-2" style={{ maxWidth: width }}>
          {toolbarTitle && <h1 className="mr-auto text-lg font-bold tracking-tight">{toolbarTitle}</h1>}
          {actions}
          {showPrint && <Button onClick={() => window.print()} size="sm"><Printer />Print / PDF</Button>}
        </div>
      )}

      <article
        className={cn('w-full overflow-hidden rounded-lg border border-[var(--il-grayblue-100)] bg-card shadow-[var(--shadow-md)]', 'print:rounded-none print:border-0 print:shadow-none', className)}
        style={{ maxWidth: width }}
      >
        <div className="px-12 py-11 print:p-0">
          <header className="flex items-start gap-6 border-b-2 border-ink pb-7">
            <div className="mr-auto flex min-w-0 flex-col gap-2.5">
              {logo}
              {issuer && (
                <address className="text-xs not-italic leading-relaxed text-muted-foreground">
                  <b className="block text-sm font-bold text-foreground">{issuer.name}</b>
                  {issuer.lines?.map((l) => <span key={l} className="block">{l}</span>)}
                </address>
              )}
            </div>
            <div className="shrink-0 text-right">
              <div className="text-[11px] font-bold uppercase tracking-[0.14em] text-muted-foreground">{kind}</div>
              {number && <p className="mt-1 text-2xl font-extrabold tabular-nums leading-tight tracking-tight">{number}</p>}
              {status && (
                <span className={cn('mt-2.5 inline-flex h-6.5 items-center gap-1.5 rounded-full px-3 text-[11px] font-bold uppercase tracking-[0.06em] print:[print-color-adjust:exact]', STAMP[status.tone ?? 'neutral'])}>
                  <span className="size-1.5 rounded-full bg-current" />{status.label}
                </span>
              )}
            </div>
          </header>

          {meta.length > 0 && (
            <div className="grid grid-cols-[repeat(auto-fit,minmax(120px,1fr))] gap-5 border-b border-[var(--il-grayblue-100)] py-5">
              {meta.map((m) => (
                <div key={m.label} className="min-w-0">
                  <Eyebrow>{m.label}</Eyebrow>
                  <span className="text-sm font-bold tabular-nums">{m.value}</span>
                  {m.hint && <span className="mt-0.5 block text-xs font-normal text-muted-foreground">{m.hint}</span>}
                </div>
              ))}
            </div>
          )}

          {parties.length > 0 && (
            <div className="grid grid-cols-[repeat(auto-fit,minmax(200px,1fr))] gap-6 py-6">
              {parties.map((p) => (
                <div key={p.label}>
                  <Eyebrow>{p.label}</Eyebrow>
                  <b className="mb-1 block text-base font-bold">{p.name}</b>
                  {p.address && <p className="whitespace-pre-line text-sm leading-relaxed text-muted-foreground">{p.address}</p>}
                  {p.rows && (
                    <dl className="mt-2.5 grid grid-cols-[auto_1fr] gap-x-3 gap-y-0.5 text-xs">
                      {p.rows.map((r) => (
                        <React.Fragment key={r.label}>
                          <dt className="text-muted-foreground">{r.label}</dt>
                          <dd className="m-0 font-semibold text-muted-foreground">{r.value}</dd>
                        </React.Fragment>
                      ))}
                    </dl>
                  )}
                </div>
              ))}
            </div>
          )}

          {columns.length > 0 && (
            <table className="mt-1 w-full border-collapse">
              <thead>
                <tr>
                  {columns.map((c, i) => (
                    <th
                      key={c.key}
                      style={{ width: c.width }}
                      className={cn(
                        'bg-ink px-3 py-2.5 text-[10px] font-bold uppercase tracking-[0.08em] text-white print:[print-color-adjust:exact]',
                        align(c),
                        i === 0 && 'rounded-l-sm',
                        i === columns.length - 1 && 'rounded-r-sm',
                      )}
                    >
                      {c.header}
                    </th>
                  ))}
                </tr>
              </thead>
              <tbody>
                {grouped.map((g) => (
                  <React.Fragment key={g.key ?? 'all'}>
                    {g.key && (
                      <tr>
                        <td colSpan={columns.length} className="px-3 pb-1.5 pt-3.5 text-[10px] font-bold uppercase tracking-[0.08em] text-muted-foreground">{g.key}</td>
                      </tr>
                    )}
                    {g.items.map((row, i) => (
                      <tr key={row.id ?? i} className="break-inside-avoid">
                        {columns.map((c) => (
                          <td key={c.key} className={cn('border-b border-[var(--il-grayblue-100)] px-3 py-3 align-top text-sm leading-snug', align(c))}>
                            {c.render ? c.render(row[c.key], row) : c.format ? c.format(row[c.key], row) : String(row[c.key] ?? '')}
                            {c.key === columns[0].key && row.note && (
                              <span className="mt-0.5 block text-xs font-normal text-muted-foreground">{row.note}</span>
                            )}
                          </td>
                        ))}
                      </tr>
                    ))}
                  </React.Fragment>
                ))}
              </tbody>
            </table>
          )}

          {(summary.length > 0 || total || notes.length > 0) && (
            <div className="grid grid-cols-[minmax(0,1fr)_300px] gap-8 break-inside-avoid pt-6">
              <div>
                {notes.map((n) => (
                  <React.Fragment key={n.title}>
                    <h4 className="mb-1.5 text-[10px] font-bold uppercase tracking-[0.08em] text-muted-foreground">{n.title}</h4>
                    <p className="mb-4 text-xs leading-relaxed text-muted-foreground">{n.body}</p>
                  </React.Fragment>
                ))}
              </div>
              <div>
                <div className="flex flex-col gap-2.5">
                  {summary.map((s) => (
                    <div key={s.label} className={cn('flex justify-between gap-4 text-sm text-muted-foreground', s.rule && 'border-t border-[var(--il-grayblue-100)] pt-2.5')}>
                      <span>{s.label}</span>
                      <b className="font-semibold tabular-nums text-foreground">{s.value}</b>
                    </div>
                  ))}
                </div>
                {total && (
                  <>
                    <div className="mt-1.5 flex items-baseline justify-between gap-4 rounded-md bg-ink px-4.5 py-4 text-white print:[print-color-adjust:exact]">
                      <span className="text-xs font-bold uppercase tracking-[0.1em] opacity-75">{total.label ?? 'Total'}</span>
                      <b className="text-2xl font-extrabold tabular-nums tracking-tight">{total.value}</b>
                    </div>
                    {total.note && <p className="mt-2 text-right text-xs text-muted-foreground">{total.note}</p>}
                  </>
                )}
              </div>
            </div>
          )}

          {blocks.length > 0 && (
            <div className="mt-8 grid grid-cols-[repeat(auto-fit,minmax(210px,1fr))] gap-5 border-t border-[var(--il-grayblue-100)] pt-6">
              {blocks.map((b) => (
                <section key={b.title} className="break-inside-avoid">
                  <h4 className="mb-2 text-[10px] font-bold uppercase tracking-[0.08em] text-muted-foreground">{b.title}</h4>
                  <dl className="flex flex-col gap-1.5">
                    {b.rows.map((r) => (
                      <div key={r.label} className="flex justify-between gap-3 text-xs leading-snug">
                        <dt className="whitespace-nowrap text-muted-foreground">{r.label}</dt>
                        <dd className="m-0 break-words text-right font-semibold">{r.value}</dd>
                      </div>
                    ))}
                  </dl>
                </section>
              ))}
            </div>
          )}

          {signatures.length > 0 && (
            <div className="mt-10 grid grid-cols-[repeat(auto-fit,minmax(170px,1fr))] gap-6">
              {signatures.map((s) => (
                <div key={s.role} className="break-inside-avoid">
                  <div className="flex h-8 items-end font-serif text-xl italic text-[var(--il-grayblue-600)]">{s.mark ?? ''}</div>
                  <div className="border-t border-[var(--il-grayblue-300)] pt-2">
                    <b className="block text-sm font-bold">{s.name || '\u00a0'}</b>
                    <span className="block text-xs text-muted-foreground">{s.role}{s.date ? ` · ${s.date}` : ''}</span>
                  </div>
                </div>
              ))}
            </div>
          )}
        </div>

        {(footerNote || footerRight) && (
          <footer className="flex items-center justify-between gap-4 border-t border-[var(--il-grayblue-100)] bg-[var(--il-grayblue-50)] px-12 py-4 text-[10px] leading-relaxed text-muted-foreground print:bg-transparent print:px-0">
            <span>{footerNote}</span>
            <span>{footerRight}</span>
          </footer>
        )}
      </article>
    </div>
  );
}
