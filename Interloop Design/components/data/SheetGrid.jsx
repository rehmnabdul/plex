import React from 'react';

const CSS = `
.ilp-xl{display:flex;flex-direction:column;min-height:0;background:var(--surface-card);border:1px solid var(--border-default);border-radius:var(--radius-lg);box-shadow:var(--shadow-sm);font-family:var(--font-sans);color:var(--text-primary);overflow:hidden;position:relative}
.ilp-xl *{box-sizing:border-box}
.ilp-xl__vp{position:relative;flex:1 1 auto;min-height:0;overflow:auto;overscroll-behavior:contain;outline:none}
.ilp-xl__in{position:relative;min-width:max-content}

/* toolbar */
.ilp-xl__bar{display:flex;flex:none;align-items:center;gap:8px;flex-wrap:wrap;padding:9px 12px;border-bottom:1px solid var(--border-default);min-height:52px}
.ilp-xl__ttl{font-size:var(--fs-base);font-weight:var(--weight-bold);letter-spacing:-0.01em;margin-right:auto}
.ilp-xl__ref{display:inline-flex;align-items:center;height:28px;min-width:74px;padding:0 10px;font-size:var(--fs-xs);font-weight:var(--weight-bold);font-variant-numeric:tabular-nums;color:var(--text-secondary);background:var(--il-grayblue-50);border:1px solid var(--border-default);border-radius:var(--radius-sm)}
.ilp-xl__tool{display:inline-flex;align-items:center;gap:6px;height:28px;padding:0 10px;font:inherit;font-size:var(--fs-sm);font-weight:var(--weight-semibold);color:var(--text-secondary);background:var(--surface-card);border:1px solid var(--border-default);border-radius:var(--radius-md);cursor:pointer;white-space:nowrap;transition:background var(--dur-fast) var(--ease-standard)}
.ilp-xl__tool:hover:not([disabled]){background:var(--surface-hover);color:var(--text-primary);border-color:var(--border-strong)}
.ilp-xl__tool[disabled]{opacity:.45;cursor:not-allowed}
.ilp-xl__tool[aria-pressed="true"]{background:var(--il-blue-100);border-color:var(--il-blue-300);color:var(--il-blue-800)}
.ilp-xl__tool:focus-visible{outline:none;box-shadow:var(--ring)}
.ilp-xl__tool svg{width:15px;height:15px}

/* rows */
.ilp-xl__hrow,.ilp-xl__row,.ilp-xl__trow{display:grid;align-items:stretch}
.ilp-xl__head{position:sticky;top:0;z-index:30;background:var(--surface-card)}
.ilp-xl__hrow{background:var(--il-grayblue-50);border-bottom:1px solid var(--border-strong)}
.ilp-xl__hc{position:relative;display:flex;align-items:center;gap:5px;padding:0 9px;font-size:var(--fs-xs);font-weight:var(--weight-bold);letter-spacing:.04em;color:var(--text-secondary);background:var(--il-grayblue-50);border-right:1px solid var(--border-default);user-select:none;overflow:hidden;white-space:nowrap}
.ilp-xl__hc--num{justify-content:flex-end}
.ilp-xl__hc--ctr{justify-content:center}
.ilp-xl__hc--active{background:var(--il-blue-100);color:var(--il-blue-800)}
.ilp-xl__hc em{font-style:normal;font-size:9px;font-weight:var(--weight-semibold);color:var(--text-disabled);text-transform:uppercase;letter-spacing:.06em}
.ilp-xl__req{color:var(--status-danger)}
.ilp-xl__grip{position:absolute;top:0;right:-3px;width:7px;height:100%;cursor:col-resize;z-index:2}
.ilp-xl__grip:hover::after{content:"";position:absolute;top:0;left:3px;width:2px;height:100%;background:var(--brand-primary)}

.ilp-xl__rh{display:flex;align-items:center;justify-content:center;font-size:var(--fs-xs);font-weight:var(--weight-semibold);font-variant-numeric:tabular-nums;color:var(--text-muted);background:var(--il-grayblue-50);border-right:1px solid var(--border-default);user-select:none}
.ilp-xl__rh--active{background:var(--il-blue-100);color:var(--il-blue-800);font-weight:var(--weight-bold)}
.ilp-xl__rh--corner{border-bottom:0}

.ilp-xl__row{border-bottom:1px solid var(--border-subtle)}
.ilp-xl__cell{position:relative;display:flex;align-items:center;padding:0 9px;font-size:var(--fs-sm);line-height:1.3;background:var(--surface-card);border-right:1px solid var(--border-subtle);overflow:hidden;white-space:nowrap;text-overflow:ellipsis;cursor:cell}
.ilp-xl__cell--num{justify-content:flex-end;font-variant-numeric:tabular-nums}
.ilp-xl__cell--ctr{justify-content:center}
.ilp-xl__cell--ro{background:var(--il-grayblue-50);color:var(--text-secondary);cursor:default}
.ilp-xl__cell--in{background:var(--il-blue-50)}
.ilp-xl__cell--bad{box-shadow:inset 0 -2px 0 var(--status-danger)}
.ilp-xl__cell--bad::after{content:"";position:absolute;top:2px;right:2px;border:4px solid transparent;border-top-color:var(--status-danger);border-right-color:var(--status-danger)}
.ilp-xl__cell>span{overflow:hidden;text-overflow:ellipsis}
.ilp-xl__muted{color:var(--text-disabled)}

/* active cell ring drawn as an overlay so it never clips */
.ilp-xl__ring{position:absolute;z-index:20;pointer-events:none;border:2px solid var(--brand-primary);border-radius:2px;box-shadow:0 0 0 1px color-mix(in srgb,var(--il-blue-500) 25%,transparent)}
.ilp-xl__ring--fill{border-style:dashed;background:color-mix(in srgb,var(--il-blue-500) 8%,transparent)}
.ilp-xl__fill{position:absolute;z-index:21;width:8px;height:8px;background:var(--brand-primary);border:1px solid #fff;border-radius:1px;cursor:crosshair;pointer-events:auto}

/* editors */
.ilp-xl__ed{position:absolute;z-index:40;display:flex;align-items:center;padding:0 7px;background:var(--surface-card);border:2px solid var(--brand-primary);border-radius:2px;box-shadow:var(--shadow-md)}
.ilp-xl__ed input,.ilp-xl__ed select{width:100%;height:100%;padding:0;font:inherit;font-size:var(--fs-sm);color:var(--text-primary);background:transparent;border:0;outline:none}
.ilp-xl__ed--num input{text-align:right;font-variant-numeric:tabular-nums}
.ilp-xl__cb{width:15px;height:15px;margin:0;accent-color:var(--brand-primary);cursor:pointer}
.ilp-xl__caret{margin-left:auto;padding-left:6px;color:var(--text-disabled);font-size:9px}
.ilp-xl__pill{display:inline-flex;align-items:center;height:20px;padding:0 9px;font-size:var(--fs-xs);font-weight:var(--weight-semibold);border-radius:var(--radius-pill);background:var(--il-grayblue-100);color:var(--text-secondary)}
.ilp-xl__pill--info{background:var(--il-blue-100);color:var(--il-blue-800)}
.ilp-xl__pill--success{background:var(--il-earth-soft);color:var(--il-earth-ink)}
.ilp-xl__pill--warning{background:var(--il-sun-soft);color:var(--il-sun-ink)}
.ilp-xl__pill--danger{background:var(--il-red-soft);color:var(--il-red-ink)}

/* totals + status */
.ilp-xl__trow{position:sticky;bottom:0;z-index:25;background:var(--il-grayblue-50);border-top:1px solid var(--border-strong)}
.ilp-xl__tc{display:flex;align-items:center;padding:0 9px;font-size:var(--fs-sm);font-weight:var(--weight-bold);font-variant-numeric:tabular-nums;background:var(--il-grayblue-50);border-right:1px solid var(--border-default);white-space:nowrap}
.ilp-xl__tc--num{justify-content:flex-end}
.ilp-xl__status{display:flex;flex:none;align-items:center;gap:18px;padding:8px 12px;border-top:1px solid var(--border-default);background:var(--surface-card);font-size:var(--fs-xs);color:var(--text-muted)}
.ilp-xl__status b{font-weight:var(--weight-bold);color:var(--text-primary);font-variant-numeric:tabular-nums}
.ilp-xl__status .err{color:var(--il-red-ink);font-weight:var(--weight-semibold)}
.ilp-xl__hint{margin-left:auto;color:var(--text-disabled)}
.ilp-xl__pin{position:sticky;z-index:10}
.ilp-xl__hc.ilp-xl__pin,.ilp-xl__rh.ilp-xl__pin{z-index:35}
.ilp-xl__tc.ilp-xl__pin{z-index:26}
.ilp-xl__pin--edge{border-right:2px solid var(--border-strong)}
`;

