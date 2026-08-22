import React from 'react';

const CSS = `
.ilp-tp{font-family:var(--font-sans)}
.ilp-tp *{box-sizing:border-box}

/* ---------- tally pad ---------- */
.ilp-tp__grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(150px,1fr));gap:10px}
.ilp-tp__cell{display:flex;flex-direction:column;gap:8px;padding:12px;background:var(--surface-card);border:1px solid var(--border-default);border-radius:var(--radius-lg)}
.ilp-tp__cell--on{border-color:var(--brand-primary);box-shadow:0 0 0 1px var(--brand-primary) inset}
.ilp-tp__cell--crit{border-color:var(--status-danger)}
.ilp-tp__lbl{display:flex;align-items:baseline;gap:6px;font-size:13px;font-weight:var(--weight-bold);line-height:1.25}
.ilp-tp__lbl em{margin-left:auto;font-style:normal;font-size:12px;font-weight:var(--weight-bold);letter-spacing:.06em;text-transform:uppercase;color:var(--text-secondary)}
.ilp-tp__ctl{display:flex;align-items:center;gap:8px}
.ilp-tp__btn{display:grid;place-items:center;width:52px;height:52px;flex:none;padding:0;font:inherit;color:var(--text-primary);background:var(--il-grayblue-50);border:1px solid var(--border-default);border-radius:var(--radius-md);cursor:pointer;-webkit-tap-highlight-color:transparent}
.ilp-tp__btn:active{background:var(--il-grayblue-100);transform:scale(.96)}
.ilp-tp__btn[disabled]{opacity:.4}
.ilp-tp__btn:focus-visible,.ilp-tp__sg:focus-visible,.ilp-tp__cap:focus-visible{outline:none;box-shadow:var(--ring)}
.ilp-tp__btn svg{width:22px;height:22px}
.ilp-tp__btn--plus{color:#fff;background:var(--brand-primary);border-color:var(--brand-primary)}
.ilp-tp__btn--plus:active{background:var(--brand-primary-hover)}
.ilp-tp__n{flex:1;text-align:center;font-size:26px;font-weight:var(--weight-black);font-variant-numeric:tabular-nums;letter-spacing:-0.02em;line-height:1}
.ilp-tp__n--zero{color:var(--text-disabled)}
.ilp-tp__n--crit{color:var(--il-red-ink)}

/* ---------- stepper ---------- */
.ilp-tp__step{display:flex;align-items:center;gap:0;width:100%;border:1px solid var(--border-default);border-radius:var(--radius-md);overflow:hidden;background:var(--surface-card)}
.ilp-tp__step button{width:56px;height:56px;flex:none;display:grid;place-items:center;padding:0;font:inherit;color:var(--text-primary);background:var(--il-grayblue-50);border:0;cursor:pointer}
.ilp-tp__step button:active{background:var(--il-grayblue-100)}
.ilp-tp__step button svg{width:22px;height:22px}
.ilp-tp__step input{flex:1;min-width:0;height:56px;padding:0 8px;font:inherit;font-size:20px;font-weight:var(--weight-bold);text-align:center;font-variant-numeric:tabular-nums;color:var(--text-primary);background:transparent;border:0;border-left:1px solid var(--border-default);border-right:1px solid var(--border-default);outline:none}
.ilp-tp__step input:focus{background:var(--il-blue-50)}

/* ---------- segmented verdict ---------- */
.ilp-tp__seg{display:grid;gap:8px;grid-auto-flow:column;grid-auto-columns:1fr}
.ilp-tp__sg{display:flex;flex-direction:column;align-items:center;justify-content:center;gap:5px;min-height:64px;padding:10px 8px;font:inherit;font-size:14px;font-weight:var(--weight-bold);color:var(--text-secondary);background:var(--surface-card);border:1.5px solid var(--border-default);border-radius:var(--radius-md);cursor:pointer;-webkit-tap-highlight-color:transparent}
.ilp-tp__sg svg{width:22px;height:22px}
.ilp-tp__sg:active{transform:scale(.98)}
.ilp-tp__sg--on{color:#fff;background:var(--brand-primary);border-color:var(--brand-primary)}
.ilp-tp__sg--on.ilp-tp__sg--pass{background:var(--il-earth-ink);border-color:var(--il-earth-ink)}
.ilp-tp__sg--on.ilp-tp__sg--fail{background:var(--status-danger);border-color:var(--status-danger)}
.ilp-tp__sg--on.ilp-tp__sg--hold{background:var(--il-sun-ink);border-color:var(--il-sun-ink)}

/* ---------- sync status ---------- */
.ilp-tp__sync{display:flex;align-items:center;gap:9px;padding:9px 14px;font-size:13px;font-weight:var(--weight-semibold);background:var(--il-earth-soft);color:var(--il-earth-ink)}
.ilp-tp__sync svg{width:17px;height:17px;flex:none}
.ilp-tp__sync--offline{background:var(--il-grayblue-700);color:#fff}
.ilp-tp__sync--syncing{background:var(--il-blue-100);color:var(--il-blue-800)}
.ilp-tp__sync--error{background:var(--il-red-soft);color:var(--il-red-ink)}
.ilp-tp__sync b{margin-left:auto;font-weight:var(--weight-bold);font-variant-numeric:tabular-nums}
.ilp-tp__spin{animation:ilp-tp-spin 1.1s linear infinite}
@keyframes ilp-tp-spin{to{transform:rotate(360deg)}}

/* ---------- capture slot ---------- */
.ilp-tp__caps{display:grid;grid-template-columns:repeat(auto-fill,minmax(96px,1fr));gap:10px}
.ilp-tp__cap{position:relative;aspect-ratio:1;display:flex;flex-direction:column;align-items:center;justify-content:center;gap:6px;padding:8px;font:inherit;font-size:12px;font-weight:var(--weight-bold);color:var(--text-secondary);background:var(--il-grayblue-50);border:1.5px dashed var(--border-strong);border-radius:var(--radius-md);cursor:pointer;overflow:hidden}
.ilp-tp__cap svg{width:26px;height:26px;color:var(--text-muted)}
.ilp-tp__cap:active{background:var(--il-grayblue-100)}
.ilp-tp__cap--filled{border-style:solid;border-color:var(--border-default);background:var(--il-grayblue-200);padding:0}
.ilp-tp__cap img{width:100%;height:100%;object-fit:cover}
.ilp-tp__cap u{position:absolute;top:5px;right:5px;display:grid;place-items:center;width:22px;height:22px;background:rgba(24,29,37,.6);color:#fff;border-radius:50%;text-decoration:none}
.ilp-tp__cap u svg{width:13px;height:13px;color:#fff}
`;

