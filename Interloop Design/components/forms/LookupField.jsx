import React from 'react';

const CSS = `
.ilp-lk{position:relative;font-family:var(--font-sans);min-width:0}
.ilp-lk *{box-sizing:border-box}
.ilp-lk__lbl{display:block;margin-bottom:6px;font-size:var(--fs-sm);font-weight:var(--weight-bold);color:var(--text-primary)}
.ilp-lk__lbl em{font-style:normal;color:var(--status-danger);margin-left:2px}
.ilp-lk__hint{margin:6px 0 0;font-size:var(--fs-xs);color:var(--text-muted)}
.ilp-lk__err{margin:6px 0 0;font-size:var(--fs-xs);font-weight:var(--weight-semibold);color:var(--il-red-ink)}

/* lookup field */
.ilp-lk__field{display:flex;align-items:stretch;width:100%;background:var(--surface-card);border:1px solid var(--border-default);border-radius:var(--radius-md);overflow:hidden;transition:border-color var(--dur-fast) var(--ease-standard),box-shadow var(--dur-fast) var(--ease-standard)}
.ilp-lk__field:hover{border-color:var(--border-strong)}
.ilp-lk__field--bad{border-color:var(--status-danger)}
.ilp-lk__field--off{background:var(--il-grayblue-50);opacity:.7}
.ilp-lk__field:focus-within{border-color:var(--border-focus);box-shadow:var(--ring)}
.ilp-lk__disp{flex:1;min-width:0;display:flex;flex-direction:column;justify-content:center;gap:1px;height:40px;padding:0 11px;font-size:var(--fs-sm);text-align:left;background:transparent;border:0;cursor:pointer;font-family:inherit;color:var(--text-primary)}
.ilp-lk__disp b{font-weight:var(--weight-semibold);overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
.ilp-lk__disp span{font-size:var(--fs-xs);color:var(--text-muted);overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
.ilp-lk__disp--ph{color:var(--text-muted);font-weight:var(--weight-regular)}
.ilp-lk__btn{display:grid;place-items:center;width:42px;flex:none;color:var(--text-secondary);background:var(--il-grayblue-50);border:0;border-left:1px solid var(--border-default);cursor:pointer}
.ilp-lk__btn:hover{background:var(--il-grayblue-100);color:var(--text-primary)}
.ilp-lk__btn svg{width:17px;height:17px}

/* modal */
.ilp-lk__scrim{position:fixed;inset:0;z-index:1000;display:grid;place-items:center;padding:24px;background:rgba(51,59,74,.45);animation:ilp-lk-fade var(--dur-fast) var(--ease-out)}
@keyframes ilp-lk-fade{from{opacity:0}}
.ilp-lk__modal{display:flex;flex-direction:column;width:min(880px,100%);max-height:min(660px,90vh);background:var(--surface-card);border-radius:var(--radius-lg);box-shadow:var(--shadow-xl);overflow:hidden;animation:ilp-lk-up var(--dur-normal) var(--ease-out)}
@keyframes ilp-lk-up{from{opacity:0;transform:translateY(10px)}}
.ilp-lk__hd{display:flex;align-items:center;gap:12px;flex:none;padding:16px 18px;border-bottom:1px solid var(--border-subtle)}
.ilp-lk__hd .t{flex:1;min-width:0}
.ilp-lk__hd b{display:block;font-size:var(--fs-lg);font-weight:var(--weight-bold);letter-spacing:-0.015em}
.ilp-lk__hd span{display:block;margin-top:2px;font-size:var(--fs-xs);color:var(--text-muted)}
.ilp-lk__tools{display:flex;gap:10px;flex:none;padding:12px 18px;border-bottom:1px solid var(--border-subtle)}
.ilp-lk__search{position:relative;flex:1}
.ilp-lk__search svg{position:absolute;left:10px;top:50%;transform:translateY(-50%);width:16px;height:16px;color:var(--text-muted);pointer-events:none}
.ilp-lk__search input{width:100%;height:38px;padding:0 12px 0 33px;font:inherit;font-size:var(--fs-sm);color:var(--text-primary);background:var(--surface-card);border:1px solid var(--border-default);border-radius:var(--radius-md);outline:none}
.ilp-lk__search input:focus{border-color:var(--border-focus);box-shadow:var(--ring)}
.ilp-lk__grid{flex:1 1 auto;min-height:0;overflow:auto}
.ilp-lk__grid table{width:100%;border-collapse:collapse}
.ilp-lk__grid th{position:sticky;top:0;z-index:1;padding:9px 16px;text-align:left;font-size:10px;font-weight:var(--weight-bold);letter-spacing:.07em;text-transform:uppercase;color:var(--text-muted);background:var(--il-grayblue-50);border-bottom:1px solid var(--border-default);white-space:nowrap}
.ilp-lk__grid td{padding:11px 16px;font-size:var(--fs-sm);border-bottom:1px solid var(--border-subtle);white-space:nowrap}
.ilp-lk__grid tbody tr{cursor:pointer}
.ilp-lk__grid tbody tr:hover td{background:var(--il-grayblue-50)}
.ilp-lk__grid tbody tr[aria-selected="true"] td{background:var(--il-blue-50)}
.ilp-lk__grid tbody tr:focus-visible{outline:none}
.ilp-lk__grid tbody tr:focus-visible td{background:var(--il-blue-50);box-shadow:inset 0 1px 0 var(--border-focus),inset 0 -1px 0 var(--border-focus)}
.ilp-lk__num{text-align:right;font-variant-numeric:tabular-nums}
.ilp-lk__none{padding:42px 20px;text-align:center;font-size:var(--fs-sm);color:var(--text-muted)}
.ilp-lk__ft{display:flex;align-items:center;gap:10px;flex:none;padding:12px 18px;border-top:1px solid var(--border-subtle);font-size:var(--fs-xs);color:var(--text-muted)}
.ilp-lk__ft .sp{margin-left:auto}
.ilp-lk__b{height:38px;padding:0 18px;font:inherit;font-size:var(--fs-sm);font-weight:var(--weight-bold);border-radius:var(--radius-md);cursor:pointer}
.ilp-lk__b--g{color:var(--text-secondary);background:var(--surface-card);border:1px solid var(--border-default)}
.ilp-lk__b--g:hover{background:var(--surface-hover);color:var(--text-primary)}
.ilp-lk__b--p{color:#fff;background:var(--brand-primary);border:1px solid var(--brand-primary)}
.ilp-lk__b--p:hover{background:var(--brand-primary-hover)}
.ilp-lk__b[disabled]{opacity:.45;cursor:not-allowed}

/* range slider */
.ilp-rs{font-family:var(--font-sans);min-width:0}
.ilp-rs__top{display:flex;align-items:baseline;gap:8px;margin-bottom:14px}
.ilp-rs__top label{font-size:var(--fs-sm);font-weight:var(--weight-bold);color:var(--text-primary)}
.ilp-rs__out{margin-left:auto;font-size:var(--fs-sm);font-weight:var(--weight-bold);font-variant-numeric:tabular-nums;color:var(--il-blue-700)}
.ilp-rs__track{position:relative;height:22px}
.ilp-rs__rail{position:absolute;top:9px;left:0;right:0;height:5px;border-radius:3px;background:var(--il-grayblue-100)}
.ilp-rs__fill{position:absolute;top:9px;height:5px;border-radius:3px;background:var(--brand-primary)}
.ilp-rs__track input{position:absolute;top:0;left:0;width:100%;height:22px;margin:0;background:none;pointer-events:none;-webkit-appearance:none;appearance:none}
.ilp-rs__track input::-webkit-slider-thumb{-webkit-appearance:none;pointer-events:auto;width:20px;height:20px;border-radius:50%;background:var(--surface-card);border:2px solid var(--brand-primary);box-shadow:var(--shadow-sm);cursor:grab}
.ilp-rs__track input::-moz-range-thumb{pointer-events:auto;width:18px;height:18px;border-radius:50%;background:var(--surface-card);border:2px solid var(--brand-primary);box-shadow:var(--shadow-sm);cursor:grab}
.ilp-rs__track input:focus-visible::-webkit-slider-thumb{box-shadow:var(--ring)}
.ilp-rs__ticks{display:flex;justify-content:space-between;margin-top:7px;font-size:var(--fs-xs);color:var(--text-muted);font-variant-numeric:tabular-nums}

/* split button */
.ilp-sp{position:relative;display:inline-flex;font-family:var(--font-sans)}
.ilp-sp__main{display:inline-flex;align-items:center;gap:8px;height:40px;padding:0 18px;font:inherit;font-size:var(--fs-base);font-weight:var(--weight-bold);color:#fff;background:var(--brand-primary);border:1px solid var(--brand-primary);border-radius:var(--radius-md) 0 0 var(--radius-md);cursor:pointer}
.ilp-sp__main:hover{background:var(--brand-primary-hover)}
.ilp-sp__more{display:grid;place-items:center;width:38px;height:40px;color:#fff;background:var(--brand-primary);border:1px solid var(--brand-primary);border-left-color:rgba(255,255,255,.3);border-radius:0 var(--radius-md) var(--radius-md) 0;cursor:pointer}
.ilp-sp__more:hover{background:var(--brand-primary-hover)}
.ilp-sp__more svg{width:15px;height:15px}
.ilp-sp--secondary .ilp-sp__main,.ilp-sp--secondary .ilp-sp__more{color:var(--text-primary);background:var(--surface-card);border-color:var(--border-default)}
.ilp-sp--secondary .ilp-sp__main:hover,.ilp-sp--secondary .ilp-sp__more:hover{background:var(--surface-hover)}
.ilp-sp--secondary .ilp-sp__more{border-left-color:var(--border-default)}
.ilp-sp__main:focus-visible,.ilp-sp__more:focus-visible{outline:none;box-shadow:var(--ring);z-index:1}
.ilp-sp__main[disabled],.ilp-sp__more[disabled]{opacity:.5;cursor:not-allowed}
.ilp-sp__menu{position:absolute;z-index:800;top:calc(100% + 5px);right:0;min-width:220px;padding:5px;background:var(--surface-card);border:1px solid var(--border-default);border-radius:var(--radius-md);box-shadow:var(--shadow-lg)}
.ilp-sp__menu button{display:flex;align-items:center;gap:10px;width:100%;padding:9px 11px;font:inherit;font-size:var(--fs-sm);color:var(--text-primary);background:none;border:0;border-radius:var(--radius-sm);cursor:pointer;text-align:left}
.ilp-sp__menu button:hover{background:var(--surface-hover)}
.ilp-sp__menu button[disabled]{opacity:.45;cursor:not-allowed;background:none}
.ilp-sp__menu button svg{width:16px;height:16px;color:var(--text-muted);flex:none}
.ilp-sp__menu button.danger{color:var(--il-red-ink)}
.ilp-sp__menu button.danger svg{color:var(--il-red-ink)}
.ilp-sp__sep{height:1px;margin:5px 6px;background:var(--border-subtle)}
`;

