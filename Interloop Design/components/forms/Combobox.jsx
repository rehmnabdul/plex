import React from 'react';

const CSS = `
.ilp-cb{position:relative;font-family:var(--font-sans);min-width:0}
.ilp-cb *{box-sizing:border-box}
.ilp-cb__lbl{display:block;margin-bottom:6px;font-size:var(--fs-sm);font-weight:var(--weight-bold);color:var(--text-primary)}
.ilp-cb__lbl em{font-style:normal;color:var(--status-danger);margin-left:2px}
.ilp-cb__hint{margin:6px 0 0;font-size:var(--fs-xs);color:var(--text-muted)}
.ilp-cb__err{margin:6px 0 0;font-size:var(--fs-xs);font-weight:var(--weight-semibold);color:var(--il-red-ink)}

.ilp-cb__field{display:flex;align-items:center;gap:7px;width:100%;min-height:40px;padding:5px 9px 5px 11px;background:var(--surface-card);border:1px solid var(--border-default);border-radius:var(--radius-md);cursor:text;transition:border-color var(--dur-fast) var(--ease-standard),box-shadow var(--dur-fast) var(--ease-standard)}
.ilp-cb__field:hover{border-color:var(--border-strong)}
.ilp-cb__field--open,.ilp-cb__field:focus-within{border-color:var(--border-focus);box-shadow:var(--ring)}
.ilp-cb__field--bad{border-color:var(--status-danger)}
.ilp-cb__field--off{background:var(--il-grayblue-50);cursor:not-allowed;opacity:.7}
.ilp-cb__field--multi{flex-wrap:wrap;padding:5px 9px 5px 6px}
.ilp-cb__in{flex:1 1 60px;min-width:60px;height:28px;padding:0;font:inherit;font-size:var(--fs-sm);color:var(--text-primary);background:transparent;border:0;outline:none}
.ilp-cb__in::placeholder{color:var(--text-muted)}
.ilp-cb__in[readonly]{cursor:pointer}
.ilp-cb__ico{display:grid;place-items:center;width:18px;height:18px;flex:none;color:var(--text-muted)}
.ilp-cb__ico svg{width:16px;height:16px}
.ilp-cb__x{display:grid;place-items:center;width:22px;height:22px;flex:none;padding:0;color:var(--text-muted);background:transparent;border:0;border-radius:var(--radius-xs);cursor:pointer}
.ilp-cb__x:hover{background:var(--il-grayblue-100);color:var(--text-primary)}
.ilp-cb__x svg{width:13px;height:13px}
.ilp-cb__cx{transition:transform var(--dur-fast) var(--ease-standard)}
.ilp-cb__cx--open{transform:rotate(180deg)}

/* chips */
.ilp-cb__chip{display:inline-flex;align-items:center;gap:5px;height:26px;padding:0 4px 0 10px;font-size:var(--fs-xs);font-weight:var(--weight-semibold);color:var(--il-blue-800);background:var(--il-blue-100);border:1px solid var(--il-blue-200);border-radius:var(--radius-pill);max-width:100%}
.ilp-cb__chip span{overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
.ilp-cb__chip--bad{color:var(--il-red-ink);background:var(--il-red-soft);border-color:#f8cfcb}
.ilp-cb__chip button{display:grid;place-items:center;width:17px;height:17px;flex:none;padding:0;color:inherit;background:transparent;border:0;border-radius:50%;cursor:pointer}
.ilp-cb__chip button:hover{background:rgba(0,0,0,.08)}
.ilp-cb__chip button svg{width:11px;height:11px}
.ilp-cb__more{font-size:var(--fs-xs);font-weight:var(--weight-bold);color:var(--text-muted);padding:0 4px}

/* menu */
.ilp-cb__menu{position:absolute;z-index:800;left:0;right:0;top:calc(100% + 5px);max-height:264px;overflow-y:auto;padding:5px;background:var(--surface-card);border:1px solid var(--border-default);border-radius:var(--radius-md);box-shadow:var(--shadow-lg);animation:ilp-cb-in var(--dur-fast) var(--ease-out)}
@keyframes ilp-cb-in{from{opacity:0;transform:translateY(-4px)}}
.ilp-cb__grp{padding:8px 10px 5px;font-size:10px;font-weight:var(--weight-bold);letter-spacing:.07em;text-transform:uppercase;color:var(--text-muted)}
.ilp-cb__opt{display:flex;align-items:center;gap:9px;width:100%;padding:8px 10px;font:inherit;font-size:var(--fs-sm);color:var(--text-primary);background:transparent;border:0;border-radius:var(--radius-sm);cursor:pointer;text-align:left}
.ilp-cb__opt:hover,.ilp-cb__opt--cursor{background:var(--surface-hover)}
.ilp-cb__opt--on{font-weight:var(--weight-semibold);color:var(--il-blue-700)}
.ilp-cb__opt[disabled]{opacity:.45;cursor:not-allowed;background:transparent}
.ilp-cb__opt em{display:block;font-style:normal;font-size:var(--fs-xs);font-weight:var(--weight-regular);color:var(--text-muted);margin-top:1px}
.ilp-cb__opt .t{flex:1;min-width:0}
.ilp-cb__opt .t b{font-weight:inherit}
.ilp-cb__tick{display:grid;place-items:center;width:16px;height:16px;flex:none;border:1.5px solid var(--border-strong);border-radius:var(--radius-xs);color:transparent}
.ilp-cb__opt--on .ilp-cb__tick{background:var(--brand-primary);border-color:var(--brand-primary);color:#fff}
.ilp-cb__tick svg{width:11px;height:11px}
.ilp-cb__mark{background:var(--il-sun-soft);color:var(--il-sun-ink);border-radius:2px}
.ilp-cb__none{padding:18px 12px;text-align:center;font-size:var(--fs-sm);color:var(--text-muted)}
.ilp-cb__foot{display:flex;gap:6px;padding:6px 4px 2px;margin-top:4px;border-top:1px solid var(--border-subtle)}
.ilp-cb__foot button{flex:1;height:28px;font:inherit;font-size:var(--fs-xs);font-weight:var(--weight-semibold);color:var(--text-secondary);background:var(--surface-card);border:1px solid var(--border-default);border-radius:var(--radius-sm);cursor:pointer}
.ilp-cb__foot button:hover{background:var(--surface-hover);color:var(--text-primary)}
`;

