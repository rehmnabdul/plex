import React from 'react';

const CSS = `
.ilp-badge {
  display: inline-flex; align-items: center; gap: 5px;
  font-family: var(--font-sans); font-weight: var(--weight-bold);
  font-size: var(--fs-xs); line-height: 1; white-space: nowrap;
  padding: 4px 9px; border-radius: var(--radius-pill); border: 1px solid transparent;
}
.ilp-badge--dot::before { content: ""; width: 6px; height: 6px; border-radius: 50%; background: currentColor; }
.ilp-badge--square { border-radius: var(--radius-sm); }

.ilp-badge--neutral { background: var(--il-grayblue-100); color: var(--il-grayblue-600); }
.ilp-badge--info    { background: var(--status-info-soft); color: var(--status-info-ink); }
.ilp-badge--success { background: var(--status-success-soft); color: var(--status-success-ink); }
.ilp-badge--warning { background: var(--status-warning-soft); color: var(--status-warning-ink); }
.ilp-badge--danger  { background: var(--status-danger-soft); color: var(--status-danger-ink); }

.ilp-badge--solid.ilp-badge--info    { background: var(--status-info); color: #fff; }
.ilp-badge--solid.ilp-badge--success { background: var(--status-success); color: var(--il-grayblue-800); }
.ilp-badge--solid.ilp-badge--warning { background: var(--status-warning); color: var(--il-grayblue-800); }
.ilp-badge--solid.ilp-badge--danger  { background: var(--status-danger); color: #fff; }
.ilp-badge--solid.ilp-badge--neutral { background: var(--il-grayblue-600); color: #fff; }

.ilp-badge--outline { background: transparent; }
.ilp-badge--outline.ilp-badge--neutral { border-color: var(--border-default); color: var(--text-secondary); }
.ilp-badge--outline.ilp-badge--info    { border-color: var(--il-blue-300); color: var(--status-info-ink); }
.ilp-badge--outline.ilp-badge--success { border-color: var(--il-earth); color: var(--status-success-ink); }
.ilp-badge--outline.ilp-badge--warning { border-color: var(--il-sun); color: var(--status-warning-ink); }
.ilp-badge--outline.ilp-badge--danger  { border-color: var(--il-red); color: var(--status-danger-ink); }
`;

function useCSS() {
  React.useEffect(() => {
    if (document.getElementById('ilp-badge-css')) return;
    const s = document.createElement('style');
    s.id = 'ilp-badge-css'; s.textContent = CSS; document.head.appendChild(s);
  }, []);
}

/** Compact status / category label. */
export function Badge({
  variant,
  color: colorProp = 'neutral',   // 'neutral' | 'info' | 'success' | 'warning' | 'danger'
  appearance = 'soft', // 'soft' | 'solid' | 'outline'
  dot = false,
  square = false,
  className = '',
  children,
  ...rest
}) {
  useCSS();
  const color = variant || colorProp;
  const cls = [
    'ilp-badge', `ilp-badge--${color}`,
    appearance === 'solid' ? 'ilp-badge--solid' : '',
    appearance === 'outline' ? 'ilp-badge--outline' : '',
    dot ? 'ilp-badge--dot' : '', square ? 'ilp-badge--square' : '', className,
  ].filter(Boolean).join(' ');
  return <span className={cls} {...rest}>{children}</span>;
}
