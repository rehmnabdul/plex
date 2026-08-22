import React from 'react';

const CSS = `
.ilp-dt{position:relative;font-family:var(--font-sans);min-width:0}
.ilp-dt *{box-sizing:border-box}
.ilp-dt__lbl{display:block;margin-bottom:6px;font-size:var(--fs-sm);font-weight:var(--weight-bold);color:var(--text-primary)}
.ilp-dt__lbl em{font-style:normal;color:var(--status-danger);margin-left:2px}
.ilp-dt__hint{margin:6px 0 0;font-size:var(--fs-xs);color:var(--text-muted)}
.ilp-dt__err{margin:6px 0 0;font-size:var(--fs-xs);font-weight:var(--weight-semibold);color:var(--il-red-ink)}

.ilp-dt__field{display:flex;align-items:center;gap:8px;width:100%;height:40px;padding:0 9px 0 11px;background:var(--surface-card);border:1px solid var(--border-default);border-radius:var(--radius-md);cursor:pointer;transition:border-color var(--dur-fast) var(--ease-standard),box-shadow var(--dur-fast) var(--ease-standard)}
.ilp-dt__field:hover{border-color:var(--border-strong)}
.ilp-dt__field--open{border-color:var(--border-focus);box-shadow:var(--ring)}
.ilp-dt__field--bad{border-color:var(--status-danger)}
.ilp-dt__field--off{background:var(--il-grayblue-50);cursor:not-allowed;opacity:.7}
.ilp-dt__field:focus-visible{outline:none;border-color:var(--border-focus);box-shadow:var(--ring)}
.ilp-dt__val{flex:1;min-width:0;font-size:var(--fs-sm);color:var(--text-primary);text-align:left;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;font-variant-numeric:tabular-nums}
.ilp-dt__val--ph{color:var(--text-muted)}
.ilp-dt__ico{display:grid;place-items:center;width:18px;height:18px;flex:none;color:var(--text-muted)}
.ilp-dt__ico svg{width:16px;height:16px}
.ilp-dt__x{display:grid;place-items:center;width:22px;height:22px;flex:none;padding:0;color:var(--text-muted);background:transparent;border:0;border-radius:var(--radius-xs);cursor:pointer}
.ilp-dt__x:hover{background:var(--il-grayblue-100);color:var(--text-primary)}
.ilp-dt__x svg{width:13px;height:13px}

.ilp-dt__pop{position:absolute;z-index:800;top:calc(100% + 5px);left:0;display:flex;background:var(--surface-card);border:1px solid var(--border-default);border-radius:var(--radius-md);box-shadow:var(--shadow-lg);animation:ilp-dt-in var(--dur-fast) var(--ease-out)}
@keyframes ilp-dt-in{from{opacity:0;transform:translateY(-4px)}}
.ilp-dt__pop--right{left:auto;right:0}
.ilp-dt__presets{flex:none;width:150px;padding:8px 6px;border-right:1px solid var(--border-subtle);display:flex;flex-direction:column;gap:1px}
.ilp-dt__presets button{padding:7px 10px;font:inherit;font-size:var(--fs-xs);font-weight:var(--weight-semibold);color:var(--text-secondary);background:none;border:0;border-radius:var(--radius-sm);cursor:pointer;text-align:left}
.ilp-dt__presets button:hover{background:var(--surface-hover);color:var(--text-primary)}
.ilp-dt__cals{display:flex;gap:18px;padding:12px 14px}

.ilp-dt__cal{width:238px}
.ilp-dt__nav{display:flex;align-items:center;gap:6px;margin-bottom:8px}
.ilp-dt__nav b{flex:1;text-align:center;font-size:var(--fs-sm);font-weight:var(--weight-bold)}
.ilp-dt__nav button{display:grid;place-items:center;width:28px;height:28px;padding:0;color:var(--text-secondary);background:transparent;border:1px solid var(--border-default);border-radius:var(--radius-sm);cursor:pointer}
.ilp-dt__nav button:hover{background:var(--surface-hover);color:var(--text-primary)}
.ilp-dt__nav button svg{width:14px;height:14px}
.ilp-dt__dow{display:grid;grid-template-columns:repeat(7,1fr);margin-bottom:3px}
.ilp-dt__dow span{text-align:center;font-size:10px;font-weight:var(--weight-bold);letter-spacing:.05em;text-transform:uppercase;color:var(--text-muted);padding:4px 0}
.ilp-dt__days{display:grid;grid-template-columns:repeat(7,1fr);gap:1px}
.ilp-dt__d{position:relative;height:32px;font:inherit;font-size:var(--fs-sm);font-variant-numeric:tabular-nums;color:var(--text-primary);background:transparent;border:0;border-radius:var(--radius-sm);cursor:pointer}
.ilp-dt__d:hover:not([disabled]){background:var(--surface-hover)}
.ilp-dt__d--out{color:var(--text-disabled)}
.ilp-dt__d--wknd{color:var(--text-muted)}
.ilp-dt__d--today{font-weight:var(--weight-bold);box-shadow:inset 0 0 0 1px var(--border-strong)}
.ilp-dt__d--in{background:var(--il-blue-50);border-radius:0}
.ilp-dt__d--on{background:var(--brand-primary);color:#fff;font-weight:var(--weight-bold)}
.ilp-dt__d--start{border-radius:var(--radius-sm) 0 0 var(--radius-sm)}
.ilp-dt__d--end{border-radius:0 var(--radius-sm) var(--radius-sm) 0}
.ilp-dt__d[disabled]{opacity:.3;cursor:not-allowed}
.ilp-dt__time{display:flex;align-items:center;gap:8px;padding:10px 14px;border-top:1px solid var(--border-subtle)}
.ilp-dt__time label{font-size:var(--fs-xs);font-weight:var(--weight-bold);color:var(--text-secondary)}
.ilp-dt__time input{flex:1;height:34px;padding:0 10px;font:inherit;font-size:var(--fs-sm);font-variant-numeric:tabular-nums;color:var(--text-primary);background:var(--surface-card);border:1px solid var(--border-default);border-radius:var(--radius-sm);outline:none}
.ilp-dt__time input:focus{border-color:var(--border-focus);box-shadow:var(--ring)}
.ilp-dt__acts{display:flex;gap:8px;padding:10px 14px;border-top:1px solid var(--border-subtle)}
.ilp-dt__acts button{flex:1;height:32px;font:inherit;font-size:var(--fs-sm);font-weight:var(--weight-bold);border-radius:var(--radius-sm);cursor:pointer}
.ilp-dt__acts .g{color:var(--text-secondary);background:var(--surface-card);border:1px solid var(--border-default)}
.ilp-dt__acts .g:hover{background:var(--surface-hover);color:var(--text-primary)}
.ilp-dt__acts .p{color:#fff;background:var(--brand-primary);border:1px solid var(--brand-primary)}
.ilp-dt__acts .p:hover{background:var(--brand-primary-hover)}
`;