function useCSS() {
  React.useEffect(() => {
    if (document.getElementById('ilp-combobox-css')) return;
    const s = document.createElement('style');
    s.id = 'ilp-combobox-css';
    s.textContent = CSS;
    document.head.appendChild(s);
  }, []);
}

const Ic = (d, w = 2) => (p) => (
  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={w} strokeLinecap="round" strokeLinejoin="round" aria-hidden="true" {...p}>
    {d.map((x, i) => <path key={i} d={x} />)}
  </svg>
);
const IcChev = Ic(['m6 9 6 6 6-6'], 2.4);
const IcX = Ic(['M6 6l12 12', 'M18 6 6 18'], 2.4);
const IcCheck = Ic(['m4 12.5 5 5L20 6.5'], 2.4);
const IcSearch = Ic(['M11 19a8 8 0 1 0 0-16 8 8 0 0 0 0 16Z', 'm21 21-4.3-4.3']);

const norm = (o) => (typeof o === 'object' && o !== null ? o : { value: o, label: String(o) });
const useOutside = (ref, on, cb) => {
  React.useEffect(() => {
    if (!on) return;
    const h = (e) => { if (ref.current && !ref.current.contains(e.target)) cb(); };
    document.addEventListener('mousedown', h);
    return () => document.removeEventListener('mousedown', h);
  }, [on, ref, cb]);
};

