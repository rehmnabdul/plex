import React from 'react';

const CSS = `
.ilp-switch { display: inline-flex; align-items: center; gap: 10px; font-family: var(--font-sans);
  font-size: var(--fs-base); color: var(--text-primary); cursor: pointer; user-select: none; }
.ilp-switch input { position: absolute; opacity: 0; width: 0; height: 0; }
.ilp-switch__track { flex: none; position: relative; background: var(--il-grayblue-300);
  border-radius: var(--radius-pill); transition: background var(--dur-normal) var(--ease-standard); }
.ilp-switch__thumb { position: absolute; top: 50%; transform: translateY(-50%); left: 2px;
  background: #fff; border-radius: 50%; box-shadow: var(--shadow-sm); transition: left var(--dur-normal) var(--ease-standard); }
.ilp-switch--md .ilp-switch__track { width: 40px; height: 22px; }
.ilp-switch--md .ilp-switch__thumb { width: 18px; height: 18px; }
.ilp-switch--md input:checked + .ilp-switch__track .ilp-switch__thumb { left: 20px; }
.ilp-switch--sm .ilp-switch__track { width: 32px; height: 18px; }
.ilp-switch--sm .ilp-switch__thumb { width: 14px; height: 14px; }
.ilp-switch--sm input:checked + .ilp-switch__track .ilp-switch__thumb { left: 16px; }
.ilp-switch input:checked + .ilp-switch__track { background: var(--brand-primary); }
.ilp-switch input:focus-visible + .ilp-switch__track { box-shadow: var(--ring); }
.ilp-switch--disabled { opacity: .5; cursor: not-allowed; }
`;

function useCSS() {
  React.useEffect(() => {
    if (document.getElementById('ilp-switch-css')) return;
    const s = document.createElement('style');
    s.id = 'ilp-switch-css'; s.textContent = CSS; document.head.appendChild(s);
  }, []);
}

/** Toggle switch for instant on/off settings. */
export function Switch({
  label,
  size = 'md',         // 'sm' | 'md'
  className = '',
  disabled,
  ...rest
}) {
  useCSS();
  return (
    <label className={['ilp-switch', `ilp-switch--${size}`, disabled ? 'ilp-switch--disabled' : '', className].filter(Boolean).join(' ')}>
      <input type="checkbox" disabled={disabled} {...rest} />
      <span className="ilp-switch__track"><span className="ilp-switch__thumb" /></span>
      {label && <span>{label}</span>}
    </label>
  );
}