function useCSS() {
  React.useEffect(() => {
    if (document.getElementById('ilp-xl-css')) return;
    const s = document.createElement('style');
    s.id = 'ilp-xl-css';
    s.textContent = CSS;
    document.head.appendChild(s);
  }, []);
}

const I = (d) => (p) => (
  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true" {...p}>
    {d.map((x, i) => <path key={i} d={x} />)}
  </svg>
);
const IcUndo = I(['M4 9h11a5 5 0 0 1 0 10H9', 'm8 5-4 4 4 4']);
const IcRedo = I(['M20 9H9a5 5 0 0 0 0 10h6', 'm16 5 4 4-4 4']);
const IcPlus = I(['M12 5v14', 'M5 12h14']);
const IcTrash = I(['M4 7h16', 'M9 7V4h6v3', 'M6 7l1 13h10l1-13']);
const IcFreeze = I(['M12 3v18', 'M4 8l8 4 8-4', 'M4 16l8-4 8 4']);
const IcDownload = I(['M12 3v12', 'm7 11 5 5 5-5', 'M4 20h16']);

/* ---------------- value helpers ---------------- */
const COL_LETTER = (i) => {
  let s = '';
  let n = i;
  do { s = String.fromCharCode(65 + (n % 26)) + s; n = Math.floor(n / 26) - 1; } while (n >= 0);
  return s;
};
const NUM = new Intl.NumberFormat('en-US');
const MONEY = new Intl.NumberFormat('en-US', { style: 'currency', currency: 'USD' });
const isNumeric = (t) => t === 'number' || t === 'currency' || t === 'percent';