/** Highlights the matched run so the user can see why a row survived the filter. */
function Mark({ text, q }) {
  if (!q) return <b>{text}</b>;
  const i = String(text).toLowerCase().indexOf(q.toLowerCase());
  if (i < 0) return <b>{text}</b>;
  return (
    <b>{text.slice(0, i)}<span className="ilp-cb__mark">{text.slice(i, i + q.length)}</span>{text.slice(i + q.length)}</b>
  );
}

function Shell({ label, required, hint, error, children, className = '', ...rest }) {
  useCSS();
  return (
    <div className={'ilp-cb' + (className ? ' ' + className : '')} {...rest}>
      {label && <label className="ilp-cb__lbl">{label}{required && <em>*</em>}</label>}
      {children}
      {error ? <p className="ilp-cb__err" role="alert">{error}</p> : hint ? <p className="ilp-cb__hint">{hint}</p> : null}
    </div>
  );
}

/**
 * Searchable single-select. Type to filter, arrows to move, Enter to pick.
 * Pass `onSearch` to filter server-side instead.
 */
export function Combobox({
  options = [], value, onChange, label, placeholder = 'Select…', required, hint, error,
  disabled, clearable = true, onSearch, loading = false, emptyMessage = 'No matches',
  groupBy, renderOption, className = '', ...rest
}) {
  useCSS();
  const [open, setOpen] = React.useState(false);
  const [q, setQ] = React.useState('');
  const [cursor, setCursor] = React.useState(0);
  const root = React.useRef(null);
  const input = React.useRef(null);
  useOutside(root, open, () => { setOpen(false); setQ(''); });

  const items = React.useMemo(() => {
    const all = options.map(norm);
    if (onSearch || !q) return all;
    return all.filter((o) => o.label.toLowerCase().includes(q.toLowerCase()));
  }, [options, q, onSearch]);

  const selected = options.map(norm).find((o) => o.value === value);

  const pick = (o) => {
    if (o.disabled) return;
    onChange && onChange(o.value, o);
    setOpen(false);
    setQ('');
  };

  const key = (e) => {
    if (e.key === 'ArrowDown' || e.key === 'ArrowUp') {
      e.preventDefault();
      if (!open) { setOpen(true); return; }
      setCursor((c) => Math.max(0, Math.min(items.length - 1, c + (e.key === 'ArrowDown' ? 1 : -1))));
    } else if (e.key === 'Enter' && open) { e.preventDefault(); items[cursor] && pick(items[cursor]); }
    else if (e.key === 'Escape') { setOpen(false); setQ(''); }
  };

  let lastGroup = null;
  return (
    <Shell label={label} required={required} hint={hint} error={error} className={className} {...rest}>
      <div ref={root} style={{ position: 'relative' }}>
        <div
          className={'ilp-cb__field' + (open ? ' ilp-cb__field--open' : '') + (error ? ' ilp-cb__field--bad' : '') + (disabled ? ' ilp-cb__field--off' : '')}
          onClick={() => { if (!disabled) { setOpen(true); input.current?.focus(); } }}
        >
          <span className="ilp-cb__ico"><IcSearch /></span>
          <input
            ref={input} className="ilp-cb__in" disabled={disabled}
            role="combobox" aria-expanded={open} aria-autocomplete="list" aria-label={label || placeholder}
            value={open ? q : (selected ? selected.label : '')}
            placeholder={selected ? selected.label : placeholder}
            onChange={(e) => { setQ(e.target.value); setCursor(0); setOpen(true); onSearch && onSearch(e.target.value); }}
            onKeyDown={key}
          />
          {clearable && selected && !disabled && (
            <button type="button" className="ilp-cb__x" aria-label="Clear" onClick={(e) => { e.stopPropagation(); onChange && onChange(null, null); }}><IcX /></button>
          )}
          <span className={'ilp-cb__ico ilp-cb__cx' + (open ? ' ilp-cb__cx--open' : '')}><IcChev /></span>
        </div>

        {open && (
          <div className="ilp-cb__menu" role="listbox">
            {loading && <div className="ilp-cb__none">Searching…</div>}
            {!loading && items.length === 0 && <div className="ilp-cb__none">{emptyMessage}</div>}
            {!loading && items.map((o, i) => {
              const head = groupBy && o[groupBy] !== lastGroup ? (lastGroup = o[groupBy]) : null;
              return (
                <React.Fragment key={o.value}>
                  {head && <div className="ilp-cb__grp">{head}</div>}
                  <button
                    type="button" role="option" aria-selected={o.value === value} disabled={o.disabled}
                    className={'ilp-cb__opt' + (o.value === value ? ' ilp-cb__opt--on' : '') + (i === cursor ? ' ilp-cb__opt--cursor' : '')}
                    onMouseEnter={() => setCursor(i)} onClick={() => pick(o)}
                  >
                    <span className="t">
                      {renderOption ? renderOption(o, q) : <><Mark text={o.label} q={q} />{o.meta && <em>{o.meta}</em>}</>}
                    </span>
                    {o.value === value && <IcCheck style={{ width: 15, height: 15, color: 'var(--il-blue-600)' }} />}
                  </button>
                </React.Fragment>
              );
            })}
          </div>
        )}
      </div>
    </Shell>
  );
}

