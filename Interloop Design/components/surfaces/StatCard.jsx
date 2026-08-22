import React from 'react';

const CSS = `
.ilp-stat { background: var(--surface-card); border: 1px solid var(--border-subtle);
  border-radius: var(--radius-lg); box-shadow: var(--shadow-sm); padding: 18px 20px;
  display: flex; flex-direction: column; gap: 12px; }
.ilp-stat__top { display: flex; align-items: flex-start; gap: 12px; }
.ilp-stat__label { font-size: var(--fs-sm); font-weight: var(--weight-semibold); color: var(--text-muted); letter-spacing: 0.01em; }
.ilp-stat__icon { margin-left: auto; flex: none; width: 40px; height: 40px; border-radius: var(--radius-md);
  display: inline-flex; align-items: center; justify-content: center; color: #fff; }
.ilp-stat__icon svg, .ilp-stat__icon i { width: 20px; height: 20px; }
.ilp-stat__value { font-family: var(--font-sans); font-weight: var(--weight-black);
  font-size: var(--fs-4xl); line-height: 1; color: var(--text-primary); letter-spacing: -0.02em; }
.ilp-stat__foot { display: flex; align-items: center; gap: 8px; font-size: var(--fs-sm); }
.ilp-stat__delta { display: inline-flex; align-items: center; gap: 3px; font-weight: var(--weight-bold); }
.ilp-stat__delta svg { width: 14px; height: 14px; }
.ilp-stat__delta--up { color: var(--status-success-ink); }
.ilp-stat__delta--down { color: var(--status-danger-ink); }
.ilp-stat__note { color: var(--text-muted); }
`;

const ICON_TONES = {
  blue:  'var(--il-blue-500)',
  earth: 'var(--il-earth)',
  air:   'var(--il-air)',
  sun:   'var(--il-sun)',
  ink:   'var(--il-grayblue-600)',
};

function useCSS() {
  React.useEffect(() => {
    if (document.getElementById('ilp-stat-css')) return;
    const s = document.createElement('style');
    s.id = 'ilp-stat-css'; s.textContent = CSS; document.head.appendChild(s);
  }, []);
}

const ArrowUp = <svg viewBox="0 0 16 16" fill="none"><path d="M8 13V3M8 3l-4 4M8 3l4 4" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/></svg>;
const ArrowDown = <svg viewBox="0 0 16 16" fill="none"><path d="M8 3v10M8 13l-4-4M8 13l4-4" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/></svg>;

/** KPI tile — label, big value, trend delta and an accent icon. */
export function StatCard({
  label,
  value,
  delta,              // e.g. "+$1,210.50"
  trend = 'up',       // 'up' | 'down'
  note,               // muted text after the delta
  icon,               // React node (Lucide icon)
  iconTone = 'blue',  // 'blue' | 'earth' | 'air' | 'sun' | 'ink'
  className = '',
  ...rest
}) {
  useCSS();
  return (
    <div className={['ilp-stat', className].filter(Boolean).join(' ')} {...rest}>
      <div className="ilp-stat__top">
        <span className="ilp-stat__label">{label}</span>
        {icon && <span className="ilp-stat__icon" style={{ background: ICON_TONES[iconTone] || ICON_TONES.blue }}>{icon}</span>}
      </div>
      <div className="ilp-stat__value">{value}</div>
      {(delta || note) && (
        <div className="ilp-stat__foot">
          {delta && (
            <span className={`ilp-stat__delta ilp-stat__delta--${trend}`}>
              {trend === 'up' ? ArrowUp : ArrowDown}{delta}
            </span>
          )}
          {note && <span className="ilp-stat__note">{note}</span>}
        </div>
      )}
    </div>
  );
}
