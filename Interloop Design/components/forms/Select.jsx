import React from 'react';

const CSS = `
.ilp-select-field { display: flex; flex-direction: column; gap: 6px; font-family: var(--font-sans); }
.ilp-select-field__label { font-size: var(--fs-sm); font-weight: var(--weight-semibold); color: var(--text-primary); }
.ilp-select-wrap { position: relative; display: flex; align-items: center; }
.ilp-select {
  width: 100%; height: 40px; padding: 0 38px 0 12px;
  font-family: var(--font-sans); font-size: var(--fs-base); color: var(--text-primary);
  background: var(--surface-card); border: 1px solid var(--border-default); border-radius: var(--radius-md);
  appearance: none; -webkit-appearance: none; cursor: pointer;
  transition: border-color var(--dur-fast) var(--ease-standard), box-shadow var(--dur-fast) var(--ease-standard);
}
.ilp-select:hover:not(:disabled) { border-color: var(--border-strong); }
.ilp-select:focus { outline: none; border-color: var(--border-focus); box-shadow: var(--ring); }
.ilp-select:disabled { background: var(--surface-sunken); color: var(--text-disabled); cursor: not-allowed; }
.ilp-select__chev { position: absolute; right: 12px; pointer-events: none; color: var(--text-muted);
  width: 0; height: 0; border-left: 5px solid transparent; border-right: 5px solid transparent; border-top: 6px solid currentColor; }
`;

function useCSS() {
  React.useEffect(() => {
    if (document.getElementById('ilp-select-css')) return;
    const s = document.createElement('style');
    s.id = 'ilp-select-css'; s.textContent = CSS; document.head.appendChild(s);
  }, []);
}

/** Styled native select with brand chevron. */
export function Select({
  label,
  options = [],       // [{value, label}] or string[]
  placeholder,
  id,
  className = '',
  children,
  ...rest
}) {
  useCSS();
  const autoId = React.useId();
  const fieldId = id || autoId;
  const opts = options.map((o) => (typeof o === 'string' ? { value: o, label: o } : o));
  return (
    <div className={['ilp-select-field', className].filter(Boolean).join(' ')}>
      {label && <label className="ilp-select-field__label" htmlFor={fieldId}>{label}</label>}
      <div className="ilp-select-wrap">
        <select id={fieldId} className="ilp-select" {...rest}>
          {placeholder && <option value="" disabled>{placeholder}</option>}
          {children || opts.map((o) => <option key={o.value} value={o.value}>{o.label}</option>)}
        </select>
        <span className="ilp-select__chev" />
      </div>
    </div>
  );
}