function useCSS() {
  React.useEffect(() => {
    if (document.getElementById('ilp-lookup-css')) return;
    const s = document.createElement('style');
    s.id = 'ilp-lookup-css';
    s.textContent = CSS;
    document.head.appendChild(s);
  }, []);
}

const Ic = (d, w = 2) => (p) => (
  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={w} strokeLinecap="round" strokeLinejoin="round" aria-hidden="true" {...p}>{d.map((x, i) => <path key={i} d={x} />)}</svg>
);
const IcSearch = Ic(['M11 19a8 8 0 1 0 0-16 8 8 0 0 0 0 16Z', 'm21 21-4.3-4.3']);
const IcGrid = Ic(['M4 4h7v7H4z', 'M13 4h7v7h-7z', 'M4 13h7v7H4z', 'M13 13h7v7h-7z']);
const IcX = Ic(['M6 6l12 12', 'M18 6 6 18'], 2.4);
const IcChev = Ic(['m6 9 6 6 6-6'], 2.4);

const get = (row, key) => (key.indexOf('.') < 0 ? row[key] : key.split('.').reduce((o, k) => (o == null ? o : o[k]), row));

/**
 * Lookup field — a read-only display that opens a searchable grid, and takes
 * the chosen row back into the field. For picking one record out of thousands,
 * where a dropdown would be useless.
 */
