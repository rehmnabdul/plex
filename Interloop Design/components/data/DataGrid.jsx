import React from 'react';

const CSS = `
.ilp-dg{--dg-row:44px;--dg-head:44px;display:flex;flex-direction:column;min-height:0;background:var(--surface-card);border:1px solid var(--border-default);border-radius:var(--radius-lg);box-shadow:var(--shadow-sm);font-family:var(--font-sans);color:var(--text-primary);overflow:hidden;position:relative;contain:layout style}
.ilp-dg--compact{--dg-row:34px;--dg-head:38px}
.ilp-dg *{box-sizing:border-box}

/* toolbar */
.ilp-dg__bar{display:flex;flex:none;align-items:center;gap:var(--space-2);padding:10px 12px;border-bottom:1px solid var(--border-subtle);flex-wrap:wrap;min-height:56px}
.ilp-dg__titles{display:flex;flex-direction:column;gap:2px;margin-right:auto;padding-right:8px}
.ilp-dg__title{font-family:var(--font-sans);font-size:var(--fs-base);font-weight:var(--weight-bold);letter-spacing:-0.01em;line-height:1.2}
.ilp-dg__sub{font-size:var(--fs-xs);color:var(--text-muted);line-height:1.2}
.ilp-dg__spacer{margin-left:auto}
.ilp-dg__search{position:relative;display:flex;align-items:center}
.ilp-dg__search svg{position:absolute;left:9px;width:15px;height:15px;color:var(--text-muted);pointer-events:none}
.ilp-dg__search input{height:32px;width:200px;padding:0 10px 0 30px;font:inherit;font-size:var(--fs-sm);color:var(--text-primary);background:var(--surface-card);border:1px solid var(--border-default);border-radius:var(--radius-md);outline:none;transition:border-color var(--dur-fast) var(--ease-standard),box-shadow var(--dur-fast) var(--ease-standard)}
.ilp-dg__search input:focus{border-color:var(--border-focus);box-shadow:var(--ring)}
.ilp-dg__search input::placeholder{color:var(--text-muted)}

.ilp-dg__tool{display:inline-flex;align-items:center;gap:6px;height:32px;padding:0 10px;font:inherit;font-size:var(--fs-sm);font-weight:var(--weight-semibold);color:var(--text-secondary);background:var(--surface-card);border:1px solid var(--border-default);border-radius:var(--radius-md);cursor:pointer;white-space:nowrap;transition:background var(--dur-fast) var(--ease-standard),color var(--dur-fast) var(--ease-standard),border-color var(--dur-fast) var(--ease-standard)}
.ilp-dg__tool:hover{background:var(--surface-hover);color:var(--text-primary);border-color:var(--border-strong)}
.ilp-dg__tool:focus-visible{outline:none;box-shadow:var(--ring)}
.ilp-dg__tool[aria-pressed="true"],.ilp-dg__tool[aria-expanded="true"]{background:var(--il-blue-100);border-color:var(--il-blue-300);color:var(--il-blue-800)}
.ilp-dg__tool svg{width:15px;height:15px}
.ilp-dg__count{display:inline-flex;align-items:center;justify-content:center;min-width:17px;height:17px;padding:0 5px;font-size:10px;font-weight:var(--weight-bold);color:#fff;background:var(--brand-primary);border-radius:var(--radius-pill)}

/* group chips */
.ilp-dg__chips{display:flex;align-items:center;gap:6px;flex-wrap:wrap}
.ilp-dg__chipslabel{font-size:var(--fs-xs);font-weight:var(--weight-bold);letter-spacing:.06em;text-transform:uppercase;color:var(--text-muted)}
.ilp-dg__chip{display:inline-flex;align-items:center;gap:5px;height:26px;padding:0 4px 0 10px;font-size:var(--fs-xs);font-weight:var(--weight-semibold);color:var(--il-blue-800);background:var(--il-blue-100);border:1px solid var(--il-blue-200);border-radius:var(--radius-pill)}
.ilp-dg__chip button{display:grid;place-items:center;width:17px;height:17px;padding:0;color:inherit;background:transparent;border:0;border-radius:50%;cursor:pointer}
.ilp-dg__chip button:hover{background:var(--il-blue-200)}
.ilp-dg__chip svg{width:11px;height:11px}

/* viewport + grid */
.ilp-dg__vp{position:relative;flex:1 1 auto;min-height:0;overflow:auto;overscroll-behavior:contain}
.ilp-dg__grid{position:relative;min-width:max-content}
.ilp-dg__head{position:sticky;top:0;z-index:3;background:var(--surface-card)}
.ilp-dg__hrow,.ilp-dg__frow,.ilp-dg__row{display:grid;align-items:stretch}
.ilp-dg__hrow{height:var(--dg-head);background:var(--il-grayblue-50);border-bottom:1px solid var(--border-default)}
.ilp-dg__frow{height:38px;background:var(--surface-card);border-bottom:1px solid var(--border-default)}

.ilp-dg__hc{position:relative;display:flex;align-items:center;gap:5px;padding:0 10px;font-size:var(--fs-xs);font-weight:var(--weight-bold);letter-spacing:.05em;text-transform:uppercase;color:var(--text-secondary);background:var(--il-grayblue-50);user-select:none;overflow:hidden}
.ilp-dg__hc--num{justify-content:flex-end}
.ilp-dg__hc--ctr{justify-content:center}
.ilp-dg__hc--sortable{cursor:pointer}
.ilp-dg__hc--sortable:hover{color:var(--text-primary)}
.ilp-dg__hc--sorted{color:var(--il-blue-700)}
.ilp-dg__hlabel{overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
.ilp-dg__sort{display:grid;place-items:center;width:13px;height:13px;flex:none;opacity:0;transition:opacity var(--dur-fast) var(--ease-standard)}
.ilp-dg__hc:hover .ilp-dg__sort,.ilp-dg__sort--on{opacity:1}
.ilp-dg__sort svg{width:11px;height:11px}
.ilp-dg__sortn{font-size:9px;font-weight:var(--weight-bold);color:var(--il-blue-700)}
.ilp-dg__menu{display:grid;place-items:center;width:20px;height:20px;margin-left:auto;flex:none;padding:0;color:var(--text-muted);background:transparent;border:0;border-radius:var(--radius-xs);cursor:pointer;opacity:0}
.ilp-dg__hc:hover .ilp-dg__menu,.ilp-dg__menu[aria-expanded="true"]{opacity:1}
.ilp-dg__menu:hover{background:var(--il-grayblue-200);color:var(--text-primary)}
.ilp-dg__menu svg{width:14px;height:14px}
.ilp-dg__grip{position:absolute;top:0;right:-3px;width:7px;height:100%;cursor:col-resize;z-index:2}
.ilp-dg__grip::after{content:"";position:absolute;top:20%;left:3px;width:1px;height:60%;background:var(--border-strong);opacity:0;transition:opacity var(--dur-fast) var(--ease-standard)}
.ilp-dg__grip:hover::after,.ilp-dg__grip--on::after{opacity:1;background:var(--brand-primary);width:2px}

/* filter row */
.ilp-dg__fc{display:flex;align-items:center;padding:0 6px;background:var(--surface-card);overflow:hidden}
.ilp-dg__fc input,.ilp-dg__fc select{width:100%;height:26px;padding:0 7px;font:inherit;font-size:var(--fs-xs);color:var(--text-primary);background:var(--surface-card);border:1px solid var(--border-subtle);border-radius:var(--radius-sm);outline:none}
.ilp-dg__fc input:focus,.ilp-dg__fc select:focus{border-color:var(--border-focus);box-shadow:var(--ring)}
.ilp-dg__fc input::placeholder{color:var(--text-disabled);text-transform:none;letter-spacing:0}
.ilp-dg__fc--on input,.ilp-dg__fc--on select{border-color:var(--il-blue-300);background:var(--il-blue-50)}

/* body */
.ilp-dg__rows{position:relative}
.ilp-dg__row{height:var(--dg-row);border-bottom:1px solid var(--border-subtle);background:var(--surface-card);transition:background var(--dur-fast) var(--ease-standard)}
.ilp-dg__row:hover{background:var(--il-grayblue-50)}
.ilp-dg__row:hover .ilp-dg__cell{background:var(--il-grayblue-50)}
.ilp-dg__row--sel,.ilp-dg__row--sel .ilp-dg__cell{background:var(--il-blue-50)}
.ilp-dg__row--click{cursor:pointer}
.ilp-dg__cell{display:flex;align-items:center;gap:6px;padding:0 10px;font-size:var(--fs-sm);line-height:1.3;color:var(--text-primary);background:var(--surface-card);overflow:hidden;white-space:nowrap;text-overflow:ellipsis;transition:background var(--dur-fast) var(--ease-standard)}
.ilp-dg__cell>span{overflow:hidden;text-overflow:ellipsis}
.ilp-dg__cell--num{justify-content:flex-end;font-variant-numeric:tabular-nums}
.ilp-dg__cell--ctr{justify-content:center}
.ilp-dg__cell--muted{color:var(--text-secondary)}

/* pinned */
.ilp-dg__pin{position:sticky;z-index:2}
.ilp-dg__hc.ilp-dg__pin{z-index:4}
.ilp-dg__pin--last::after{content:"";position:absolute;top:0;right:0;width:1px;height:100%;background:var(--border-default)}

/* selection */
.ilp-dg__sel{display:flex;align-items:center;justify-content:center;padding:0}
.ilp-dg__cb{appearance:none;width:16px;height:16px;margin:0;flex:none;border:1.5px solid var(--border-strong);border-radius:var(--radius-xs);background:var(--surface-card);cursor:pointer;position:relative;transition:background var(--dur-fast) var(--ease-standard),border-color var(--dur-fast) var(--ease-standard)}
.ilp-dg__cb:checked,.ilp-dg__cb:indeterminate{background:var(--brand-primary);border-color:var(--brand-primary)}
.ilp-dg__cb:checked::after{content:"";position:absolute;left:4.5px;top:1px;width:4px;height:8px;border:solid #fff;border-width:0 2px 2px 0;transform:rotate(43deg)}
.ilp-dg__cb:indeterminate::after{content:"";position:absolute;left:3px;top:6.5px;width:8px;height:2px;background:#fff}
.ilp-dg__cb:focus-visible{outline:none;box-shadow:var(--ring)}

/* group rows */
.ilp-dg__grow{display:flex;align-items:center;height:var(--dg-row);background:var(--il-grayblue-50);border-bottom:1px solid var(--border-default);cursor:pointer}
.ilp-dg__grow:hover{background:var(--il-grayblue-100)}
.ilp-dg__ginner{position:sticky;left:0;display:flex;align-items:center;gap:8px;padding:0 12px;max-width:100vw}
.ilp-dg__caret{display:grid;place-items:center;width:18px;height:18px;flex:none;color:var(--text-secondary);transition:transform var(--dur-fast) var(--ease-standard)}
.ilp-dg__caret svg{width:13px;height:13px}
.ilp-dg__caret--open{transform:rotate(90deg)}
.ilp-dg__gkey{font-size:var(--fs-xs);font-weight:var(--weight-bold);letter-spacing:.05em;text-transform:uppercase;color:var(--text-muted)}
.ilp-dg__gval{font-size:var(--fs-sm);font-weight:var(--weight-bold);color:var(--text-primary)}
.ilp-dg__gcount{display:inline-flex;align-items:center;height:19px;padding:0 8px;font-size:var(--fs-xs);font-weight:var(--weight-semibold);color:var(--text-secondary);background:var(--surface-card);border:1px solid var(--border-default);border-radius:var(--radius-pill)}
.ilp-dg__gagg{display:flex;align-items:center;gap:4px;font-size:var(--fs-xs);color:var(--text-secondary);white-space:nowrap}
.ilp-dg__gagg b{font-weight:var(--weight-bold);color:var(--text-primary);font-variant-numeric:tabular-nums}

/* states */
.ilp-dg__empty{display:flex;flex-direction:column;align-items:center;justify-content:center;gap:8px;padding:56px 20px;color:var(--text-muted);text-align:center}
.ilp-dg__empty svg{width:26px;height:26px;color:var(--text-disabled)}
.ilp-dg__empty b{font-size:var(--fs-base);font-weight:var(--weight-bold);color:var(--text-secondary)}
.ilp-dg__empty span{font-size:var(--fs-sm);max-width:34ch}
.ilp-dg__load{position:absolute;left:0;right:0;top:0;height:2px;overflow:hidden;background:var(--il-blue-100);z-index:6}
.ilp-dg__load::after{content:"";position:absolute;inset:0;width:36%;background:var(--brand-primary);animation:ilp-dg-slide 1.05s var(--ease-standard) infinite}
@keyframes ilp-dg-slide{0%{transform:translateX(-100%)}100%{transform:translateX(340%)}}
.ilp-dg__veil{position:absolute;inset:0;background:color-mix(in srgb,var(--surface-card) 55%,transparent);z-index:5;pointer-events:none}

/* footer */
.ilp-dg__foot{display:flex;flex:none;align-items:center;gap:var(--space-4);padding:9px 12px;border-top:1px solid var(--border-default);background:var(--surface-card);font-size:var(--fs-sm);color:var(--text-secondary);flex-wrap:wrap}
.ilp-dg__foot select{height:28px;padding:0 24px 0 8px;font:inherit;font-size:var(--fs-sm);color:var(--text-primary);background:var(--surface-card) url("data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%235a6577' stroke-width='2.4' stroke-linecap='round'><path d='M6 9l6 6 6-6'/></svg>") no-repeat right 6px center/12px;border:1px solid var(--border-default);border-radius:var(--radius-md);appearance:none;cursor:pointer;outline:none}
.ilp-dg__foot select:focus{border-color:var(--border-focus);box-shadow:var(--ring)}
.ilp-dg__range{font-variant-numeric:tabular-nums}
.ilp-dg__range b{color:var(--text-primary);font-weight:var(--weight-bold)}
.ilp-dg__pager{display:flex;align-items:center;gap:4px;margin-left:auto}
.ilp-dg__pg{display:grid;place-items:center;width:30px;height:30px;padding:0;color:var(--text-secondary);background:var(--surface-card);border:1px solid var(--border-default);border-radius:var(--radius-md);cursor:pointer;transition:background var(--dur-fast) var(--ease-standard)}
.ilp-dg__pg:hover:not(:disabled){background:var(--surface-hover);color:var(--text-primary)}
.ilp-dg__pg:disabled{opacity:.4;cursor:not-allowed}
.ilp-dg__pg svg{width:14px;height:14px}
.ilp-dg__pgnum{padding:0 8px;font-variant-numeric:tabular-nums}
.ilp-dg__pgnum b{color:var(--text-primary);font-weight:var(--weight-bold)}
.ilp-dg__selinfo{display:inline-flex;align-items:center;gap:8px;height:26px;padding:0 4px 0 10px;font-size:var(--fs-xs);font-weight:var(--weight-semibold);color:var(--il-blue-800);background:var(--il-blue-100);border-radius:var(--radius-pill)}
.ilp-dg__selinfo button{height:20px;padding:0 8px;font:inherit;font-size:var(--fs-xs);font-weight:var(--weight-semibold);color:var(--il-blue-800);background:transparent;border:0;border-radius:var(--radius-pill);cursor:pointer}
.ilp-dg__selinfo button:hover{background:var(--il-blue-200)}

/* popover */
.ilp-dg-pop{position:fixed;z-index:900;min-width:210px;max-height:min(60vh,420px);overflow:auto;padding:6px;background:var(--surface-card);border:1px solid var(--border-default);border-radius:var(--radius-md);box-shadow:var(--shadow-lg);font-family:var(--font-sans);animation:ilp-dg-pop var(--dur-fast) var(--ease-out)}
@keyframes ilp-dg-pop{from{opacity:0;transform:translateY(-4px)}}
.ilp-dg-pop__back{position:fixed;inset:0;z-index:899}
.ilp-dg-pop__hd{padding:7px 10px 5px;font-size:var(--fs-xs);font-weight:var(--weight-bold);letter-spacing:.06em;text-transform:uppercase;color:var(--text-muted)}
.ilp-dg-pop__it{display:flex;align-items:center;gap:9px;width:100%;padding:7px 10px;font:inherit;font-size:var(--fs-sm);color:var(--text-primary);background:transparent;border:0;border-radius:var(--radius-sm);cursor:pointer;text-align:left}
.ilp-dg-pop__it:hover{background:var(--surface-hover)}
.ilp-dg-pop__it:disabled{opacity:.45;cursor:not-allowed;background:transparent}
.ilp-dg-pop__it svg{width:15px;height:15px;flex:none;color:var(--text-muted)}
.ilp-dg-pop__it--on{color:var(--il-blue-700);font-weight:var(--weight-semibold)}
.ilp-dg-pop__it--on svg{color:var(--il-blue-600)}
.ilp-dg-pop__sep{height:1px;margin:5px 6px;background:var(--border-subtle)}
.ilp-dg-pop__ft{display:flex;gap:6px;padding:6px 4px 2px;border-top:1px solid var(--border-subtle);margin-top:4px}
.ilp-dg-pop__ft button{flex:1;height:28px;font:inherit;font-size:var(--fs-xs);font-weight:var(--weight-semibold);color:var(--text-secondary);background:var(--surface-card);border:1px solid var(--border-default);border-radius:var(--radius-sm);cursor:pointer}
.ilp-dg-pop__ft button:hover{background:var(--surface-hover);color:var(--text-primary)}
`;