function useCSS() {
  React.useEffect(() => {
    if (document.getElementById('ilp-datefield-css')) return;
    const s = document.createElement('style');
    s.id = 'ilp-datefield-css';
    s.textContent = CSS;
    document.head.appendChild(s);
  }, []);
}

const Ic = (d, w = 2) => (p) => (
  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={w} strokeLinecap="round" strokeLinejoin="round" aria-hidden="true" {...p}>{d.map((x, i) => <path key={i} d={x} />)}</svg>
);
const IcCal = Ic(['M4 6h16v15H4z', 'M4 10h16', 'M8 3v4', 'M16 3v4']);
const IcClock = Ic(['M12 21a9 9 0 1 0 0-18 9 9 0 0 0 0 18Z', 'M12 7.5V12l3 2']);
const IcL = Ic(['M15 5l-7 7 7 7'], 2.4);
const IcR = Ic(['M9 5l7 7-7 7'], 2.4);
const IcX = Ic(['M6 6l12 12', 'M18 6 6 18'], 2.4);

const DOW = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];
const MONTHS = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
const iso = (d) => `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`;
const parse = (v) => (v ? (v instanceof Date ? v : new Date(v)) : null);
const same = (a, b) => a && b && iso(a) === iso(b);
const fmt = (d) => d.toLocaleDateString('en-GB', { day: '2-digit', month: 'short', year: 'numeric' });

