import React from 'react';

const CSS = `
.ilp-alert { display: flex; gap: 12px; padding: 14px 16px; border-radius: var(--radius-md);
  border: 1px solid transparent; font-family: var(--font-sans); align-items: flex-start; }
.ilp-alert__icon { flex: none; display: flex; margin-top: 1px; }
.ilp-alert__icon svg, .ilp-alert__icon i { width: 18px; height: 18px; }
.ilp-alert__body { min-width: 0; flex: 1; }
.ilp-alert__title { font-weight: var(--weight-bold); font-size: var(--fs-base); margin-bottom: 2px; }
.ilp-alert__msg { font-size: var(--fs-sm); line-height: var(--lh-normal); }
.ilp-alert__close { flex: none; background: none; border: 0; cursor: pointer; color: inherit; opacity: .55;
  display: flex; padding: 2px; border-radius: var(--radius-xs); transition: opacity var(--dur-fast); }
.ilp-alert__close:hover { opacity: 1; }
.ilp-alert__close svg { width: 16px; height: 16px; }

.ilp-alert--info    { background: var(--status-info-soft); border-color: var(--il-blue-200); color: var(--status-info-ink); }
.ilp-alert--success { background: var(--status-success-soft); border-color: var(--il-earth-flat); color: var(--status-success-ink); }
.ilp-alert--warning { background: var(--status-warning-soft); border-color: var(--il-sun-flat); color: var(--status-warning-ink); }
.ilp-alert--danger  { background: var(--status-danger-soft); border-color: #f4b7b1; color: var(--status-danger-ink); }
.ilp-alert__icon { color: currentColor; }
`;

const ICONS = {
  info:    <svg viewBox="0 0 20 20" fill="none"><circle cx="10" cy="10" r="8.25" stroke="currentColor" strokeWidth="2"/><path d="M10 9v4.5M10 6.4h.01" stroke="currentColor" strokeWidth="2" strokeLinecap="round"/></svg>,
  success: <svg viewBox="0 0 20 20" fill="none"><circle cx="10" cy="10" r="8.25" stroke="currentColor" strokeWidth="2"/><path d="M6.4 10.2l2.3 2.3 4.6-5" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/></svg>,
  warning: <svg viewBox="0 0 20 20" fill="none"><path d="M10 2.6l8 14.2H2L10 2.6Z" stroke="currentColor" strokeWidth="2" strokeLinejoin="round"/><path d="M10 8v3.4M10 14.2h.01" stroke="currentColor" strokeWidth="2" strokeLinecap="round"/></svg>,
  danger:  <svg viewBox="0 0 20 20" fill="none"><circle cx="10" cy="10" r="8.25" stroke="currentColor" strokeWidth="2"/><path d="M7.5 7.5l5 5M12.5 7.5l-5 5" stroke="currentColor" strokeWidth="2" strokeLinecap="round"/></svg>,
};
const Close = <svg viewBox="0 0 16 16" fill="none"><path d="M4 4l8 8M12 4l-8 8" stroke="currentColor" strokeWidth="2" strokeLinecap="round"/></svg>;

function useCSS() {
  React.useEffect(() => {
    if (document.getElementById('ilp-alert-css')) return;
    const s = document.createElement('style');
    s.id = 'ilp-alert-css'; s.textContent = CSS; document.head.appendChild(s);
  }, []);
}

/** Inline contextual message banner. */
export function Alert({
  variant = 'info',   // 'info' | 'success' | 'warning' | 'danger'
  title,
  onClose,
  className = '',
  children,
  ...rest
}) {
  useCSS();
  return (
    <div role="alert" className={['ilp-alert', `ilp-alert--${variant}`, className].filter(Boolean).join(' ')} {...rest}>
      <span className="ilp-alert__icon">{ICONS[variant]}</span>
      <div className="ilp-alert__body">
        {title && <div className="ilp-alert__title">{title}</div>}
        {children && <div className="ilp-alert__msg">{children}</div>}
      </div>
      {onClose && <button type="button" className="ilp-alert__close" aria-label="Dismiss" onClick={onClose}>{Close}</button>}
    </div>
  );
}