function useCSS() {
  React.useEffect(() => {
    if (document.getElementById('ilp-dg-css')) return;
    const s = document.createElement('style');
    s.id = 'ilp-dg-css';
    s.textContent = CSS;
    document.head.appendChild(s);
  }, []);
}

/* ---------------- icons (inline, no dependency) ---------------- */
const I = (d, extra) => (p) => (
  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true" {...p}>
    {d.map((x, i) => <path key={i} d={x} />)}
    {extra}
  </svg>
);
const IcSearch = I(['M11 19a8 8 0 1 0 0-16 8 8 0 0 0 0 16Z', 'm21 21-4.3-4.3']);
const IcFilter = I(['M3 5h18l-7 8v6l-4 2v-8L3 5Z']);
const IcCols = I(['M3 4h18v16H3z', 'M9.5 4v16', 'M15.5 4v16']);
const IcGroup = I(['M3 5h8', 'M3 12h14', 'M3 19h18', 'M17 5h4', 'M19 3v4']);
const IcDensity = I(['M3 5h18', 'M3 10h18', 'M3 15h18', 'M3 20h18']);
const IcDownload = I(['M12 3v12', 'm7 11 5 5 5-5', 'M4 20h16']);
const IcUp = I(['m6 15 6-6 6 6']);
const IcDown = I(['m6 9 6 6 6-6']);
const IcSortAsc = I(['M7 20V6', 'm3 10 4-4 4 4', 'M13 8h8', 'M13 13h6', 'M13 18h4']);
const IcSortDesc = I(['M7 4v14', 'm3 14 4 4 4-4', 'M13 8h8', 'M13 13h6', 'M13 18h4']);
const IcDots = I([], <><circle cx="12" cy="5" r="1.6" fill="currentColor" stroke="none" /><circle cx="12" cy="12" r="1.6" fill="currentColor" stroke="none" /><circle cx="12" cy="19" r="1.6" fill="currentColor" stroke="none" /></>);
const IcX = I(['M6 6l12 12', 'M18 6 6 18']);
const IcEye = I(['M2 12s3.6-7 10-7 10 7 10 7-3.6 7-10 7-10-7-10-7Z'], <circle cx="12" cy="12" r="3" />);
const IcEyeOff = I(['M3 3l18 18', 'M10.6 6.2A9.8 9.8 0 0 1 12 5c6.4 0 10 7 10 7a17 17 0 0 1-3.2 4M6.3 7.4A16.7 16.7 0 0 0 2 12s3.6 7 10 7a9.7 9.7 0 0 0 4-.85', 'M9.9 10a3 3 0 0 0 4.2 4.2']);
const IcPin = I(['M12 17v5', 'M9 3h6l-1 6 3 3v2H7v-2l3-3-1-6Z']);
const IcChevR = I(['m9 5 7 7-7 7']);
const IcFirst = I(['m17 5-7 7 7 7', 'M7 5v14']);
const IcLast = I(['m7 5 7 7-7 7', 'M17 5v14']);
const IcPrev = I(['m15 5-7 7 7 7']);
const IcNext = I(['m9 5 7 7-7 7']);
const IcEmpty = I(['M3 5h18v14H3z', 'M3 10h18', 'm9 14 6 4', 'm15 14-6 4']);
const IcClear = I(['M3 5h18l-7 8v6l-4 2v-8L3 5Z', 'm16 4 6 6', 'm22 4-6 6']);