export function LookupField({
  value, onChange, columns = [], rows = [], rowKey = 'id',
  label, placeholder = 'Nothing selected', required, hint, error, disabled,
  displayKey = 'name', metaKey, searchKeys, title = 'Select a record', subtitle,
  emptyMessage = 'No records match your search', clearable = true,
  className = '', ...rest
}) {
  useCSS();
  const [open, setOpen] = React.useState(false);
  const [q, setQ] = React.useState('');
  const [draft, setDraft] = React.useState(null);

  const keys = searchKeys || columns.map((c) => c.key);
  const hits = React.useMemo(() => {
    const t = q.trim().toLowerCase();
    if (!t) return rows;
    return rows.filter((r) => keys.some((k) => String(get(r, k) ?? '').toLowerCase().includes(t)));
  }, [rows, q, keys]);

  const start = () => { if (!disabled) { setDraft(value || null); setQ(''); setOpen(true); } };
  const confirm = () => { onChange && onChange(draft); setOpen(false); };

  return (
    <div className={'ilp-lk' + (className ? ' ' + className : '')} {...rest}>
      {label && <label className="ilp-lk__lbl">{label}{required && <em>*</em>}</label>}
      <div className={'ilp-lk__field' + (error ? ' ilp-lk__field--bad' : '') + (disabled ? ' ilp-lk__field--off' : '')}>
        <button type="button" className={'ilp-lk__disp' + (value ? '' : ' ilp-lk__disp--ph')} disabled={disabled} onClick={start}>
          {value ? (
            <>
              <b>{get(value, displayKey)}</b>
              {metaKey && <span>{get(value, metaKey)}</span>}
            </>
          ) : placeholder}
        </button>
        {clearable && value && !disabled && (
          <button type="button" className="ilp-lk__btn" aria-label="Clear selection" onClick={() => onChange && onChange(null)}><IcX /></button>
        )}
        <button type="button" className="ilp-lk__btn" aria-label={title} disabled={disabled} onClick={start}><IcGrid /></button>
      </div>
      {error ? <p className="ilp-lk__err" role="alert">{error}</p> : hint ? <p className="ilp-lk__hint">{hint}</p> : null}

      {open && (
        <div className="ilp-lk__scrim" onMouseDown={(e) => e.target === e.currentTarget && setOpen(false)}>
          <div className="ilp-lk__modal" role="dialog" aria-modal="true" aria-label={title}>
            <header className="ilp-lk__hd">
              <div className="t"><b>{title}</b>{subtitle && <span>{subtitle}</span>}</div>
              <button type="button" className="ilp-lk__btn" style={{ border: 0, background: 'transparent', width: 32 }} aria-label="Close" onClick={() => setOpen(false)}><IcX /></button>
            </header>
            <div className="ilp-lk__tools">
              <div className="ilp-lk__search">
                <IcSearch />
                <input autoFocus value={q} onChange={(e) => setQ(e.target.value)} placeholder="Search…" aria-label="Search records" />
              </div>
            </div>
            <div className="ilp-lk__grid">
              {hits.length === 0 ? <div className="ilp-lk__none">{emptyMessage}</div> : (
                <table>
                  <thead>
                    <tr>{columns.map((c) => <th key={c.key} className={c.numeric ? 'ilp-lk__num' : ''} style={c.width ? { width: c.width } : undefined}>{c.header}</th>)}</tr>
                  </thead>
                  <tbody>
                    {hits.map((r) => {
                      const id = r[rowKey];
                      const on = draft && draft[rowKey] === id;
                      return (
                        <tr
                          key={id} tabIndex={0} aria-selected={!!on}
                          onClick={() => setDraft(r)}
                          onDoubleClick={() => { onChange && onChange(r); setOpen(false); }}
                          onKeyDown={(e) => {
                            if (e.key === 'Enter') { e.preventDefault(); onChange && onChange(r); setOpen(false); }
                            if (e.key === ' ') { e.preventDefault(); setDraft(r); }
                          }}
                        >
                          {columns.map((c) => (
                            <td key={c.key} className={c.numeric ? 'ilp-lk__num' : ''}>
                              {c.render ? c.render(get(r, c.key), r) : get(r, c.key)}
                            </td>
                          ))}
                        </tr>
                      );
                    })}
                  </tbody>
                </table>
              )}
            </div>
            <footer className="ilp-lk__ft">
              <span>{hits.length.toLocaleString()} of {rows.length.toLocaleString()} records{draft ? ` · ${get(draft, displayKey)} selected` : ''}</span>
              <span className="sp" />
              <button type="button" className="ilp-lk__b ilp-lk__b--g" onClick={() => setOpen(false)}>Cancel</button>
              <button type="button" className="ilp-lk__b ilp-lk__b--p" disabled={!draft} onClick={confirm}>Select</button>
            </footer>
          </div>
        </div>
      )}
    </div>
  );
}