function useOutside(ref, on, cb) {
  React.useEffect(() => {
    if (!on) return;
    const h = (e) => { if (ref.current && !ref.current.contains(e.target)) cb(); };
    document.addEventListener('mousedown', h);
    return () => document.removeEventListener('mousedown', h);
  }, [on, ref, cb]);
}

/** Month grid, Monday-first. */
function Month({ view, onNav, selected, rangeStart, rangeEnd, hover, onHover, onPick, min, max, showNav = true, today = new Date() }) {
  const first = new Date(view.getFullYear(), view.getMonth(), 1);
  const lead = (first.getDay() + 6) % 7;
  const cells = [];
  for (let i = 0; i < 42; i++) cells.push(new Date(view.getFullYear(), view.getMonth(), 1 - lead + i));
  const lo = parse(min);
  const hi = parse(max);
  const end = rangeEnd || hover;

  return (
    <div className="ilp-dt__cal">
      <div className="ilp-dt__nav">
        {showNav && <button type="button" aria-label="Previous month" onClick={() => onNav(-1)}><IcL /></button>}
        <b>{MONTHS[view.getMonth()]} {view.getFullYear()}</b>
        {showNav && <button type="button" aria-label="Next month" onClick={() => onNav(1)}><IcR /></button>}
      </div>
      <div className="ilp-dt__dow">{DOW.map((d) => <span key={d}>{d}</span>)}</div>
      <div className="ilp-dt__days">
        {cells.map((d) => {
          const out = d.getMonth() !== view.getMonth();
          const wknd = d.getDay() === 0 || d.getDay() === 6;
          const off = (lo && d < lo) || (hi && d > hi);
          const isStart = same(d, rangeStart);
          const isEnd = same(d, end);
          const inRange = rangeStart && end && d > rangeStart && d < end;
          const on = same(d, selected) || isStart || isEnd;
          return (
            <button
              key={d.getTime()} type="button" disabled={off}
              aria-label={fmt(d)} aria-pressed={on}
              className={'ilp-dt__d' + (out ? ' ilp-dt__d--out' : '') + (wknd && !out ? ' ilp-dt__d--wknd' : '')
                + (same(d, today) ? ' ilp-dt__d--today' : '') + (inRange ? ' ilp-dt__d--in' : '')
                + (on ? ' ilp-dt__d--on' : '') + (isStart && end ? ' ilp-dt__d--start' : '') + (isEnd && rangeStart ? ' ilp-dt__d--end' : '')}
              onClick={() => onPick(d)}
              onMouseEnter={() => onHover && onHover(d)}
            >
              {d.getDate()}
            </button>
          );
        })}
      </div>
    </div>
  );
}

/**
 * Date, date-time or time field with a calendar popover.
 * `mode="time"` skips the calendar entirely.
 */
