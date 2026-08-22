import React from 'react';

const CSS = `
.ilp-check { display: inline-flex; align-items: flex-start; gap: 10px; font-family: var(--font-sans);
  font-size: var(--fs-base); color: var(--text-primary); cursor: pointer; user-select: none; line-height: 1.4; }
.ilp-check input { position: absolute; opacity: 0; width: 0; height: 0; }
.ilp-check__box { flex: none; width: 19px; height: 19px; margin-top: 1px; display: inline-flex; align-items: center; justify-content: center;
  border: 1.5px solid var(--border-strong); background: var(--surface-card);
  border-radius: var(--radius-xs); color: #fff; transition: all var(--dur-fast) var(--ease-standard); }
.ilp-check__box--radio { border-radius: 50%; }
.ilp-check__box svg { width: 13px; height: 13px; opacity: 0; transform: scale(.6); transition: all var(--dur-fast) var(--ease-standard); }
.ilp-check__box .dot { width: 8px; height: 8px; border-radius: 50%; background: #fff; opacity: 0; transform: scale(.4); transition: all var(--dur-fast) var(--ease-standard); }
.ilp-check input:checked + .ilp-check__box { background: var(--brand-primary); border-color: var(--brand-primary); }
.ilp-check input:checked + .ilp-check__box svg,
.ilp-check input:checked + .ilp-check__box .dot { opacity: 1; transform: scale(1); }
.ilp-check input:focus-visible + .ilp-check__box { box-shadow: var(--ring); }
.ilp-check:hover input:not(:disabled) + .ilp-check__box { border-color: var(--brand-primary); }
.ilp-check input:disabled + .ilp-check__box { background: var(--surface-sunken); border-color: var(--border-default); }
.ilp-check--disabled { color: var(--text-disabled); cursor: not-allowed; }
.ilp-check__text small { display: block; font-size: var(--fs-xs); color: var(--text-muted); font-weight: var(--weight-regular); }
`;

function useCSS() {
  React.useEffect(() => {
    if (document.getElementById('ilp-check-css')) return;
    const s = document.createElement('style');
    s.id = 'ilp-check-css'; s.textContent = CSS; document.head.appendChild(s);
  }, []);
}

const Tick = (
  <svg viewBox="0 0 16 16" fill="none"><path d="M3.5 8.5l3 3 6-7" stroke="currentColor" strokeWidth="2.4" strokeLinecap="round" strokeLinejoin="round"/></svg>
);

/** Checkbox or radio with label and optional description. */
export function Checkbox({
  label,
  description,
  radio = false,
  indeterminate = false,
  className = '',
  disabled,
  ...rest
}) {
  useCSS();
  const ref = React.useRef(null);
  React.useEffect(() => { if (ref.current) ref.current.indeterminate = indeterminate && !radio; }, [indeterminate, radio]);
  return (
    <label className={['ilp-check', disabled ? 'ilp-check--disabled' : '', className].filter(Boolean).join(' ')}>
      <input ref={ref} type={radio ? 'radio' : 'checkbox'} disabled={disabled} {...rest} />
      <span className={['ilp-check__box', radio ? 'ilp-check__box--radio' : ''].filter(Boolean).join(' ')}>
        {radio ? <span className="dot" /> : Tick}
      </span>
      {(label || description) && (
        <span className="ilp-check__text">{label}{description && <small>{description}</small>}</span>
      )}
    </label>
  );
}
