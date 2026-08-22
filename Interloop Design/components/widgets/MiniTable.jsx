import React from 'react';

const CSS = `
.ilp-mt{width:100%;font-family:var(--font-sans);border-collapse:collapse}
.ilp-mt th,.ilp-mt td{text-align:left;white-space:nowrap}
.ilp-mt thead th{padding:9px 16px;font-size:10px;font-weight:var(--weight-bold);letter-spacing:.07em;text-transform:uppercase;color:var(--text-muted);background:var(--il-grayblue-50);border-bottom:1px solid var(--border-subtle)}
.ilp-mt--plain thead th{background:transparent;border-bottom:1px solid var(--border-default)}
.ilp-mt tbody td{padding:12px 16px;font-size:var(--fs-sm);line-height:1.4;color:var(--text-primary);border-bottom:1px solid var(--border-subtle)}
.ilp-mt--compact tbody td{padding:8px 16px}
.ilp-mt tbody tr:last-child td{border-bottom:0}
.ilp-mt--zebra tbody tr:nth-child(even) td{background:var(--il-grayblue-50)}
.ilp-mt--hover tbody tr{transition:background var(--dur-fast) var(--ease-standard)}
.ilp-mt--hover tbody tr:hover td{background:var(--il-grayblue-50)}
.ilp-mt--click tbody tr{cursor:pointer}
.ilp-mt--click tbody tr:focus-visible{outline:none}
.ilp-mt--click tbody tr:focus-visible td{background:var(--il-blue-50);box-shadow:inset 0 1px 0 var(--border-focus),inset 0 -1px 0 var(--border-focus)}
.ilp-mt__num{text-align:right;font-variant-numeric:tabular-nums}
.ilp-mt__ctr{text-align:center}
.ilp-mt__muted{color:var(--text-secondary)}
.ilp-mt__strong{font-weight:var(--weight-bold)}
.ilp-mt tfoot td{padding:11px 16px;font-size:var(--fs-sm);font-weight:var(--weight-bold);font-variant-numeric:tabular-nums;background:var(--il-grayblue-50);border-top:1px solid var(--border-default)}

.ilp-mt__cell{display:flex;align-items:center;gap:10px;min-width:0}
.ilp-mt__cell--end{justify-content:flex-end}
.ilp-mt__ttl{display:flex;flex-direction:column;gap:2px;min-width:0}
.ilp-mt__ttl b{font-weight:var(--weight-bold);overflow:hidden;text-overflow:ellipsis}
.ilp-mt__ttl span{font-size:var(--fs-xs);color:var(--text-muted);overflow:hidden;text-overflow:ellipsis}
.ilp-mt__pill{display:inline-flex;align-items:center;gap:5px;height:21px;padding:0 9px;font-size:var(--fs-xs);font-weight:var(--weight-bold);border-radius:var(--radius-pill);background:var(--il-grayblue-100);color:var(--text-secondary)}
.ilp-mt__pill::before{content:"";width:5px;height:5px;border-radius:50%;background:currentColor}
.ilp-mt__pill--info{background:var(--il-blue-100);color:var(--il-blue-800)}
.ilp-mt__pill--success{background:var(--il-earth-soft);color:var(--il-earth-ink)}
.ilp-mt__pill--warning{background:var(--il-sun-soft);color:var(--il-sun-ink)}
.ilp-mt__pill--danger{background:var(--il-red-soft);color:var(--il-red-ink)}
.ilp-mt__bar{display:flex;align-items:center;gap:9px;justify-content:flex-end}
.ilp-mt__bar i{display:block;width:70px;height:5px;border-radius:3px;background:var(--il-grayblue-100);overflow:hidden;flex:none}
.ilp-mt__bar i b{display:block;height:100%;border-radius:3px;background:var(--brand-primary)}
.ilp-mt__bar span{min-width:34px;text-align:right;font-size:var(--fs-xs);font-weight:var(--weight-bold);font-variant-numeric:tabular-nums}
.ilp-mt__av{display:grid;place-items:center;width:30px;height:30px;flex:none;border-radius:50%;font-size:11px;font-weight:var(--weight-bold);color:#fff}
.ilp-mt__wrap{width:100%;overflow-x:auto}
.ilp-mt__empty{padding:32px 16px;text-align:center;font-size:var(--fs-sm);color:var(--text-muted)}
`;

function useCSS() {
  React.useEffect(() => {
    if (document.getElementById('ilp-mt-css')) return;
    const s = document.createElement('style');
    s.id = 'ilp-mt-css';
    s.textContent = CSS;
    document.head.appendChild(s);
  }, []);
}