/* ---------------- pure helpers ---------------- */
const getVal = (row, key) => (key.indexOf('.') < 0 ? row[key] : key.split('.').reduce((o, k) => (o == null ? o : o[k]), row));
const NUM = new Intl.NumberFormat('en-US', { maximumFractionDigits: 2 });
const asText = (v) => (v == null ? '' : v instanceof Date ? v.toISOString().slice(0, 10) : String(v));

function compare(a, b) {
  if (a == null && b == null) return 0;
  if (a == null) return -1;
  if (b == null) return 1;
  if (typeof a === 'number' && typeof b === 'number') return a - b;
  if (a instanceof Date && b instanceof Date) return a - b;
  return String(a).localeCompare(String(b), undefined, { numeric: true, sensitivity: 'base' });
}

/** Number filters accept operators: >100  <=50  10-40  =7 */
function numberMatch(value, q) {
  const s = String(q).trim();
  const n = Number(value);
  const range = s.match(/^(-?[\d.]+)\s*(?:-|\.\.|to)\s*(-?[\d.]+)$/i);
  if (range) return n >= +range[1] && n <= +range[2];
  const op = s.match(/^(>=|<=|>|<|=)?\s*(-?[\d.]+)$/);
  if (!op) return asText(value).toLowerCase().includes(s.toLowerCase());
  const t = +op[2];
  switch (op[1]) {
    case '>': return n > t;
    case '<': return n < t;
    case '>=': return n >= t;
    case '<=': return n <= t;
    default: return n === t;
  }
}

