import React from 'react';

const CSS = `
.ilp-progress { display: flex; flex-direction: column; gap: 6px; font-family: var(--font-sans); }
.ilp-progress__head { display: flex; justify-content: space-between; align-items: baseline; }
.ilp-progress__label { font-size: var(--fs-sm); font-weight: var(--weight-semibold); color: var(--text-primary); }
.ilp-progress__value { font-size: var(--fs-sm); font-weight: var(--weight-bold); color: var(--text-secondary); font-variant-numeric: tabular-nums; }
.ilp-progress__track { width: 100%; background: var(--il-grayblue-100); border-radius: var(--radius-pill); overflow: hidden; }
.ilp-progress__track--sm { height: 6px; }
.ilp-progress__track--md { height: 9px; }
.ilp-progress__track--lg { height: 14px; }
.ilp-progress__fill { height: 100%; border-radius: var(--radius-pill);
  transition: width var(--dur-slow) var(--ease-out); }
.ilp-progress__fill--blue  { background: var(--il-blue-500); }
.ilp-progress__fill--earth { background: var(--il-earth); }
.ilp-progress__fill--air   { background: var(--il-air); }
.ilp-progress__fill--sun   { background: var(--il-sun); }
.ilp-progress__fill--danger{ background: var(--il-red); }
`;

const FILL_TONE = { blue: 'blue', earth: 'earth', air: 'air', sun: 'sun', danger: 'danger' };

function useCSS() {
  React.useEffect(() => {
    if (document.getElementById('ilp-progress-css')) return;
    const s = document.createElement('style');
    s.id = 'ilp-progress-css'; s.textContent = CSS; document.head.appendChild(s);
  }, []);
}

/** Horizontal progress / completion bar with optional label and value. */
export function ProgressBar({
  value = 0,
  max = 100,
  label,
  showValue = false,
  size = 'md',        // 'sm' | 'md' | 'lg'
  tone = 'blue',      // 'blue' | 'earth' | 'air' | 'sun' | 'danger'
  className = '',
  ...rest
}) {
  useCSS();
  const pct = Math.max(0, Math.min(100, (value / max) * 100));
  return (
    <div className={['ilp-progress', className].filter(Boolean).join(' ')} {...rest}>
      {(label || showValue) && (
        <div className="ilp-progress__head">
          {label && <span className="ilp-progress__label">{label}</span>}
          {showValue && <span className="ilp-progress__value">{Math.round(pct)}%</span>}
        </div>
      )}
      <div className={`ilp-progress__track ilp-progress__track--${size}`}
           role="progressbar" aria-valuenow={value} aria-valuemin={0} aria-valuemax={max}>
        <div className={`ilp-progress__fill ilp-progress__fill--${FILL_TONE[tone] || 'blue'}`} style={{ width: `${pct}%` }} />
      </div>
    </div>
  );
}
