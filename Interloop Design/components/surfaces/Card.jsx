import React from 'react';

const CSS = `
.ilp-card { background: var(--surface-card); border: 1px solid var(--border-subtle);
  border-radius: var(--radius-lg); box-shadow: var(--shadow-sm); overflow: hidden; }
.ilp-card--flat { box-shadow: none; }
.ilp-card--raised { box-shadow: var(--shadow-md); }
.ilp-card--hover { transition: box-shadow var(--dur-normal) var(--ease-standard), transform var(--dur-normal) var(--ease-standard); }
.ilp-card--hover:hover { box-shadow: var(--shadow-lg); transform: translateY(-2px); }
.ilp-card__header { display: flex; align-items: center; gap: 12px; padding: 16px 20px; border-bottom: 1px solid var(--border-subtle); }
.ilp-card__titles { display: flex; flex-direction: column; gap: 2px; min-width: 0; }
.ilp-card__title { font-family: var(--font-sans); font-weight: var(--weight-bold); font-size: var(--fs-lg); color: var(--text-primary); }
.ilp-card__subtitle { font-size: var(--fs-sm); color: var(--text-muted); }
.ilp-card__actions { margin-left: auto; display: flex; align-items: center; gap: 8px; }
.ilp-card__body { padding: 20px; }
.ilp-card__body--flush { padding: 0; }
.ilp-card__footer { padding: 14px 20px; border-top: 1px solid var(--border-subtle); background: var(--il-grayblue-50); }
`;

function useCSS() {
  React.useEffect(() => {
    if (document.getElementById('ilp-card-css')) return;
    const s = document.createElement('style');
    s.id = 'ilp-card-css'; s.textContent = CSS; document.head.appendChild(s);
  }, []);
}

/** Surface container with optional header (title/subtitle/actions), body and footer. */
export function Card({
  title,
  subtitle,
  actions,
  footer,
  elevation = 'sm',   // 'flat' | 'sm' | 'raised'
  hover = false,
  flush = false,
  className = '',
  children,
  ...rest
}) {
  useCSS();
  const cls = [
    'ilp-card',
    elevation === 'flat' ? 'ilp-card--flat' : '',
    elevation === 'raised' ? 'ilp-card--raised' : '',
    hover ? 'ilp-card--hover' : '',
    className,
  ].filter(Boolean).join(' ');
  return (
    <div className={cls} {...rest}>
      {(title || actions) && (
        <div className="ilp-card__header">
          <div className="ilp-card__titles">
            {title && <span className="ilp-card__title">{title}</span>}
            {subtitle && <span className="ilp-card__subtitle">{subtitle}</span>}
          </div>
          {actions && <div className="ilp-card__actions">{actions}</div>}
        </div>
      )}
      <div className={['ilp-card__body', flush ? 'ilp-card__body--flush' : ''].filter(Boolean).join(' ')}>{children}</div>
      {footer && <div className="ilp-card__footer">{footer}</div>}
    </div>
  );
}