/** Multi-select with chips in the field and checkboxes in the menu. */
export function MultiSelect({
  options = [], value = [], onChange, label, placeholder = 'Select…', required, hint, error,
  disabled, maxChips = 3, showSelectAll = true, emptyMessage = 'No matches', className = '', ...rest
}) {
  useCSS();
  const [open, setOpen] = React.useState(false);
  const [q, setQ] = React.useState('');
  const root = React.useRef(null);
  useOutside(root, open, () => { setOpen(false); setQ(''); });

  const all = options.map(norm);
  const items = q ? all.filter((o) => o.label.toLowerCase().includes(q.toLowerCase())) : all;
  const chosen = all.filter((o) => value.includes(o.value));

  const toggle = (o) => {
    const next = value.includes(o.value) ? value.filter((v) => v !== o.value) : [...value, o.value];
    onChange && onChange(next);
  };

  return (
    <Shell label={label} required={required} hint={hint} error={error} className={className} {...rest}>
      <div ref={root} style={{ position: 'relative' }}>
        <div
          className={'ilp-cb__field ilp-cb__field--multi' + (open ? ' ilp-cb__field--open' : '') + (error ? ' ilp-cb__field--bad' : '') + (disabled ? ' ilp-cb__field--off' : '')}
          onClick={() => !disabled && setOpen(true)}
        >
          {chosen.slice(0, maxChips).map((o) => (
            <span className="ilp-cb__chip" key={o.value}>
              <span>{o.label}</span>
              <button type="button" aria-label={`Remove ${o.label}`} onClick={(e) => { e.stopPropagation(); toggle(o); }}><IcX /></button>
            </span>
          ))}
          {chosen.length > maxChips && <span className="ilp-cb__more">+{chosen.length - maxChips} more</span>}
          <input
            className="ilp-cb__in" disabled={disabled} value={q}
            aria-label={label || placeholder}
            placeholder={chosen.length ? '' : placeholder}
            onChange={(e) => { setQ(e.target.value); setOpen(true); }}
            onKeyDown={(e) => {
              if (e.key === 'Backspace' && !q && chosen.length) toggle(chosen[chosen.length - 1]);
              if (e.key === 'Escape') setOpen(false);
            }}
          />
          {chosen.length > 0 && !disabled && (
            <button type="button" className="ilp-cb__x" aria-label="Clear all" onClick={(e) => { e.stopPropagation(); onChange && onChange([]); }}><IcX /></button>
          )}
          <span className={'ilp-cb__ico ilp-cb__cx' + (open ? ' ilp-cb__cx--open' : '')}><IcChev /></span>
        </div>

        {open && (
          <div className="ilp-cb__menu" role="listbox" aria-multiselectable="true">
            {items.length === 0 && <div className="ilp-cb__none">{emptyMessage}</div>}
            {items.map((o) => (
              <button
                type="button" role="option" key={o.value} aria-selected={value.includes(o.value)} disabled={o.disabled}
                className={'ilp-cb__opt' + (value.includes(o.value) ? ' ilp-cb__opt--on' : '')}
                onClick={() => toggle(o)}
              >
                <span className="ilp-cb__tick"><IcCheck /></span>
                <span className="t"><Mark text={o.label} q={q} />{o.meta && <em>{o.meta}</em>}</span>
              </button>
            ))}
            {showSelectAll && items.length > 0 && (
              <div className="ilp-cb__foot">
                <button type="button" onClick={() => onChange && onChange([...new Set([...value, ...items.map((o) => o.value)])])}>Select all</button>
                <button type="button" onClick={() => onChange && onChange([])}>Clear</button>
              </div>
            )}
          </div>
        )}
      </div>
    </Shell>
  );
}