function cellMatches(col, row, q) {
  if (q == null || q === '') return true;
  const raw = getVal(row, col.key);
  const v = col.filterValue ? col.filterValue(raw, row) : raw;
  if (col.filter === 'select' || col.filter === 'boolean') return asText(v) === asText(q);
  if (col.filter === 'number' || col.type === 'number') return numberMatch(v, q);
  return asText(v).toLowerCase().includes(String(q).toLowerCase());
}

function aggregateCol(rows, col) {
  const kind = col.aggregate;
  if (!kind) return null;
  if (typeof kind === 'function') return kind(rows);
  const nums = rows.map((r) => Number(getVal(r, col.key))).filter((n) => Number.isFinite(n));
  switch (kind) {
    case 'sum': return nums.reduce((a, b) => a + b, 0);
    case 'avg': return nums.length ? nums.reduce((a, b) => a + b, 0) / nums.length : 0;
    case 'min': return nums.length ? Math.min(...nums) : 0;
    case 'max': return nums.length ? Math.max(...nums) : 0;
    case 'count': return rows.length;
    default: return null;
  }
}

/** rows -> flat render list of {kind:'group'|'row'} honouring collapsed paths. */
function flatten(rows, groupBy, cols, collapsed, rowKeyOf) {
  if (!groupBy.length) return rows.map((r) => ({ kind: 'row', id: rowKeyOf(r), row: r, depth: 0 }));
  const aggCols = cols.filter((c) => c.aggregate);
  const out = [];
  const walk = (list, level, path) => {
    const key = groupBy[level];
    const col = cols.find((c) => c.key === key) || { key, header: key };
    const buckets = new Map();
    for (const r of list) {
      const v = getVal(r, key);
      const k = asText(col.groupValue ? col.groupValue(v, r) : v) || '—';
      if (!buckets.has(k)) buckets.set(k, []);
      buckets.get(k).push(r);
    }
    for (const [label, bucket] of [...buckets.entries()].sort((a, b) => compare(a[0], b[0]))) {
      const p = path + '\u0000' + label;
      const open = !collapsed.has(p);
      out.push({
        kind: 'group', id: 'g' + p, path: p, depth: level, open, label,
        header: col.header || col.key, count: bucket.length,
        aggs: aggCols.map((c) => ({ header: c.header, value: aggregateCol(bucket, c), fmt: c.format })),
      });
      if (!open) continue;
      if (level + 1 < groupBy.length) walk(bucket, level + 1, p);
      else for (const r of bucket) out.push({ kind: 'row', id: rowKeyOf(r), row: r, depth: level + 1 });
    }
  };
  walk(rows, 0, '');
  return out;
}

/* ---------------- popover ---------------- */
function Popover({ anchor, onClose, align = 'left', width, children }) {
  const [pos, setPos] = React.useState(null);
  const ref = React.useRef(null);
  React.useLayoutEffect(() => {
    if (!anchor) return;
    const a = anchor.getBoundingClientRect();
    const w = width || ref.current?.offsetWidth || 220;
    const h = ref.current?.offsetHeight || 260;
    let left = align === 'right' ? a.right - w : a.left;
    left = Math.max(8, Math.min(left, window.innerWidth - w - 8));
    const below = a.bottom + 6;
    const top = below + h > window.innerHeight - 8 ? Math.max(8, a.top - h - 6) : below;
    setPos({ left, top, width });
  }, [anchor, align, width]);
  React.useEffect(() => {
    const esc = (e) => e.key === 'Escape' && onClose();
    window.addEventListener('keydown', esc);
    return () => window.removeEventListener('keydown', esc);
  }, [onClose]);
  return (
    <>
      <div className="ilp-dg-pop__back" onMouseDown={onClose} />
      <div className="ilp-dg-pop" ref={ref} style={pos ? { left: pos.left, top: pos.top, width: pos.width } : { opacity: 0, left: -9999, top: 0 }} role="menu">
        {children}
      </div>
    </>
  );
}
const PopItem = ({ icon, children, on, ...rest }) => (
  <button type="button" className={'ilp-dg-pop__it' + (on ? ' ilp-dg-pop__it--on' : '')} role="menuitem" {...rest}>{icon}<span>{children}</span></button>
);