export function DateField({
  value, onChange, mode = 'date', label, placeholder = 'Select a date', required, hint, error,
  disabled, min, max, clearable = true, today = new Date(), className = '', ...rest
}) {
  useCSS();
  const [open, setOpen] = React.useState(false);
  const isTime = mode === 'time';
  // new Date('07:00') is an Invalid Date — and truthy — so guard before using it.
  const parsed = isTime ? null : parse(value);
  const current = parsed && !isNaN(parsed.getTime()) ? parsed : null;
  const clock = (dt) => `${String(dt.getHours()).padStart(2, '0')}:${String(dt.getMinutes()).padStart(2, '0')}`;
  const [view, setView] = React.useState(current || today);
  const [time, setTime] = React.useState(
    isTime ? (typeof value === 'string' && value ? value : '09:00') : current ? clock(current) : '09:00',
  );
  React.useEffect(() => {
    if (isTime) { if (typeof value === 'string' && value) setTime(value); return; }
    const next = parse(value);
    if (next && !isNaN(next.getTime())) setTime(clock(next));
  }, [value, isTime]);
  const root = React.useRef(null);
  useOutside(root, open, () => setOpen(false));

  const display = !current ? '' : mode === 'time'
    ? time
    : mode === 'datetime' ? `${fmt(current)} · ${time}` : fmt(current);

  const commit = (d, t = time) => {
    const out = new Date(d);
    if (mode !== 'date') { const [h, m] = t.split(':'); out.setHours(+h || 0, +m || 0, 0, 0); }
    onChange && onChange(mode === 'date' ? iso(out) : out.toISOString(), out);
  };

  return (
    <div className={'ilp-dt' + (className ? ' ' + className : '')} {...rest}>
      {label && <label className="ilp-dt__lbl">{label}{required && <em>*</em>}</label>}
      <div ref={root} style={{ position: 'relative' }}>
        {mode === 'time' ? (
          <div className={'ilp-dt__field' + (error ? ' ilp-dt__field--bad' : '') + (disabled ? ' ilp-dt__field--off' : '')}>
            <span className="ilp-dt__ico"><IcClock /></span>
            <input
              type="time" className="ilp-dt__val" disabled={disabled} value={time} aria-label={label || placeholder}
              style={{ border: 0, background: 'transparent', outline: 'none', font: 'inherit', fontSize: 'var(--fs-sm)' }}
              onChange={(e) => { setTime(e.target.value); onChange && onChange(e.target.value); }}
            />
          </div>
        ) : (
          <button
            type="button" disabled={disabled}
            className={'ilp-dt__field' + (open ? ' ilp-dt__field--open' : '') + (error ? ' ilp-dt__field--bad' : '') + (disabled ? ' ilp-dt__field--off' : '')}
            aria-haspopup="dialog" aria-expanded={open}
            onClick={() => setOpen((o) => !o)}
          >
            <span className="ilp-dt__ico">{mode === 'datetime' ? <IcClock /> : <IcCal />}</span>
            <span className={'ilp-dt__val' + (display ? '' : ' ilp-dt__val--ph')}>{display || placeholder}</span>
            {clearable && current && !disabled && (
              <span
                role="button" tabIndex={-1} aria-label="Clear" className="ilp-dt__x"
                onClick={(e) => { e.stopPropagation(); onChange && onChange(null, null); }}
              ><IcX /></span>
            )}
          </button>
        )}

        {open && mode !== 'time' && (
          <div className="ilp-dt__pop" role="dialog" aria-label={label || 'Choose a date'} style={{ flexDirection: 'column' }}>
            <div className="ilp-dt__cals">
              <Month
                view={view} today={today} selected={current} min={min} max={max}
                onNav={(n) => setView(new Date(view.getFullYear(), view.getMonth() + n, 1))}
                onPick={(d) => { commit(d); if (mode === 'date') setOpen(false); }}
              />
            </div>
            {mode === 'datetime' && (
              <div className="ilp-dt__time">
                <label htmlFor="ilp-dt-t">Time</label>
                <input
                  id="ilp-dt-t" type="time" value={time}
                  onChange={(e) => { setTime(e.target.value); if (current) commit(current, e.target.value); }}
                />
              </div>
            )}
            <div className="ilp-dt__acts">
              <button type="button" className="g" onClick={() => { commit(today); setOpen(false); }}>Today</button>
              <button type="button" className="p" onClick={() => setOpen(false)}>Done</button>
            </div>
          </div>
        )}
      </div>
      {error ? <p className="ilp-dt__err" role="alert">{error}</p> : hint ? <p className="ilp-dt__hint">{hint}</p> : null}
    </div>
  );
}

const PRESETS = [
  { label: 'Today', days: 0 },
  { label: 'Last 7 days', days: 6 },
  { label: 'Last 14 days', days: 13 },
  { label: 'Last 30 days', days: 29 },
  { label: 'Last 90 days', days: 89 },
];