function parseCell(raw, col) {
  const t = col.type || 'text';
  if (t === 'checkbox') return raw === true || raw === 'true' || raw === 1 || raw === '1';
  if (isNumeric(t)) {
    if (raw === '' || raw == null) return null;
    const n = Number(String(raw).replace(/[$,%\s,]/g, ''));
    return Number.isFinite(n) ? n : null;
  }
  return raw == null ? '' : String(raw);
}

function displayCell(v, col) {
  const t = col.type || 'text';
  if (v == null || v === '') return '';
  if (col.format) return col.format(v);
  if (t === 'currency') return MONEY.format(v);
  if (t === 'percent') return `${NUM.format(v)}%`;
  if (t === 'number') return NUM.format(v);
  if (t === 'date') return new Date(v).toLocaleDateString('en-GB', { day: '2-digit', month: 'short', year: 'numeric' });
  if (t === 'datetime') return new Date(v).toLocaleString('en-GB', { day: '2-digit', month: 'short', year: 'numeric', hour: '2-digit', minute: '2-digit' });
  if (t === 'time') return v;
  return String(v);
}

const optionOf = (col, v) => (col.options || []).find((o) => (typeof o === 'object' ? o.value : o) === v);
const optionLabel = (col, v) => {
  const o = optionOf(col, v);
  return o ? (typeof o === 'object' ? o.label : o) : v;
};

function cellError(v, col, row) {
  if (col.required && (v == null || v === '')) return 'Required';
  if (isNumeric(col.type) && v != null && v !== '') {
    if (col.min != null && v < col.min) return `Minimum ${col.min}`;
    if (col.max != null && v > col.max) return `Maximum ${col.max}`;
  }
  if (col.type === 'select' && v && col.options && !optionOf(col, v)) return 'Not an allowed value';
  if (col.validate) {
    const res = col.validate(v, row);
    if (res && res !== true) return typeof res === 'string' ? res : 'Invalid';
  }
  return null;
}

/**
 * Spreadsheet-style editable grid: typed cell editors, keyboard navigation,
 * range selection, copy / paste, fill-down, undo/redo and frozen columns.
 */