/* ---------------- row (memoised) ---------------- */
const GridRow = React.memo(function GridRow({ item, cols, template, pinLeft, selectable, selected, onToggle, onRowClick, top, height }) {
  const row = item.row;
  return (
    <div
      className={'ilp-dg__row' + (selected ? ' ilp-dg__row--sel' : '') + (onRowClick ? ' ilp-dg__row--click' : '')}
      style={{ gridTemplateColumns: template, position: 'absolute', top, left: 0, right: 0, height }}
      role="row"
      onClick={onRowClick ? (e) => onRowClick(row, e) : undefined}
    >
      {selectable && (
        <div className="ilp-dg__cell ilp-dg__sel ilp-dg__pin" style={{ left: 0 }} role="gridcell">
          <input type="checkbox" className="ilp-dg__cb" checked={selected} onClick={(e) => e.stopPropagation()} onChange={() => onToggle(item.id)} aria-label="Select row" />
        </div>
      )}
      {cols.map((c) => {
        const raw = getVal(row, c.key);
        const content = c.render ? c.render(raw, row) : c.format ? c.format(raw, row) : asText(raw);
        const cls = 'ilp-dg__cell'
          + (c.align === 'right' || c.type === 'number' ? ' ilp-dg__cell--num' : c.align === 'center' ? ' ilp-dg__cell--ctr' : '')
          + (c.muted ? ' ilp-dg__cell--muted' : '')
          + (pinLeft.has(c.key) ? ' ilp-dg__pin' : '')
          + (pinLeft.get(c.key)?.last ? ' ilp-dg__pin--last' : '');
        return (
          <div key={c.key} className={cls} style={pinLeft.has(c.key) ? { left: pinLeft.get(c.key).left } : undefined} role="gridcell" title={typeof content === 'string' ? content : undefined}>
            {typeof content === 'string' || typeof content === 'number' ? <span>{content}</span> : content}
          </div>
        );
      })}
      <div className="ilp-dg__cell" />
    </div>
  );
});