/** Dual-thumb integer range. Both thumbs share one track and cannot cross. */
export function RangeSlider({
  value = [0, 100], onChange, min = 0, max = 100, step = 1,
  label, unit = '', format, hint, showTicks = true, disabled, className = '', ...rest
}) {
  useCSS();
  const [lo, hi] = value;
  const pct = (v) => ((v - min) / (max - min || 1)) * 100;
  const show = (v) => (format ? format(v) : `${v.toLocaleString()}${unit}`);

  return (
    <div className={'ilp-rs' + (className ? ' ' + className : '')} {...rest}>
      <div className="ilp-rs__top">
        {label && <label>{label}</label>}
        <span className="ilp-rs__out">{show(lo)} – {show(hi)}</span>
      </div>
      <div className="ilp-rs__track">
        <span className="ilp-rs__rail" />
        <span className="ilp-rs__fill" style={{ left: `${pct(lo)}%`, right: `${100 - pct(hi)}%` }} />
        <input
          type="range" min={min} max={max} step={step} value={lo} disabled={disabled}
          aria-label={`${label || 'Range'} minimum`}
          onChange={(e) => onChange && onChange([Math.min(+e.target.value, hi - step), hi])}
        />
        <input
          type="range" min={min} max={max} step={step} value={hi} disabled={disabled}
          aria-label={`${label || 'Range'} maximum`}
          onChange={(e) => onChange && onChange([lo, Math.max(+e.target.value, lo + step)])}
        />
      </div>
      {showTicks && <div className="ilp-rs__ticks"><span>{show(min)}</span><span>{show(max)}</span></div>}
      {hint && <p className="ilp-lk__hint">{hint}</p>}
    </div>
  );
}