/** Two-month range picker with presets. Click start, then end. */
export function DateRangeField({
  value = {}, onChange, label, placeholder = 'Select a range', required, hint, error,
  disabled, min, max, presets = PRESETS, today = new Date(), align = 'left', className = '', ...rest
}) {
  useCSS();
  const [open, setOpen] = React.useState(false);
  const [hover, setHover] = React.useState(null);
  const start = parse(value.start);
  const end = parse(value.end);
  const [view, setView] = React.useState(start || today);
  const root = React.useRef(null);
  useOutside(root, open, () => { setOpen(false); setHover(null); });

  const display = start && end ? `${fmt(start)} – ${fmt(end)}` : start ? `${fmt(start)} – …` : '';

  const pick = (d) => {
    if (!start || (start && end)) { onChange && onChange({ start: iso(d), end: null }); setHover(null); }
    else if (d < start) onChange && onChange({ start: iso(d), end: iso(start) });
    else { onChange && onChange({ start: iso(start), end: iso(d) }); setOpen(false); }
  };

  const applyPreset = (p) => {
    const e = new Date(today);
    const s = new Date(today);
    s.setDate(s.getDate() - p.days);
    onChange && onChange({ start: iso(s), end: iso(e) });
    setView(s);
    setOpen(false);
  };

  return (
    <div className={'ilp-dt' + (className ? ' ' + className : '')} {...rest}>
      {label && <label className="ilp-dt__lbl">{label}{required && <em>*</em>}</label>}
      <div ref={root} style={{ position: 'relative' }}>
        <button
          type="button" disabled={disabled} aria-haspopup="dialog" aria-expanded={open}
          className={'ilp-dt__field' + (open ? ' ilp-dt__field--open' : '') + (error ? ' ilp-dt__field--bad' : '') + (disabled ? ' ilp-dt__field--off' : '')}
          onClick={() => setOpen((o) => !o)}
        >
          <span className="ilp-dt__ico"><IcCal /></span>
          <span className={'ilp-dt__val' + (display ? '' : ' ilp-dt__val--ph')}>{display || placeholder}</span>
          {start && !disabled && (
            <span role="button" tabIndex={-1} aria-label="Clear" className="ilp-dt__x"
              onClick={(e) => { e.stopPropagation(); onChange && onChange({ start: null, end: null }); }}><IcX /></span>
          )}
        </button>

        {open && (
          <div className={'ilp-dt__pop' + (align === 'right' ? ' ilp-dt__pop--right' : '')} role="dialog" aria-label={label || 'Choose a range'}>
            {presets.length > 0 && (
              <div className="ilp-dt__presets">
                {presets.map((p) => <button key={p.label} type="button" onClick={() => applyPreset(p)}>{p.label}</button>)}
              </div>
            )}
            <div>
              <div className="ilp-dt__cals" onMouseLeave={() => setHover(null)}>
                <Month
                  view={view} today={today} rangeStart={start} rangeEnd={end} hover={hover} min={min} max={max}
                  onNav={(n) => setView(new Date(view.getFullYear(), view.getMonth() + n, 1))}
                  onPick={pick} onHover={(d) => start && !end && setHover(d)}
                />
                <Month
                  view={new Date(view.getFullYear(), view.getMonth() + 1, 1)} today={today}
                  rangeStart={start} rangeEnd={end} hover={hover} min={min} max={max} showNav={false}
                  onNav={() => {}} onPick={pick} onHover={(d) => start && !end && setHover(d)}
                />
              </div>
              <div className="ilp-dt__acts">
                <button type="button" className="g" onClick={() => { onChange && onChange({ start: null, end: null }); setOpen(false); }}>Clear</button>
                <button type="button" className="p" onClick={() => setOpen(false)}>Done</button>
              </div>
            </div>
          </div>
        )}
      </div>
      {error ? <p className="ilp-dt__err" role="alert">{error}</p> : hint ? <p className="ilp-dt__hint">{hint}</p> : null}
    </div>
  );
}
