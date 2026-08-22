import * as React from 'react';
import { FileSpreadsheet, Maximize2 } from 'lucide-react';
import { cn, formatNumber } from '@/lib/utils';
import { Button } from '@/components/ui/button';
import type { ProductionRow, Stage } from '@/lib/api/types';

function Pct({ pct }: { pct: number }) {
  return (
    <span className="inline-flex w-full items-center justify-end gap-2">
      <i className="h-1 w-[34px] shrink-0 overflow-hidden rounded-full bg-[var(--il-grayblue-100)]">
        <b className={cn('block h-full rounded-full', pct === 100 ? 'bg-success' : 'bg-primary')} style={{ width: `${pct}%` }} />
      </i>
      <span className={cn('min-w-[34px] text-right', pct === 100 && 'font-bold text-success-ink', pct === 0 && 'text-muted-foreground/60')}>
        {pct}%
      </span>
    </span>
  );
}

const LEAD = [
  { key: 'id', label: 'Item ID', width: 132, left: 0 },
  { key: 'style', label: 'Style ID', width: 118, left: 132 },
  { key: 'qty', label: 'Order qty', width: 104, left: 250 },
];

export interface ProductionMatrixProps {
  rows: ProductionRow[];
  stages: Stage[];
}

/**
 * Two-row header (stage → % / Qty), three frozen lead columns, sticky totals.
 * A real grid can't express banded column groups, so this stays hand-built.
 */
export function ProductionMatrix({ rows, stages }: ProductionMatrixProps) {
  const [level, setLevel] = React.useState<'item' | 'po'>('item');
  const totalQty = rows.reduce((s, r) => s + r.qty, 0);
  const stageTotals = stages.map((s) => rows.reduce((sum, r) => sum + r.stages[s.key].qty, 0));

  const display: ProductionRow[] = level === 'item' ? rows : [{
    id: 'PO 8757222', style: '—', qty: totalQty,
    stages: Object.fromEntries(stages.map((s, i) => [s.key, {
      pct: totalQty ? Math.round((stageTotals[i] / totalQty) * 100) : 0,
      qty: stageTotals[i],
    }])),
  }];

  const headCell = 'sticky z-30 border-b border-border bg-[var(--il-grayblue-50)] px-3 py-2 text-center text-[10px] font-bold uppercase tracking-[0.06em] text-muted-foreground whitespace-nowrap';
  const bodyCell = 'border-b border-[var(--il-grayblue-100)] bg-card px-3 py-2.5 text-right text-sm tabular-nums whitespace-nowrap';

  return (
    <>
      <div className="mb-3.5 flex flex-wrap items-center gap-2.5">
        <div className="flex gap-0.5 rounded-md bg-secondary p-[3px]">
          {(['item', 'po'] as const).map((l) => (
            <button
              key={l} type="button" aria-pressed={level === l} onClick={() => setLevel(l)}
              className={cn('h-7 rounded-sm px-3.5 text-sm font-semibold text-muted-foreground', level === l && 'bg-card text-foreground shadow-[var(--shadow-xs)]')}
            >
              {l === 'item' ? 'Item level' : 'PO level'}
            </button>
          ))}
        </div>
        <Button size="sm" variant="outline" className="ml-auto"><Maximize2 />View full table</Button>
        <Button size="sm" variant="outline"><FileSpreadsheet />Excel</Button>
        <Button size="sm">Update</Button>
      </div>

      <div className="max-h-[520px] overflow-auto rounded-md border border-border">
        <table className="w-full min-w-[1280px] border-separate border-spacing-0">
          <thead>
            <tr>
              {LEAD.map((c, i) => (
                <th
                  key={c.key} rowSpan={2}
                  style={{ left: c.left, minWidth: c.width, top: 0 }}
                  className={cn(headCell, 'sticky z-40 text-left', i === LEAD.length - 1 && 'after:absolute after:inset-y-0 after:right-0 after:w-px after:bg-border')}
                >
                  {c.label}
                </th>
              ))}
              {stages.map((s) => (
                <th key={s.key} colSpan={2} style={{ top: 0 }} className={cn(headCell, 'h-[38px] border-l border-border')}>{s.label}</th>
              ))}
            </tr>
            <tr>
              {stages.map((s) => (
                <React.Fragment key={s.key}>
                  <th style={{ top: 38 }} className={cn(headCell, 'h-[30px] border-l border-border')}>%</th>
                  <th style={{ top: 38 }} className={cn(headCell, 'h-[30px]')}>Qty</th>
                </React.Fragment>
              ))}
            </tr>
          </thead>
          <tbody>
            {display.map((r) => (
              <tr key={r.id} className="group">
                <td style={{ left: 0 }} className={cn(bodyCell, 'sticky z-20 text-left font-semibold group-hover:bg-[var(--il-grayblue-50)]')}>{r.id}</td>
                <td style={{ left: 132 }} className={cn(bodyCell, 'sticky z-20 text-left text-muted-foreground group-hover:bg-[var(--il-grayblue-50)]')}>{r.style}</td>
                <td style={{ left: 250 }} className={cn(bodyCell, 'sticky z-20 after:absolute after:inset-y-0 after:right-0 after:w-px after:bg-border group-hover:bg-[var(--il-grayblue-50)]')}>
                  {formatNumber(r.qty)}
                </td>
                {stages.map((s) => (
                  <React.Fragment key={s.key}>
                    <td className={cn(bodyCell, 'border-l border-[var(--il-grayblue-100)] group-hover:bg-[var(--il-grayblue-50)]')}><Pct pct={r.stages[s.key].pct} /></td>
                    <td className={cn(bodyCell, 'group-hover:bg-[var(--il-grayblue-50)]', !r.stages[s.key].qty && 'text-muted-foreground/60')}>
                      {formatNumber(r.stages[s.key].qty)}
                    </td>
                  </React.Fragment>
                ))}
              </tr>
            ))}
          </tbody>
          <tfoot>
            <tr>
              <td style={{ left: 0, bottom: 0 }} className="sticky z-20 border-t border-border bg-[var(--il-grayblue-50)] px-3 py-2.5 text-left text-sm font-bold">Total</td>
              <td style={{ left: 132, bottom: 0 }} className="sticky z-20 border-t border-border bg-[var(--il-grayblue-50)] px-3 py-2.5" />
              <td style={{ left: 250, bottom: 0 }} className="sticky z-20 border-t border-border bg-[var(--il-grayblue-50)] px-3 py-2.5 text-right text-sm font-bold tabular-nums after:absolute after:inset-y-0 after:right-0 after:w-px after:bg-border">
                {formatNumber(totalQty)}
              </td>
              {stages.map((s, i) => (
                <React.Fragment key={s.key}>
                  <td style={{ bottom: 0 }} className="sticky border-t border-border bg-[var(--il-grayblue-50)] px-3 py-2.5 text-right text-sm font-bold tabular-nums">
                    {totalQty ? Math.round((stageTotals[i] / totalQty) * 100) : 0}%
                  </td>
                  <td style={{ bottom: 0 }} className="sticky border-t border-border bg-[var(--il-grayblue-50)] px-3 py-2.5 text-right text-sm font-bold tabular-nums">
                    {formatNumber(stageTotals[i])}
                  </td>
                </React.Fragment>
              ))}
            </tr>
          </tfoot>
        </table>
      </div>
      <p className="pt-2.5 text-center text-xs text-muted-foreground">
        Total {level === 'item' ? `${rows.length} items` : '1 purchase order'} · horizontal scroll for later stages
      </p>
    </>
  );
}