export function SheetGrid({
  columns = [],
  rows = [],
  onChange,
  rowKey = 'id',
  freeze = 0,
  height = 520,
  rowHeight = 34,
  title,
  showToolbar = true,
  showRowHeaders = true,
  showColumnLetters = false,
  showStatusBar = true,
  allowAddRows = false,
  allowDeleteRows = false,
  newRow,
  totals = null,
  readOnly = false,
  className = '',
  ...rest
}) {
  useCSS();
  const [data, setData] = React.useState(rows);
  const [sel, setSel] = React.useState({ r: 0, c: 0, r2: 0, c2: 0 });
  const [edit, setEdit] = React.useState(null);
  const [widths, setWidths] = React.useState({});
  const [frozen, setFrozen] = React.useState(freeze);
  const [resizing, setResizing] = React.useState(null);
  const [drag, setDrag] = React.useState(null);
  const [scrollLeft, setScrollLeft] = React.useState(0);
  const past = React.useRef([]);
  const future = React.useRef([]);
  const vpRef = React.useRef(null);
  const editRef = React.useRef(null);

  React.useEffect(() => { setData(rows); }, [rows]);
  React.useEffect(() => { setFrozen(freeze); }, [freeze]);
  React.useEffect(() => { if (editRef.current) editRef.current.focus({ preventScroll: true }); }, [edit]);

  const cols = React.useMemo(
    () => columns.map((c) => ({ ...c, width: widths[c.key] ?? c.width ?? 150 })),
    [columns, widths],
  );
  const rhW = showRowHeaders ? 52 : 0;
  const template = (showRowHeaders ? `${rhW}px ` : '') + cols.map((c) => `${c.width}px`).join(' ');
  const minW = rhW + cols.reduce((s, c) => s + c.width, 0);

  const lefts = React.useMemo(() => {
    const m = [];
    let x = rhW;
    cols.forEach((c, i) => { m[i] = x; x += c.width; });
    return m;
  }, [cols, rhW]);

  const pinStyle = (i, z) => (i < frozen ? { position: 'sticky', left: lefts[i], zIndex: z } : undefined);
  const pinClass = (i) => (i < frozen ? ' ilp-xl__pin' + (i === frozen - 1 ? ' ilp-xl__pin--edge' : '') : '');

  /* ---------------- mutation ---------------- */
  const commit = React.useCallback((next, note) => {
    past.current = [...past.current.slice(-49), data];
    future.current = [];
    setData(next);
    onChange && onChange(next, note);
  }, [data, onChange]);

  const writeCell = (r, c, raw) => {
    const col = cols[c];
    if (!col || col.readOnly || readOnly) return;
    const value = parseCell(raw, col);
    const next = data.map((row, i) => (i === r ? { ...row, [col.key]: value } : row));
    commit(next, { row: r, column: col.key, value });
  };

  const writeRange = (startR, startC, matrix) => {
    const next = data.map((row) => ({ ...row }));
    matrix.forEach((line, dr) => {
      const r = startR + dr;
      if (!next[r]) return;
      line.forEach((raw, dc) => {
        const col = cols[startC + dc];
        if (!col || col.readOnly) return;
        next[r][col.key] = parseCell(raw, col);
      });
    });
    commit(next, { paste: true });
  };

  const undo = () => {
    if (!past.current.length) return;
    const prev = past.current.pop();
    future.current = [data, ...future.current.slice(0, 49)];
    setData(prev);
    onChange && onChange(prev, { undo: true });
  };
  const redo = () => {
    if (!future.current.length) return;
    const next = future.current.shift();
    past.current = [...past.current, data];
    setData(next);
    onChange && onChange(next, { redo: true });
  };

  const addRow = () => {
    const blank = newRow ? newRow(data.length) : Object.fromEntries(cols.map((c) => [c.key, c.type === 'checkbox' ? false : '']));
    commit([...data, { [rowKey]: `new-${Date.now()}`, ...blank }], { added: true });
    setSel({ r: data.length, c: 0, r2: data.length, c2: 0 });
  };
  const deleteRows = () => {
    const from = Math.min(sel.r, sel.r2);
    const to = Math.max(sel.r, sel.r2);
    commit(data.filter((_, i) => i < from || i > to), { deleted: to - from + 1 });
    setSel({ r: Math.max(0, from - 1), c: sel.c, r2: Math.max(0, from - 1), c2: sel.c });
  };

  /* ---------------- selection ---------------- */
  const range = {
    r1: Math.min(sel.r, sel.r2), r2: Math.max(sel.r, sel.r2),
    c1: Math.min(sel.c, sel.c2), c2: Math.max(sel.c, sel.c2),
  };
  const inRange = (r, c) => r >= range.r1 && r <= range.r2 && c >= range.c1 && c <= range.c2;

  const move = (dr, dc, extend) => {
    const r = Math.max(0, Math.min(data.length - 1, (extend ? sel.r2 : sel.r) + dr));
    const c = Math.max(0, Math.min(cols.length - 1, (extend ? sel.c2 : sel.c) + dc));
    setSel(extend ? { ...sel, r2: r, c2: c } : { r, c, r2: r, c2: c });
    const vp = vpRef.current;
    if (vp && !extend) {
      const top = r * rowHeight;
      const headH = 32;
      if (top < vp.scrollTop) vp.scrollTop = top;
      else if (top + rowHeight > vp.scrollTop + vp.clientHeight - headH) vp.scrollTop = top + rowHeight - vp.clientHeight + headH;
      const x = lefts[c];
      if (x - rhW < vp.scrollLeft) vp.scrollLeft = Math.max(0, x - rhW);
      else if (x + cols[c].width > vp.scrollLeft + vp.clientWidth) vp.scrollLeft = x + cols[c].width - vp.clientWidth;
    }
  };

  const startEdit = (r, c, seed) => {
    const col = cols[c];
    if (!col || col.readOnly || readOnly) return;
    if (col.type === 'checkbox') {
      writeCell(r, c, !data[r][col.key]);
      return;
    }
    setEdit({ r, c, value: seed != null ? seed : rawFor(data[r][col.key], col) });
  };

  const rawFor = (v, col) => {
    if (v == null) return '';
    if (col.type === 'datetime') return String(v).slice(0, 16);
    if (col.type === 'date') return String(v).slice(0, 10);
    return String(v);
  };

  const closeEdit = (save, moveDir = 'down') => {
    if (!edit) return;
    if (save) writeCell(edit.r, edit.c, edit.value);
    setEdit(null);
    vpRef.current && vpRef.current.focus();
    if (save && moveDir === 'down') move(1, 0);
    if (save && moveDir === 'right') move(0, 1);
  };

  const clearRange = () => {
    const next = data.map((row, r) => {
      if (r < range.r1 || r > range.r2) return row;
      const copy = { ...row };
      for (let c = range.c1; c <= range.c2; c++) {
        const col = cols[c];
        if (col && !col.readOnly) copy[col.key] = col.type === 'checkbox' ? false : '';
      }
      return copy;
    });
    commit(next, { cleared: true });
  };

  const selectionTSV = () => {
    const lines = [];
    for (let r = range.r1; r <= range.r2; r++) {
      const line = [];
      for (let c = range.c1; c <= range.c2; c++) line.push(data[r]?.[cols[c].key] ?? '');
      lines.push(line.join('\t'));
    }
    return lines.join('\n');
  };

  const onKeyDown = (e) => {
    if (edit) return;
    const mod = e.ctrlKey || e.metaKey;
    if (mod && e.key.toLowerCase() === 'z') { e.preventDefault(); e.shiftKey ? redo() : undo(); return; }
    if (mod && e.key.toLowerCase() === 'y') { e.preventDefault(); redo(); return; }
    if (mod && e.key.toLowerCase() === 'c') {
      e.preventDefault();
      const text = selectionTSV();
      navigator.clipboard?.writeText(text).catch(() => {});
      return;
    }
    if (mod && e.key.toLowerCase() === 'a') { e.preventDefault(); setSel({ r: 0, c: 0, r2: data.length - 1, c2: cols.length - 1 }); return; }
    switch (e.key) {
      case 'ArrowUp': e.preventDefault(); move(-1, 0, e.shiftKey); break;
      case 'ArrowDown': e.preventDefault(); move(1, 0, e.shiftKey); break;
      case 'ArrowLeft': e.preventDefault(); move(0, -1, e.shiftKey); break;
      case 'ArrowRight': e.preventDefault(); move(0, 1, e.shiftKey); break;
      case 'Tab': e.preventDefault(); move(0, e.shiftKey ? -1 : 1); break;
      case 'Enter': e.preventDefault(); startEdit(sel.r, sel.c); break;
      case 'F2': e.preventDefault(); startEdit(sel.r, sel.c); break;
      case 'Backspace':
      case 'Delete': e.preventDefault(); clearRange(); break;
      case 'Escape': setSel({ ...sel, r2: sel.r, c2: sel.c }); break;
      case ' ': {
        const col = cols[sel.c];
        if (col?.type === 'checkbox') { e.preventDefault(); startEdit(sel.r, sel.c); }
        break;
      }
      default:
        if (e.key.length === 1 && !mod) { e.preventDefault(); startEdit(sel.r, sel.c, e.key); }
    }
  };

  const onPaste = (e) => {
    if (edit) return;
    const text = e.clipboardData?.getData('text/plain');
    if (!text) return;
    e.preventDefault();
    writeRange(range.r1, range.c1, text.replace(/\r/g, '').split('\n').map((l) => l.split('\t')));
  };

  /* ---------------- resize + fill ---------------- */
  React.useEffect(() => {
    if (!resizing) return;
    const mm = (e) => setWidths((w) => ({ ...w, [resizing.key]: Math.max(resizing.min, Math.round(resizing.start + (e.clientX - resizing.x))) }));
    const mu = () => setResizing(null);
    window.addEventListener('mousemove', mm);
    window.addEventListener('mouseup', mu);
    document.body.style.cursor = 'col-resize';
    return () => { window.removeEventListener('mousemove', mm); window.removeEventListener('mouseup', mu); document.body.style.cursor = ''; };
  }, [resizing]);

  React.useEffect(() => {
    if (!drag) return;
    const mu = () => {
      if (drag.to != null && drag.to !== range.r2) {
        const from = range.r2;
        const to = drag.to;
        const next = data.map((row) => ({ ...row }));
        for (let r = Math.min(from + 1, to); r <= Math.max(to, from + 1); r++) {
          if (!next[r]) continue;
          for (let c = range.c1; c <= range.c2; c++) {
            const col = cols[c];
            if (col && !col.readOnly) next[r][col.key] = data[range.r2][col.key];
          }
        }
        commit(next, { filled: true });
        setSel({ ...sel, r2: to });
      }
      setDrag(null);
    };
    window.addEventListener('mouseup', mu);
    return () => window.removeEventListener('mouseup', mu);
  }, [drag, data, cols, range.r2, range.c1, range.c2, sel, commit]);

  /* ---------------- derived ---------------- */
  const errors = React.useMemo(() => {
    const m = new Map();
    data.forEach((row, r) => cols.forEach((col, c) => {
      const err = cellError(row[col.key], col, row);
      if (err) m.set(`${r}:${c}`, err);
    }));
    return m;
  }, [data, cols]);

  const stats = React.useMemo(() => {
    const nums = [];
    let count = 0;
    for (let r = range.r1; r <= range.r2; r++) {
      for (let c = range.c1; c <= range.c2; c++) {
        const v = data[r]?.[cols[c]?.key];
        if (v !== '' && v != null) count++;
        if (typeof v === 'number') nums.push(v);
      }
    }
    const sum = nums.reduce((a, b) => a + b, 0);
    return { count, sum, avg: nums.length ? sum / nums.length : null, numeric: nums.length };
  }, [data, cols, range.r1, range.r2, range.c1, range.c2]);

  const totalsRow = React.useMemo(() => {
    if (!totals) return null;
    const out = {};
    for (const [key, kind] of Object.entries(totals)) {
      if (typeof kind === 'function') { out[key] = kind(data); continue; }
      const nums = data.map((r) => r[key]).filter((v) => typeof v === 'number');
      const sum = nums.reduce((a, b) => a + b, 0);
      out[key] = kind === 'sum' ? sum : kind === 'avg' ? (nums.length ? sum / nums.length : 0) : kind === 'count' ? data.length : '';
    }
    return out;
  }, [totals, data]);

  const cellRect = (r, c) => ({
    left: lefts[c] - (c < frozen ? 0 : 0),
    top: r * rowHeight,
    width: cols[c].width,
    height: rowHeight,
  });
  const ring = cellRect(range.r1, range.c1);
  // Frozen cells are position:sticky (viewport space); the overlay is absolute
  // (content space). Add the live scroll offset back so the two stay together.
  const pinOffset = (c) => (c < frozen ? scrollLeft : 0);
  const ringLeft = ring.left + pinOffset(range.c1);
  const ringW = lefts[range.c2] + cols[range.c2].width - lefts[range.c1];
  const fillTo = drag && drag.to != null ? Math.max(range.r2, drag.to) : range.r2;
  const ringH = (fillTo - range.r1 + 1) * rowHeight;

  const editCol = edit ? cols[edit.c] : null;

  return (
    <div className={'ilp-xl' + (className ? ' ' + className : '')} {...rest} style={{ height, ...(rest.style || {}) }}>
      {showToolbar && (
        <div className="ilp-xl__bar">
          {title && <span className="ilp-xl__ttl">{title}</span>}
          {!title && <span style={{ marginRight: 'auto' }} />}
          <span className="ilp-xl__ref">{COL_LETTER(sel.c)}{sel.r + 1}</span>
          <button type="button" className="ilp-xl__tool" onClick={undo} disabled={!past.current.length} title="Undo (Ctrl+Z)"><IcUndo /></button>
          <button type="button" className="ilp-xl__tool" onClick={redo} disabled={!future.current.length} title="Redo (Ctrl+Shift+Z)"><IcRedo /></button>
          <button
            type="button" className="ilp-xl__tool" aria-pressed={frozen > 0}
            onClick={() => setFrozen(frozen > 0 ? 0 : (freeze || 2))}
            title="Freeze the leading columns"
          ><IcFreeze />{frozen > 0 ? `Frozen ${frozen}` : 'Freeze'}</button>
          {allowAddRows && <button type="button" className="ilp-xl__tool" onClick={addRow}><IcPlus />Row</button>}
          {allowDeleteRows && <button type="button" className="ilp-xl__tool" onClick={deleteRows} disabled={!data.length}><IcTrash /></button>}
          <button
            type="button" className="ilp-xl__tool" title="Copy the sheet as TSV"
            onClick={() => navigator.clipboard?.writeText([cols.map((c) => c.header).join('\t'), ...data.map((row) => cols.map((c) => row[c.key] ?? '').join('\t'))].join('\n')).catch(() => {})}
          ><IcDownload /></button>
        </div>
      )}

      <div
        className="ilp-xl__vp" ref={vpRef} tabIndex={0}
        onKeyDown={onKeyDown} onPaste={onPaste}
        onScroll={(e) => frozen > 0 && setScrollLeft(e.currentTarget.scrollLeft)}
        role="grid" aria-rowcount={data.length} aria-colcount={cols.length}
      >
        <div className="ilp-xl__in" style={{ minWidth: minW }}>
          <div className="ilp-xl__head">
            <div className="ilp-xl__hrow" style={{ gridTemplateColumns: template, height: 32 }} role="row">
              {showRowHeaders && <div className="ilp-xl__rh ilp-xl__rh--corner ilp-xl__pin" style={{ position: 'sticky', left: 0, zIndex: 36 }} />}
              {cols.map((col, c) => (
                <div
                  key={col.key}
                  role="columnheader"
                  className={'ilp-xl__hc' + (isNumeric(col.type) ? ' ilp-xl__hc--num' : col.type === 'checkbox' ? ' ilp-xl__hc--ctr' : '')
                    + (c >= range.c1 && c <= range.c2 ? ' ilp-xl__hc--active' : '') + pinClass(c)}
                  style={pinStyle(c, 35)}
                  onClick={() => setSel({ r: 0, c, r2: data.length - 1, c2: c })}
                >
                  {showColumnLetters && <em>{COL_LETTER(c)}</em>}
                  <span style={{ overflow: 'hidden', textOverflow: 'ellipsis' }}>{col.header}</span>
                  {col.required && <span className="ilp-xl__req">*</span>}
                  {col.resizable !== false && (
                    <span
                      className="ilp-xl__grip"
                      onMouseDown={(e) => { e.preventDefault(); e.stopPropagation(); setResizing({ key: col.key, x: e.clientX, start: col.width, min: col.minWidth || 72 }); }}
                      onClick={(e) => e.stopPropagation()}
                    />
                  )}
                </div>
              ))}
            </div>
          </div>

          <div style={{ position: 'relative', height: data.length * rowHeight }}>
            {data.map((row, r) => (
              <div
                key={row[rowKey] ?? r}
                className="ilp-xl__row"
                style={{ position: 'absolute', top: r * rowHeight, left: 0, right: 0, height: rowHeight, gridTemplateColumns: template }}
                role="row"
              >
                {showRowHeaders && (
                  <div
                    className={'ilp-xl__rh ilp-xl__pin' + (r >= range.r1 && r <= range.r2 ? ' ilp-xl__rh--active' : '')}
                    style={{ position: 'sticky', left: 0, zIndex: 12 }}
                    onClick={() => setSel({ r, c: 0, r2: r, c2: cols.length - 1 })}
                  >{r + 1}</div>
                )}
                {cols.map((col, c) => {
                  const v = row[col.key];
                  const err = errors.get(`${r}:${c}`);
                  const selected = inRange(r, c);
                  const content = col.render
                    ? col.render(v, row)
                    : col.type === 'checkbox'
                      ? <input type="checkbox" className="ilp-xl__cb" checked={!!v} readOnly tabIndex={-1} />
                      : col.type === 'select'
                        ? (v ? <span className={'ilp-xl__pill' + (col.tones?.[v] ? ' ilp-xl__pill--' + col.tones[v] : '')}>{optionLabel(col, v)}</span> : <span className="ilp-xl__muted">—</span>)
                        : <span>{displayCell(v, col)}</span>;
                  return (
                    <div
                      key={col.key}
                      role="gridcell"
                      title={err || undefined}
                      className={'ilp-xl__cell'
                        + (isNumeric(col.type) ? ' ilp-xl__cell--num' : col.type === 'checkbox' ? ' ilp-xl__cell--ctr' : '')
                        + (col.readOnly ? ' ilp-xl__cell--ro' : '')
                        + (selected ? ' ilp-xl__cell--in' : '')
                        + (err ? ' ilp-xl__cell--bad' : '') + pinClass(c)}
                      style={pinStyle(c, 10)}
                      onMouseDown={(e) => {
                        if (e.shiftKey) setSel((s) => ({ ...s, r2: r, c2: c }));
                        else setSel({ r, c, r2: r, c2: c });
                        vpRef.current && vpRef.current.focus();
                      }}
                      onMouseEnter={() => drag && setDrag((d) => ({ ...d, to: r }))}
                      onDoubleClick={() => startEdit(r, c)}
                    >
                      {content}
                      {col.type === 'select' && !col.readOnly && <span className="ilp-xl__caret">▾</span>}
                    </div>
                  );
                })}
              </div>
            ))}

            {!edit && (
              <div
                className={'ilp-xl__ring' + (drag ? ' ilp-xl__ring--fill' : '')}
                style={{ left: ringLeft, top: ring.top, width: ringW, height: ringH }}
              >
                {!readOnly && (
                  <span
                    className="ilp-xl__fill"
                    style={{ position: 'absolute', right: -5, bottom: -5 }}
                    onMouseDown={(e) => { e.preventDefault(); e.stopPropagation(); setDrag({ to: range.r2 }); }}
                  />
                )}
              </div>
            )}

            {edit && editCol && (
              <div
                className={'ilp-xl__ed' + (isNumeric(editCol.type) ? ' ilp-xl__ed--num' : '')}
                style={{ left: lefts[edit.c] + pinOffset(edit.c), top: edit.r * rowHeight, width: editCol.width, height: rowHeight }}
              >
                {editCol.type === 'select' ? (
                  <select
                    ref={editRef}
                    value={edit.value}
                    onChange={(e) => { writeCell(edit.r, edit.c, e.target.value); setEdit(null); vpRef.current?.focus(); }}
                    onBlur={() => setEdit(null)}
                    onKeyDown={(e) => { if (e.key === 'Escape') { e.stopPropagation(); setEdit(null); vpRef.current?.focus(); } }}
                  >
                    <option value=""></option>
                    {(editCol.options || []).map((o) => {
                      const value = typeof o === 'object' ? o.value : o;
                      return <option key={value} value={value}>{typeof o === 'object' ? o.label : o}</option>;
                    })}
                  </select>
                ) : (
                  <input
                    ref={editRef}
                    type={editCol.type === 'date' ? 'date' : editCol.type === 'datetime' ? 'datetime-local' : editCol.type === 'time' ? 'time' : isNumeric(editCol.type) ? 'number' : 'text'}
                    step={editCol.step ?? (editCol.type === 'currency' ? '0.01' : undefined)}
                    value={edit.value}
                    onChange={(e) => setEdit({ ...edit, value: e.target.value })}
                    onBlur={() => closeEdit(true, null)}
                    onKeyDown={(e) => {
                      e.stopPropagation();
                      if (e.key === 'Enter') { e.preventDefault(); closeEdit(true, 'down'); }
                      else if (e.key === 'Tab') { e.preventDefault(); closeEdit(true, 'right'); }
                      else if (e.key === 'Escape') { e.preventDefault(); setEdit(null); vpRef.current?.focus(); }
                    }}
                  />
                )}
              </div>
            )}
          </div>

          {totalsRow && (
            <div className="ilp-xl__trow" style={{ gridTemplateColumns: template, height: 34 }} role="row">
              {showRowHeaders && <div className="ilp-xl__tc ilp-xl__pin" style={{ position: 'sticky', left: 0, zIndex: 27 }} />}
              {cols.map((col, c) => (
                <div
                  key={col.key}
                  className={'ilp-xl__tc' + (isNumeric(col.type) ? ' ilp-xl__tc--num' : '') + pinClass(c)}
                  style={pinStyle(c, 26)}
                >
                  {totalsRow[col.key] != null && totalsRow[col.key] !== ''
                    ? (typeof totalsRow[col.key] === 'number' ? displayCell(totalsRow[col.key], col) : totalsRow[col.key])
                    : ''}
                </div>
              ))}
            </div>
          )}
        </div>
      </div>

      {showStatusBar && (
        <div className="ilp-xl__status">
          <span><b>{data.length}</b> rows · <b>{cols.length}</b> columns</span>
          <span>Selected <b>{(range.r2 - range.r1 + 1) * (range.c2 - range.c1 + 1)}</b></span>
          {stats.numeric > 0 && <span>Sum <b>{NUM.format(Math.round(stats.sum * 100) / 100)}</b></span>}
          {stats.avg != null && <span>Avg <b>{NUM.format(Math.round(stats.avg * 100) / 100)}</b></span>}
          {errors.size > 0 && <span className="err">{errors.size} cell{errors.size > 1 ? 's' : ''} need attention</span>}
          <span className="ilp-xl__hint">Double-click or Enter to edit · Ctrl+C / Ctrl+V · drag the handle to fill</span>
        </div>
      )}
    </div>
  );
}