/** Primary action plus its alternates — the enterprise "save and…" control. */
export function SplitButton({
  label, onClick, items = [], variant = 'primary', disabled, icon = null, className = '', ...rest
}) {
  useCSS();
  const [open, setOpen] = React.useState(false);
  const root = React.useRef(null);
  React.useEffect(() => {
    if (!open) return;
    const h = (e) => { if (root.current && !root.current.contains(e.target)) setOpen(false); };
    document.addEventListener('mousedown', h);
    return () => document.removeEventListener('mousedown', h);
  }, [open]);

  return (
    <div ref={root} className={'ilp-sp' + (variant !== 'primary' ? ' ilp-sp--' + variant : '') + (className ? ' ' + className : '')} {...rest}>
      <button type="button" className="ilp-sp__main" disabled={disabled} onClick={onClick}>{icon}{label}</button>
      <button
        type="button" className="ilp-sp__more" disabled={disabled}
        aria-haspopup="menu" aria-expanded={open} aria-label={`More ${label} actions`}
        onClick={() => setOpen((o) => !o)}
      ><IcChev /></button>
      {open && (
        <div className="ilp-sp__menu" role="menu">
          {items.map((it, i) => (it.separator ? <div key={'s' + i} className="ilp-sp__sep" /> : (
            <button
              key={it.key || it.label} type="button" role="menuitem" disabled={it.disabled}
              className={it.danger ? 'danger' : ''}
              onClick={() => { setOpen(false); it.onSelect && it.onSelect(); }}
            >{it.icon}{it.label}</button>
          )))}
        </div>
      )}
    </div>
  );
}