function useCSS() {
  React.useEffect(() => {
    if (document.getElementById('ilp-tp-css')) return;
    const s = document.createElement('style');
    s.id = 'ilp-tp-css';
    s.textContent = CSS;
    document.head.appendChild(s);
  }, []);
}

const I = (d, w = 2.4) => (p) => (
  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={w} strokeLinecap="round" strokeLinejoin="round" aria-hidden="true" {...p}>
    {d.map((x, i) => <path key={i} d={x} />)}
  </svg>
);
const IcPlus = I(['M12 5v14', 'M5 12h14']);
const IcMinus = I(['M5 12h14']);
const IcCheck = I(['m4 12.5 5 5L20 6.5']);
const IcX = I(['M6 6l12 12', 'M18 6 6 18']);
const IcPause = I(['M9 5v14', 'M15 5v14']);
const IcCloudOff = I(['M3 3l18 18', 'M7 18a4 4 0 0 1-.6-7.96', 'M9.5 6.2A5.5 5.5 0 0 1 18 10a3.9 3.9 0 0 1 2.9 6.3', 'M11 18h6'], 2);
const IcCloud = I(['M7 18a4 4 0 0 1 .6-7.96A5.5 5.5 0 0 1 18 10a4 4 0 0 1 0 8H7Z'], 2);
const IcSync = I(['M20 11a8 8 0 1 0-1.6 5.6', 'M20 5v6h-6'], 2);
const IcAlert = I(['M12 4.5 2.5 20h19L12 4.5Z', 'M12 10v4.5', 'M12 17.6v.1'], 2);
const IcCamera = I(['M4 8h3l1.6-2.5h6.8L17 8h3v11H4z', 'M12 16.2a3.6 3.6 0 1 0 0-7.2 3.6 3.6 0 0 0 0 7.2Z'], 2);

/**
 * Defect tally pad. The primary data-entry control on the floor: one tile per
 * defect code, 52px +/− targets, count in the middle.
 */