const TINTS = ['var(--il-blue-500)', 'var(--il-air)', 'var(--il-sun)', 'var(--il-earth)', 'var(--il-grayblue-500)'];
const initials = (n) => n.trim().split(/\s+/).slice(0, 2).map((p) => p[0]?.toUpperCase() || '').join('');
const tint = (n) => TINTS[[...n].reduce((a, c) => a + c.charCodeAt(0), 0) % TINTS.length];
const get = (row, key) => (key.indexOf('.') < 0 ? row[key] : key.split('.').reduce((o, k) => (o == null ? o : o[k]), row));

/** Status pill for a table cell. */
export function TableStatus({ tone = 'neutral', children }) {
  useCSS();
  return <span className={'ilp-mt__pill' + (tone !== 'neutral' ? ' ilp-mt__pill--' + tone : '')}>{children}</span>;
}

/** Name + secondary line, with an optional avatar. */
export function TableIdentity({ name, meta, avatar, showAvatar = true }) {
  useCSS();
  return (
    <span className="ilp-mt__cell">
      {showAvatar && (avatar
        ? <img className="ilp-mt__av" src={avatar} alt="" />
        : <span className="ilp-mt__av" style={{ background: tint(name) }}>{initials(name)}</span>)}
      <span className="ilp-mt__ttl"><b>{name}</b>{meta && <span>{meta}</span>}</span>
    </span>
  );
}

/** Inline progress cell. */
export function TableBar({ value, color, label }) {
  useCSS();
  const pct = Math.max(0, Math.min(100, value));
  return (
    <span className="ilp-mt__bar">
      <i><b style={{ width: pct + '%', background: color }} /></i>
      <span>{label ?? `${Math.round(pct)}%`}</span>
    </span>
  );
}

/**
 * Compact read-only table for dashboard widgets — the small sibling of
 * DataGrid, with no toolbar, paging or virtualisation.
 */
export function MiniTable({
  columns = [],
  rows = [],
  rowKey = 'id',
  totals = null,
  zebra = false,
  density,
  compact: compactProp = false,
  plainHead = false,
  hover = true,
  onRowClick,
  emptyMessage = 'Nothing to show',
  className = '',
  ...rest
}) {
  useCSS();
  const compact = density ? density === 'compact' : compactProp;
  const keyOf = (r, i) => (typeof rowKey === 'function' ? rowKey(r) : (r[rowKey] ?? i));
  const cls = (c) => (c.align === 'right' || c.numeric ? 'ilp-mt__num' : c.align === 'center' ? 'ilp-mt__ctr' : '');

  if (rows.length === 0) return <div className="ilp-mt__empty">{emptyMessage}</div>;

  return (
    <div className="ilp-mt__wrap">
      <table
        className={'ilp-mt' + (zebra ? ' ilp-mt--zebra' : '') + (compact ? ' ilp-mt--compact' : '')
          + (plainHead ? ' ilp-mt--plain' : '') + (hover ? ' ilp-mt--hover' : '') + (onRowClick ? ' ilp-mt--click' : '')
          + (className ? ' ' + className : '')}
        {...rest}
      >
        <thead>
          <tr>{columns.map((c) => <th key={c.key} className={cls(c)} style={c.width ? { width: c.width } : undefined}>{c.header}</th>)}</tr>
        </thead>
        <tbody>
          {rows.map((row, i) => (
            <tr
              key={keyOf(row, i)}
              tabIndex={onRowClick ? 0 : undefined}
              onClick={onRowClick ? () => onRowClick(row) : undefined}
              onKeyDown={onRowClick ? (e) => { if (e.key === 'Enter' || e.key === ' ') { e.preventDefault(); onRowClick(row); } } : undefined}
            >
              {columns.map((c) => (
                <td key={c.key} className={cls(c) + (c.muted ? ' ilp-mt__muted' : '') + (c.strong ? ' ilp-mt__strong' : '')}>
                  {c.render ? c.render(get(row, c.key), row) : c.format ? c.format(get(row, c.key), row) : get(row, c.key)}
                </td>
              ))}
            </tr>
          ))}
        </tbody>
        {totals && (
          <tfoot>
            <tr>{columns.map((c) => <td key={c.key} className={cls(c)}>{totals[c.key] ?? ''}</td>)}</tr>
          </tfoot>
        )}
      </table>
    </div>
  );
}