/* ---------------- main ---------------- */
/** Enterprise data grid: grouping, per-column filters, column show/hide, resize, pinning, virtualised rows, server-side paging. */
export function DataGrid({
  columns = [],
  rows = [],
  rowKey = 'id',
  mode = 'client',
  totalRows,
  loading = false,
  onRequest,
  onRowClick,
  onSelectionChange,
  title,
  subtitle,
  actions = null,
  selectable = false,
  showToolbar = true,
  showSearch = true,
  showColumnPicker = true,
  showGroupControl = true,
  showDensityToggle = true,
  showExport = false,
  showFooter = true,
  showFilterRow = false,
  defaultGroupBy = [],
  defaultSort = null,
  density: densityProp = 'comfortable',
  height = 520,
  pageSize: pageSizeProp = 25,
  pageSizeOptions = [10, 25, 50, 100],
  virtualize = true,
  virtualizeThreshold = 60,
  emptyTitle = 'No rows to show',
  emptyMessage = 'Try clearing a filter or widening your search.',
  className = '',
  ...rest
}) {
  useCSS();
  const server = mode === 'server';
  const rowKeyOf = React.useCallback((r) => (typeof rowKey === 'function' ? rowKey(r) : asText(getVal(r, rowKey))), [rowKey]);

  const [sort, setSort] = React.useState(defaultSort);
  const [filters, setFilters] = React.useState({});
  const [search, setSearch] = React.useState('');
  const [groupBy, setGroupBy] = React.useState(defaultGroupBy);
  const [hidden, setHidden] = React.useState(() => new Set(columns.filter((c) => c.hidden).map((c) => c.key)));
  const [pinned, setPinned] = React.useState(() => new Set(columns.filter((c) => c.pinned === 'left').map((c) => c.key)));
  const [widths, setWidths] = React.useState({});
  const [collapsed, setCollapsed] = React.useState(() => new Set());
  const [selected, setSelected] = React.useState(() => new Set());
  const [page, setPage] = React.useState(1);
  const [pageSize, setPageSize] = React.useState(pageSizeProp);
  const [density, setDensity] = React.useState(densityProp);
  const [filterRow, setFilterRow] = React.useState(showFilterRow);
  const [pop, setPop] = React.useState(null); // {type, anchor, col}
  const [scrollTop, setScrollTop] = React.useState(0);
  const [vpH, setVpH] = React.useState(360);
  const [resizing, setResizing] = React.useState(null);

  const vpRef = React.useRef(null);
  const rowH = density === 'compact' ? 34 : 44;
  const headH = (density === 'compact' ? 38 : 44) + (filterRow ? 38 : 0);

  /* ---- server request signal ---- */
  const reqRef = React.useRef(onRequest);
  reqRef.current = onRequest;
  const debounced = React.useMemo(() => JSON.stringify({ filters, search }), [filters, search]);
  const [debouncedQ, setDebouncedQ] = React.useState(debounced);
  React.useEffect(() => {
    const t = setTimeout(() => setDebouncedQ(debounced), 280);
    return () => clearTimeout(t);
  }, [debounced]);
  React.useEffect(() => {
    if (!server || !reqRef.current) return;
    const { filters: f, search: s } = JSON.parse(debouncedQ);
    reqRef.current({ page, pageSize, sort, filters: f, search: s, groupBy });
  }, [server, page, pageSize, sort, groupBy, debouncedQ]);

  /* ---- reset to page 1 when the query changes ---- */
  React.useEffect(() => { setPage(1); }, [debouncedQ, pageSize]);

  /* ---- column model ---- */
  const allCols = React.useMemo(
    () => columns.map((c) => ({ ...c, width: widths[c.key] ?? c.width ?? 160 })),
    [columns, widths]
  );
  const visible = React.useMemo(() => {
    const v = allCols.filter((c) => !hidden.has(c.key));
    return [...v.filter((c) => pinned.has(c.key)), ...v.filter((c) => !pinned.has(c.key))];
  }, [allCols, hidden, pinned]);

  const pinMap = React.useMemo(() => {
    const m = new Map();
    let left = selectable ? 44 : 0;
    const pins = visible.filter((c) => pinned.has(c.key));
    pins.forEach((c, i) => { m.set(c.key, { left, last: i === pins.length - 1 }); left += c.width; });
    return m;
  }, [visible, pinned, selectable]);

  const template = React.useMemo(
    () => (selectable ? '44px ' : '') + visible.map((c) => c.width + 'px').join(' ') + ' minmax(24px,1fr)',
    [visible, selectable]
  );
  const minW = React.useMemo(() => (selectable ? 44 : 0) + visible.reduce((s, c) => s + c.width, 0) + 24, [visible, selectable]);

  /* ---- data pipeline (client mode) ---- */
  const filtered = React.useMemo(() => {
    if (server) return rows;
    const active = Object.entries(filters).filter(([, v]) => v !== '' && v != null);
    const q = search.trim().toLowerCase();
    if (!active.length && !q) return rows;
    const searchCols = allCols.filter((c) => c.searchable !== false);
    return rows.filter((r) => {
      for (const [k, v] of active) {
        const col = allCols.find((c) => c.key === k);
        if (col && !cellMatches(col, r, v)) return false;
      }
      if (!q) return true;
      return searchCols.some((c) => asText(getVal(r, c.key)).toLowerCase().includes(q));
    });
  }, [server, rows, filters, search, allCols]);

  const sorted = React.useMemo(() => {
    if (server || !sort) return filtered;
    const col = allCols.find((c) => c.key === sort.key);
    const dir = sort.dir === 'desc' ? -1 : 1;
    const acc = col?.sortValue ? (r) => col.sortValue(getVal(r, sort.key), r) : (r) => getVal(r, sort.key);
    return [...filtered].sort((a, b) => dir * compare(acc(a), acc(b)));
  }, [server, filtered, sort, allCols]);

  const total = server ? (totalRows ?? rows.length) : sorted.length;
  const pageCount = Math.max(1, Math.ceil(total / pageSize));
  const pageRows = React.useMemo(
    () => (server ? rows : sorted.slice((page - 1) * pageSize, page * pageSize)),
    [server, rows, sorted, page, pageSize]
  );

  const items = React.useMemo(
    () => flatten(pageRows, groupBy, allCols, collapsed, rowKeyOf),
    [pageRows, groupBy, allCols, collapsed, rowKeyOf]
  );

  /* ---- virtualisation ---- */
  React.useEffect(() => {
    const el = vpRef.current;
    if (!el || typeof ResizeObserver === 'undefined') return;
    const ro = new ResizeObserver(() => setVpH(el.clientHeight));
    ro.observe(el);
    setVpH(el.clientHeight);
    return () => ro.disconnect();
  }, []);
  React.useEffect(() => { if (vpRef.current) vpRef.current.scrollTop = 0; setScrollTop(0); }, [page, pageSize, sort, debouncedQ]);

  const virtual = virtualize && items.length > virtualizeThreshold;
  const offset = Math.max(0, scrollTop - headH);
  const first = virtual ? Math.max(0, Math.floor(offset / rowH) - 8) : 0;
  const last = virtual ? Math.min(items.length, Math.ceil((offset + vpH) / rowH) + 8) : items.length;
  const slice = items.slice(first, last);

  /* ---- interactions ---- */
  const toggleSort = (col, dir) => {
    if (col.sortable === false) return;
    setSort((s) => {
      const next = dir || (s?.key !== col.key ? 'asc' : s.dir === 'asc' ? 'desc' : null);
      return next ? { key: col.key, dir: next } : null;
    });
  };
  const setFilter = (key, value) => setFilters((f) => ({ ...f, [key]: value }));
  const clearFilters = () => { setFilters({}); setSearch(''); };
  const activeFilters = Object.values(filters).filter((v) => v !== '' && v != null).length + (search ? 1 : 0);
  const toggleGroup = (key) => setGroupBy((g) => (g.includes(key) ? g.filter((k) => k !== key) : [...g, key]));
  const toggleCollapse = (path) => setCollapsed((c) => { const n = new Set(c); n.has(path) ? n.delete(path) : n.add(path); return n; });
  const toggleHidden = (key) => setHidden((h) => { const n = new Set(h); n.has(key) ? n.delete(key) : n.add(key); return n; });
  const togglePin = (key) => setPinned((p) => { const n = new Set(p); n.has(key) ? n.delete(key) : n.add(key); return n; });

  const emit = (next) => { setSelected(next); onSelectionChange && onSelectionChange([...next]); };
  const toggleRow = React.useCallback((id) => {
    setSelected((s) => {
      const n = new Set(s); n.has(id) ? n.delete(id) : n.add(id);
      onSelectionChange && onSelectionChange([...n]);
      return n;
    });
  }, [onSelectionChange]);
  const pageIds = React.useMemo(() => pageRows.map(rowKeyOf), [pageRows, rowKeyOf]);
  const allOnPage = pageIds.length > 0 && pageIds.every((id) => selected.has(id));
  const someOnPage = !allOnPage && pageIds.some((id) => selected.has(id));
  const toggleAll = () => {
    const n = new Set(selected);
    allOnPage ? pageIds.forEach((id) => n.delete(id)) : pageIds.forEach((id) => n.add(id));
    emit(n);
  };

  /* ---- column resize ---- */
  React.useEffect(() => {
    if (!resizing) return;
    const move = (e) => {
      const w = Math.max(resizing.min, resizing.start + (e.clientX - resizing.x));
      setWidths((s) => ({ ...s, [resizing.key]: Math.round(w) }));
    };
    const up = () => setResizing(null);
    window.addEventListener('mousemove', move);
    window.addEventListener('mouseup', up);
    document.body.style.cursor = 'col-resize';
    return () => { window.removeEventListener('mousemove', move); window.removeEventListener('mouseup', up); document.body.style.cursor = ''; };
  }, [resizing]);

  const exportCSV = () => {
    const head = visible.map((c) => `"${(c.header || c.key).replace(/"/g, '""')}"`).join(',');
    const body = pageRows.map((r) => visible.map((c) => {
      const v = c.format ? c.format(getVal(r, c.key), r) : getVal(r, c.key);
      return `"${asText(v).replace(/"/g, '""')}"`;
    }).join(',')).join('\n');
    const url = URL.createObjectURL(new Blob([head + '\n' + body], { type: 'text/csv' }));
    const a = document.createElement('a');
    a.href = url; a.download = (title || 'data-grid').toLowerCase().replace(/\s+/g, '-') + '.csv';
    a.click(); URL.revokeObjectURL(url);
  };

  const from = total === 0 ? 0 : (page - 1) * pageSize + 1;
  const to = Math.min(page * pageSize, total);
  const groupableCols = allCols.filter((c) => c.groupable);

  return (
    <div className={'ilp-dg' + (density === 'compact' ? ' ilp-dg--compact' : '') + (className ? ' ' + className : '')} role="grid" aria-rowcount={total} {...rest} style={{ height, ...(rest.style || {}) }}>
      {loading && <div className="ilp-dg__load" />}

      {showToolbar && (
        <div className="ilp-dg__bar">
          {(title || subtitle) && (
            <div className="ilp-dg__titles">
              {title && <div className="ilp-dg__title">{title}</div>}
              {subtitle && <div className="ilp-dg__sub">{subtitle}</div>}
            </div>
          )}
          {!title && !subtitle && <div className="ilp-dg__spacer" />}

          {groupBy.length > 0 && (
            <div className="ilp-dg__chips">
              <span className="ilp-dg__chipslabel">Grouped by</span>
              {groupBy.map((k) => (
                <span key={k} className="ilp-dg__chip">
                  {allCols.find((c) => c.key === k)?.header || k}
                  <button type="button" onClick={() => toggleGroup(k)} aria-label={'Remove grouping ' + k}><IcX /></button>
                </span>
              ))}
            </div>
          )}
          {selected.size > 0 && (
            <span className="ilp-dg__selinfo">{selected.size} selected<button type="button" onClick={() => emit(new Set())}>Clear</button></span>
          )}

          {showSearch && (
            <div className="ilp-dg__search">
              <IcSearch />
              <input value={search} onChange={(e) => setSearch(e.target.value)} placeholder="Search…" aria-label="Search rows" />
            </div>
          )}
          <button type="button" className="ilp-dg__tool" aria-pressed={filterRow} onClick={() => setFilterRow((v) => !v)}>
            <IcFilter />Filters{activeFilters > 0 && <span className="ilp-dg__count">{activeFilters}</span>}
          </button>
          {activeFilters > 0 && (
            <button type="button" className="ilp-dg__tool" onClick={clearFilters} title="Clear all filters"><IcClear /></button>
          )}
          {showGroupControl && groupableCols.length > 0 && (
            <button type="button" className="ilp-dg__tool" aria-expanded={pop?.type === 'group'} onClick={(e) => setPop(pop?.type === 'group' ? null : { type: 'group', anchor: e.currentTarget })}>
              <IcGroup />Group
            </button>
          )}
          {showColumnPicker && (
            <button type="button" className="ilp-dg__tool" aria-expanded={pop?.type === 'cols'} onClick={(e) => setPop(pop?.type === 'cols' ? null : { type: 'cols', anchor: e.currentTarget })}>
              <IcCols />Columns{hidden.size > 0 && <span className="ilp-dg__count">{visible.length}</span>}
            </button>
          )}
          {showDensityToggle && (
            <button type="button" className="ilp-dg__tool" onClick={() => setDensity((d) => (d === 'compact' ? 'comfortable' : 'compact'))} title="Toggle row density"><IcDensity /></button>
          )}
          {showExport && <button type="button" className="ilp-dg__tool" onClick={exportCSV} title="Export page as CSV"><IcDownload /></button>}
          {actions}
        </div>
      )}

      <div className="ilp-dg__vp" ref={vpRef} onScroll={(e) => virtual && setScrollTop(e.currentTarget.scrollTop)}>
        <div className="ilp-dg__grid" style={{ minWidth: minW }}>
          <div className="ilp-dg__head">
            <div className="ilp-dg__hrow" style={{ gridTemplateColumns: template }} role="row">
              {selectable && (
                <div className="ilp-dg__hc ilp-dg__sel ilp-dg__pin" style={{ left: 0 }}>
                  <input type="checkbox" className="ilp-dg__cb" checked={allOnPage} ref={(el) => el && (el.indeterminate = someOnPage)} onChange={toggleAll} aria-label="Select all rows on page" />
                </div>
              )}
              {visible.map((c) => {
                const isSorted = sort?.key === c.key;
                const pin = pinMap.get(c.key);
                return (
                  <div
                    key={c.key}
                    className={'ilp-dg__hc'
                      + (c.align === 'right' || c.type === 'number' ? ' ilp-dg__hc--num' : c.align === 'center' ? ' ilp-dg__hc--ctr' : '')
                      + (c.sortable === false ? '' : ' ilp-dg__hc--sortable')
                      + (isSorted ? ' ilp-dg__hc--sorted' : '')
                      + (pin ? ' ilp-dg__pin' : '') + (pin?.last ? ' ilp-dg__pin--last' : '')}
                    style={pin ? { left: pin.left } : undefined}
                    role="columnheader"
                    aria-sort={isSorted ? (sort.dir === 'asc' ? 'ascending' : 'descending') : 'none'}
                    onClick={() => toggleSort(c)}
                  >
                    <span className="ilp-dg__hlabel" title={c.header || c.key}>{c.header || c.key}</span>
                    {c.sortable !== false && (
                      <span className={'ilp-dg__sort' + (isSorted ? ' ilp-dg__sort--on' : '')}>
                        {isSorted && sort.dir === 'desc' ? <IcDown /> : <IcUp />}
                      </span>
                    )}
                    <button
                      type="button" className="ilp-dg__menu" aria-label={'Column options for ' + (c.header || c.key)}
                      aria-expanded={pop?.type === 'col' && pop.col === c.key}
                      onClick={(e) => { e.stopPropagation(); setPop(pop?.col === c.key ? null : { type: 'col', anchor: e.currentTarget, col: c.key, align: 'right' }); }}
                    ><IcDots /></button>
                    {c.resizable !== false && (
                      <span
                        className={'ilp-dg__grip' + (resizing?.key === c.key ? ' ilp-dg__grip--on' : '')}
                        onMouseDown={(e) => { e.preventDefault(); e.stopPropagation(); setResizing({ key: c.key, x: e.clientX, start: c.width, min: c.minWidth || 72 }); }}
                        onClick={(e) => e.stopPropagation()}
                      />
                    )}
                  </div>
                );
              })}
              <div className="ilp-dg__hc" />
            </div>

            {filterRow && (
              <div className="ilp-dg__frow" style={{ gridTemplateColumns: template }} role="row">
                {selectable && <div className="ilp-dg__fc ilp-dg__pin" style={{ left: 0 }} />}
                {visible.map((c) => {
                  const pin = pinMap.get(c.key);
                  const val = filters[c.key] ?? '';
                  const cls = 'ilp-dg__fc' + (val !== '' ? ' ilp-dg__fc--on' : '') + (pin ? ' ilp-dg__pin' : '') + (pin?.last ? ' ilp-dg__pin--last' : '');
                  const style = pin ? { left: pin.left } : undefined;
                  if (c.filter === false) return <div key={c.key} className={cls} style={style} />;
                  const opts = c.filterOptions || (c.filter === 'select' ? [...new Set(rows.map((r) => asText(getVal(r, c.key))))].sort() : null);
                  return (
                    <div key={c.key} className={cls} style={style}>
                      {c.filter === 'select' || c.filter === 'boolean' ? (
                        <select value={val} onChange={(e) => setFilter(c.key, e.target.value)} aria-label={'Filter ' + (c.header || c.key)}>
                          <option value="">All</option>
                          {(c.filter === 'boolean' ? ['true', 'false'] : opts || []).map((o) => (
                            <option key={typeof o === 'object' ? o.value : o} value={typeof o === 'object' ? o.value : o}>{typeof o === 'object' ? o.label : o}</option>
                          ))}
                        </select>
                      ) : (
                        <input
                          value={val} onChange={(e) => setFilter(c.key, e.target.value)}
                          placeholder={c.filter === 'number' || c.type === 'number' ? '> 100' : 'Filter…'}
                          aria-label={'Filter ' + (c.header || c.key)}
                        />
                      )}
                    </div>
                  );
                })}
                <div className="ilp-dg__fc" />
              </div>
            )}
          </div>

          {items.length === 0 ? (
            <div className="ilp-dg__empty" style={{ position: 'sticky', left: 0 }}>
              <IcEmpty /><b>{emptyTitle}</b><span>{emptyMessage}</span>
            </div>
          ) : (
            <div className="ilp-dg__rows" style={{ height: items.length * rowH }}>
              {slice.map((it, i) => {
                const top = (first + i) * rowH;
                if (it.kind === 'group') {
                  return (
                    <div key={it.id} className="ilp-dg__grow" style={{ position: 'absolute', top, left: 0, right: 0, height: rowH, minWidth: minW }} onClick={() => toggleCollapse(it.path)} role="row">
                      <div className="ilp-dg__ginner" style={{ paddingLeft: 12 + it.depth * 20 }}>
                        <span className={'ilp-dg__caret' + (it.open ? ' ilp-dg__caret--open' : '')}><IcChevR /></span>
                        <span className="ilp-dg__gkey">{it.header}</span>
                        <span className="ilp-dg__gval">{it.label}</span>
                        <span className="ilp-dg__gcount">{it.count}</span>
                        {it.aggs.map((a) => (
                          <span key={a.header} className="ilp-dg__gagg">{a.header}<b>{a.fmt ? a.fmt(a.value) : NUM.format(a.value)}</b></span>
                        ))}
                      </div>
                    </div>
                  );
                }
                return (
                  <GridRow
                    key={it.id} item={it} cols={visible} template={template} pinLeft={pinMap}
                    selectable={selectable} selected={selected.has(it.id)} onToggle={toggleRow}
                    onRowClick={onRowClick} top={top} height={rowH}
                  />
                );
              })}
            </div>
          )}
        </div>
        {loading && items.length > 0 && <div className="ilp-dg__veil" />}
      </div>

      {showFooter && (
        <div className="ilp-dg__foot">
          <label style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
            Rows
            <select value={pageSize} onChange={(e) => setPageSize(+e.target.value)} aria-label="Rows per page">
              {pageSizeOptions.map((n) => <option key={n} value={n}>{n}</option>)}
            </select>
          </label>
          <span className="ilp-dg__range"><b>{from.toLocaleString()}–{to.toLocaleString()}</b> of <b>{total.toLocaleString()}</b>{server ? ' · server-side' : ''}</span>
          <div className="ilp-dg__pager">
            <button type="button" className="ilp-dg__pg" disabled={page <= 1} onClick={() => setPage(1)} aria-label="First page"><IcFirst /></button>
            <button type="button" className="ilp-dg__pg" disabled={page <= 1} onClick={() => setPage((p) => p - 1)} aria-label="Previous page"><IcPrev /></button>
            <span className="ilp-dg__pgnum">Page <b>{page}</b> of <b>{pageCount}</b></span>
            <button type="button" className="ilp-dg__pg" disabled={page >= pageCount} onClick={() => setPage((p) => p + 1)} aria-label="Next page"><IcNext /></button>
            <button type="button" className="ilp-dg__pg" disabled={page >= pageCount} onClick={() => setPage(pageCount)} aria-label="Last page"><IcLast /></button>
          </div>
        </div>
      )}

      {pop?.type === 'cols' && (
        <Popover anchor={pop.anchor} align="right" width={230} onClose={() => setPop(null)}>
          <div className="ilp-dg-pop__hd">Columns</div>
          {allCols.map((c) => (
            <PopItem key={c.key} icon={hidden.has(c.key) ? <IcEyeOff /> : <IcEye />} on={!hidden.has(c.key)} onClick={() => toggleHidden(c.key)}>
              {c.header || c.key}
            </PopItem>
          ))}
          <div className="ilp-dg-pop__ft">
            <button type="button" onClick={() => setHidden(new Set())}>Show all</button>
            <button type="button" onClick={() => setHidden(new Set(allCols.slice(1).map((c) => c.key)))}>Hide all</button>
          </div>
        </Popover>
      )}

      {pop?.type === 'group' && (
        <Popover anchor={pop.anchor} align="right" width={230} onClose={() => setPop(null)}>
          <div className="ilp-dg-pop__hd">Group rows by</div>
          {groupableCols.map((c) => (
            <PopItem key={c.key} icon={<IcGroup />} on={groupBy.includes(c.key)} onClick={() => toggleGroup(c.key)}>{c.header || c.key}</PopItem>
          ))}
          {groupBy.length > 0 && (
            <>
              <div className="ilp-dg-pop__sep" />
              <PopItem icon={<IcX />} onClick={() => { setGroupBy([]); setPop(null); }}>Clear grouping</PopItem>
            </>
          )}
        </Popover>
      )}

      {pop?.type === 'col' && (() => {
        const c = allCols.find((x) => x.key === pop.col);
        if (!c) return null;
        return (
          <Popover anchor={pop.anchor} align="right" width={220} onClose={() => setPop(null)}>
            <PopItem icon={<IcSortAsc />} disabled={c.sortable === false} on={sort?.key === c.key && sort.dir === 'asc'} onClick={() => { toggleSort(c, 'asc'); setPop(null); }}>Sort ascending</PopItem>
            <PopItem icon={<IcSortDesc />} disabled={c.sortable === false} on={sort?.key === c.key && sort.dir === 'desc'} onClick={() => { toggleSort(c, 'desc'); setPop(null); }}>Sort descending</PopItem>
            <div className="ilp-dg-pop__sep" />
            <PopItem icon={<IcFilter />} on={filterRow} onClick={() => { setFilterRow(true); setPop(null); }}>Show filter row</PopItem>
            {c.groupable && <PopItem icon={<IcGroup />} on={groupBy.includes(c.key)} onClick={() => { toggleGroup(c.key); setPop(null); }}>{groupBy.includes(c.key) ? 'Remove grouping' : 'Group by this column'}</PopItem>}
            <PopItem icon={<IcPin />} on={pinned.has(c.key)} onClick={() => { togglePin(c.key); setPop(null); }}>{pinned.has(c.key) ? 'Unpin column' : 'Pin left'}</PopItem>
            <div className="ilp-dg-pop__sep" />
            <PopItem icon={<IcEyeOff />} onClick={() => { toggleHidden(c.key); setPop(null); }}>Hide column</PopItem>
          </Popover>
        );
      })()}
    </div>
  );
}