export function TallyPad({ items = [], values = {}, onChange, criticalAt, className = '', ...rest }) {
  useCSS();
  const bump = (key, by) => {
    const next = Math.max(0, (values[key] ?? 0) + by);
    onChange && onChange(key, next, { ...values, [key]: next });
  };
  return (
    <div className={'ilp-tp ilp-tp__grid' + (className ? ' ' + className : '')} {...rest}>
      {items.map((it) => {
        const n = values[it.key] ?? 0;
        const crit = criticalAt != null && n >= criticalAt;
        return (
          <div key={it.key} className={'ilp-tp__cell' + (n > 0 ? ' ilp-tp__cell--on' : '') + (crit ? ' ilp-tp__cell--crit' : '')}>
            <div className="ilp-tp__lbl">{it.label}{it.severity && <em>{it.severity}</em>}</div>
            <div className="ilp-tp__ctl">
              <button type="button" className="ilp-tp__btn" aria-label={`Decrease ${it.label}`} disabled={n === 0} onClick={() => bump(it.key, -1)}><IcMinus /></button>
              <span className={'ilp-tp__n' + (n === 0 ? ' ilp-tp__n--zero' : '') + (crit ? ' ilp-tp__n--crit' : '')} aria-live="polite">{n}</span>
              <button type="button" className="ilp-tp__btn ilp-tp__btn--plus" aria-label={`Increase ${it.label}`} onClick={() => bump(it.key, 1)}><IcPlus /></button>
            </div>
          </div>
        );
      })}
    </div>
  );
}

/** Numeric stepper with 56px targets — quantities, sample sizes. */
export function MobileStepper({ value = 0, min = 0, max, step = 1, onChange, label, className = '', ...rest }) {
  useCSS();
  const set = (v) => onChange && onChange(Math.max(min, max != null ? Math.min(max, v) : v));
  return (
    <div className={'ilp-tp ilp-tp__step' + (className ? ' ' + className : '')} {...rest}>
      <button type="button" aria-label={`Decrease ${label || 'value'}`} onClick={() => set(value - step)}><IcMinus /></button>
      <input
        type="number" inputMode="numeric" value={value} aria-label={label}
        onChange={(e) => set(Number(e.target.value) || 0)}
      />
      <button type="button" aria-label={`Increase ${label || 'value'}`} onClick={() => set(value + step)}><IcPlus /></button>
    </div>
  );
}

const VERDICT_ICON = { pass: IcCheck, fail: IcX, hold: IcPause };

/** Big segmented control for a verdict. Two or three options, never more. */
export function MobileSegmented({ options = [], value, onChange, className = '', ...rest }) {
  useCSS();
  return (
    <div className={'ilp-tp ilp-tp__seg' + (className ? ' ' + className : '')} role="radiogroup" {...rest}>
      {options.map((o) => {
        const key = typeof o === 'object' ? o.value : o;
        const label = typeof o === 'object' ? o.label : o;
        const kind = typeof o === 'object' ? o.kind : undefined;
        const Icon = kind && VERDICT_ICON[kind];
        return (
          <button
            key={key} type="button" role="radio" aria-checked={value === key}
            className={'ilp-tp__sg' + (value === key ? ' ilp-tp__sg--on' : '') + (kind ? ' ilp-tp__sg--' + kind : '')}
            onClick={() => onChange && onChange(key)}
          >
            {Icon && <Icon />}{label}
          </button>
        );
      })}
    </div>
  );
}

const SYNC = {
  synced: { icon: IcCloud, text: 'All work synced' },
  syncing: { icon: IcSync, text: 'Syncing…' },
  offline: { icon: IcCloudOff, text: 'Working offline' },
  error: { icon: IcAlert, text: 'Sync failed' },
};

/**
 * Persistent sync state. On an offline-first app this is never hidden — the
 * operator must always know whether their work has left the device.
 */
export function SyncStatus({ state = 'synced', pending = 0, message, className = '', ...rest }) {
  useCSS();
  const def = SYNC[state] || SYNC.synced;
  const Icon = def.icon;
  return (
    <div className={'ilp-tp ilp-tp__sync ilp-tp__sync--' + state + (className ? ' ' + className : '')} role="status" {...rest}>
      <Icon className={state === 'syncing' ? 'ilp-tp__spin' : undefined} />
      {message || def.text}
      {pending > 0 && <b>{pending} queued</b>}
    </div>
  );
}

/** Photo evidence slots. Tap to capture; filled slots show a remove control. */
export function PhotoCapture({ photos = [], slots = 4, onCapture, onRemove, label = 'Add photo', className = '', ...rest }) {
  useCSS();
  const empty = Math.max(0, slots - photos.length);
  return (
    <div className={'ilp-tp ilp-tp__caps' + (className ? ' ' + className : '')} {...rest}>
      {photos.map((p, i) => (
        <div key={p.id ?? i} className="ilp-tp__cap ilp-tp__cap--filled">
          {p.src ? <img src={p.src} alt={p.name || ''} /> : <IcCamera />}
          {onRemove && (
            <u role="button" tabIndex={0} aria-label="Remove photo" onClick={() => onRemove(p, i)}><IcX /></u>
          )}
        </div>
      ))}
      {Array.from({ length: empty }, (_, i) => (
        <button key={'e' + i} type="button" className="ilp-tp__cap" onClick={onCapture}>
          <IcCamera />{i === 0 ? label : ''}
        </button>
      ))}
    </div>
  );
}
