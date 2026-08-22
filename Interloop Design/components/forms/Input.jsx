import React from 'react';

const CSS = `
.ilp-field { display: flex; flex-direction: column; gap: 6px; font-family: var(--font-sans); }
.ilp-field__label { font-size: var(--fs-sm); font-weight: var(--weight-semibold); color: var(--text-primary); }
.ilp-field__label .req { color: var(--status-danger); margin-left: 2px; }
.ilp-field__hint { font-size: var(--fs-xs); color: var(--text-muted); }
.ilp-field__hint--error { color: var(--status-danger-ink); }

.ilp-input-wrap { position: relative; display: flex; align-items: center; }
.ilp-input {
  width: 100%; height: 40px; padding: 0 12px;
  font-family: var(--font-sans); font-size: var(--fs-base); color: var(--text-primary);
  background: var(--surface-card); border: 1px solid var(--border-default);
  border-radius: var(--radius-md); transition: border-color var(--dur-fast) var(--ease-standard), box-shadow var(--dur-fast) var(--ease-standard);
}
.ilp-input::placeholder { color: var(--text-muted); }
.ilp-input:hover:not(:disabled) { border-color: var(--border-strong); }
.ilp-input:focus { outline: none; border-color: var(--border-focus); box-shadow: var(--ring); }
.ilp-input:disabled { background: var(--surface-sunken); color: var(--text-disabled); cursor: not-allowed; }
.ilp-input--error { border-color: var(--status-danger); }
.ilp-input--error:focus { box-shadow: 0 0 0 3px var(--status-danger-soft); }
.ilp-input--with-lead { padding-left: 38px; }
.ilp-input--with-trail { padding-right: 38px; }
.ilp-input__icon { position: absolute; color: var(--text-muted); display: flex; pointer-events: none; }
.ilp-input__icon svg, .ilp-input__icon i { width: 17px; height: 17px; }
.ilp-input__icon--lead { left: 12px; }
.ilp-input__icon--trail { right: 12px; }
`;

function useCSS() {
  React.useEffect(() => {
    if (document.getElementById('ilp-input-css')) return;
    const s = document.createElement('style');
    s.id = 'ilp-input-css'; s.textContent = CSS; document.head.appendChild(s);
  }, []);
}

/** Text input with label, hint/error states and optional inline icons. */
export function Input({
  label,
  hint,
  error,
  required = false,
  leadingIcon = null,
  trailingIcon = null,
  id,
  className = '',
  ...rest
}) {
  useCSS();
  const autoId = React.useId();
  const fieldId = id || autoId;
  const inputCls = [
    'ilp-input',
    error ? 'ilp-input--error' : '',
    leadingIcon ? 'ilp-input--with-lead' : '',
    trailingIcon ? 'ilp-input--with-trail' : '',
  ].filter(Boolean).join(' ');
  return (
    <div className={['ilp-field', className].filter(Boolean).join(' ')}>
      {label && (
        <label className="ilp-field__label" htmlFor={fieldId}>
          {label}{required && <span className="req">*</span>}
        </label>
      )}
      <div className="ilp-input-wrap">
        {leadingIcon && <span className="ilp-input__icon ilp-input__icon--lead">{leadingIcon}</span>}
        <input id={fieldId} className={inputCls} aria-invalid={!!error} {...rest} />
        {trailingIcon && <span className="ilp-input__icon ilp-input__icon--trail">{trailingIcon}</span>}
      </div>
      {(error || hint) && (
        <span className={['ilp-field__hint', error ? 'ilp-field__hint--error' : ''].filter(Boolean).join(' ')}>
          {error || hint}
        </span>
      )}
    </div>
  );
}