/** Free-text tags. Enter or comma commits; paste splits; Backspace removes the last. */
export function TagInput({
  value = [], onChange, label, placeholder = 'Add and press Enter', required, hint, error,
  disabled, max, suggestions = [], validate, separators = [',', 'Enter', 'Tab'], className = '', ...rest
}) {
  useCSS();
  const [draft, setDraft] = React.useState('');
  const [open, setOpen] = React.useState(false);
  const root = React.useRef(null);
  useOutside(root, open, () => setOpen(false));

  const add = (raw) => {
    const t = String(raw).trim();
    if (!t || (max && value.length >= max) || value.includes(t)) { setDraft(''); return; }
    onChange && onChange([...value, t]);
    setDraft('');
  };
  const remove = (t) => onChange && onChange(value.filter((v) => v !== t));

  const hits = suggestions.map(norm).filter((s) => !value.includes(s.value) && (!draft || s.label.toLowerCase().includes(draft.toLowerCase())));

  return (
    <Shell label={label} required={required} hint={hint ?? (max ? `${value.length} of ${max}` : undefined)} error={error} className={className} {...rest}>
      <div ref={root} style={{ position: 'relative' }}>
        <div
          className={'ilp-cb__field ilp-cb__field--multi' + (error ? ' ilp-cb__field--bad' : '') + (disabled ? ' ilp-cb__field--off' : '')}
          onClick={() => setOpen(true)}
        >
          {value.map((t) => {
            const bad = validate && validate(t) !== true;
            return (
              <span className={'ilp-cb__chip' + (bad ? ' ilp-cb__chip--bad' : '')} key={t} title={bad ? String(validate(t)) : undefined}>
                <span>{t}</span>
                <button type="button" aria-label={`Remove ${t}`} onClick={(e) => { e.stopPropagation(); remove(t); }}><IcX /></button>
              </span>
            );
          })}
          <input
            className="ilp-cb__in" value={draft} disabled={disabled || (max && value.length >= max)}
            aria-label={label || placeholder}
            placeholder={value.length ? '' : placeholder}
            onChange={(e) => { setDraft(e.target.value); setOpen(true); }}
            onPaste={(e) => {
              const text = e.clipboardData.getData('text');
              if (!/[,;\n\t]/.test(text)) return;
              e.preventDefault();
              text.split(/[,;\n\t]+/).forEach(add);
            }}
            onKeyDown={(e) => {
              if (separators.includes(e.key) || separators.includes(e.code)) {
                if (draft.trim()) { e.preventDefault(); add(draft); }
              } else if (e.key === 'Backspace' && !draft && value.length) remove(value[value.length - 1]);
            }}
          />
        </div>

        {open && hits.length > 0 && (
          <div className="ilp-cb__menu" role="listbox">
            {hits.slice(0, 8).map((s) => (
              <button type="button" role="option" aria-selected="false" key={s.value} className="ilp-cb__opt" onClick={() => add(s.label)}>
                <span className="t"><Mark text={s.label} q={draft} />{s.meta && <em>{s.meta}</em>}</span>
              </button>
            ))}
          </div>
        )}
      </div>
    </Shell>
  );
}
