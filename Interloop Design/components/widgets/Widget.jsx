import React from 'react';

const CSS = `
.ilp-wg{display:flex;flex-direction:column;min-width:0;background:var(--surface-card);border:1px solid var(--border-subtle);border-radius:var(--radius-lg);box-shadow:var(--shadow-sm);font-family:var(--font-sans);color:var(--text-primary);overflow:hidden}
.ilp-wg *{box-sizing:border-box}
.ilp-wg--flat{box-shadow:none}
.ilp-wg--brand{background:var(--il-grayblue-700);border-color:var(--il-grayblue-700);color:#fff}
.ilp-wg--brand .ilp-wg__sub,.ilp-wg--brand .ilp-wg__eyebrow{color:rgba(255,255,255,.6)}
.ilp-wg--brand .ilp-wg__hd{border-bottom-color:rgba(255,255,255,.12)}
.ilp-wg--accent{background:linear-gradient(150deg,var(--il-blue-600),var(--il-blue-800));border-color:transparent;color:#fff}
.ilp-wg--accent .ilp-wg__sub,.ilp-wg--accent .ilp-wg__eyebrow{color:rgba(255,255,255,.72)}
.ilp-wg--accent .ilp-wg__hd{border-bottom-color:rgba(255,255,255,.16)}

.ilp-wg__hd{display:flex;align-items:flex-start;gap:var(--space-3);padding:18px 20px 14px}
.ilp-wg__hd--rule{border-bottom:1px solid var(--border-subtle)}
.ilp-wg__t{min-width:0;margin-right:auto}
.ilp-wg__eyebrow{display:block;margin-bottom:4px;font-size:10px;font-weight:var(--weight-bold);letter-spacing:.08em;text-transform:uppercase;color:var(--text-muted)}
.ilp-wg__ttl{font-size:var(--fs-base);font-weight:var(--weight-bold);letter-spacing:-0.01em;line-height:1.25}
.ilp-wg__sub{margin-top:3px;font-size:var(--fs-xs);line-height:1.45;color:var(--text-muted)}
.ilp-wg__act{display:flex;align-items:center;gap:6px;flex:none}
.ilp-wg__menu{display:grid;place-items:center;width:28px;height:28px;padding:0;color:var(--text-muted);background:transparent;border:0;border-radius:var(--radius-sm);cursor:pointer}
.ilp-wg__menu:hover{background:var(--surface-hover);color:var(--text-primary)}
.ilp-wg--brand .ilp-wg__menu:hover,.ilp-wg--accent .ilp-wg__menu:hover{background:rgba(255,255,255,.12);color:#fff}
.ilp-wg__menu svg{width:16px;height:16px}

.ilp-wg__body{flex:1 1 auto;min-height:0;padding:0 20px 20px}
.ilp-wg__body--flush{padding:0}
.ilp-wg__body--scroll{overflow-y:auto}
.ilp-wg__hd+.ilp-wg__body--flush{padding-top:0}

.ilp-wg__ft{display:flex;align-items:center;gap:var(--space-3);padding:12px 20px;border-top:1px solid var(--border-subtle);font-size:var(--fs-xs);color:var(--text-muted)}
.ilp-wg__ft a{color:var(--text-link);font-weight:var(--weight-semibold);text-decoration:none}
.ilp-wg__ft a:hover{color:var(--il-blue-800)}
.ilp-wg--brand .ilp-wg__ft,.ilp-wg--accent .ilp-wg__ft{border-top-color:rgba(255,255,255,.12);color:rgba(255,255,255,.65)}

.ilp-wg__empty{display:flex;flex-direction:column;align-items:center;gap:6px;padding:34px 16px;text-align:center;color:var(--text-muted);font-size:var(--fs-sm)}
.ilp-wg__empty b{font-size:var(--fs-base);font-weight:var(--weight-bold);color:var(--text-secondary)}
.ilp-wg__sk{height:10px;margin:10px 0;border-radius:var(--radius-sm);background:var(--il-grayblue-100);animation:ilp-wg-pulse 1.3s var(--ease-standard) infinite}
@keyframes ilp-wg-pulse{50%{opacity:.45}}
`;

function useCSS() {
  React.useEffect(() => {
    if (document.getElementById('ilp-wg-css')) return;
    const s = document.createElement('style');
    s.id = 'ilp-wg-css';
    s.textContent = CSS;
    document.head.appendChild(s);
  }, []);
}

const IcDots = (p) => (
  <svg viewBox="0 0 24 24" fill="currentColor" aria-hidden="true" {...p}>
    <circle cx="12" cy="5" r="1.7" /><circle cx="12" cy="12" r="1.7" /><circle cx="12" cy="19" r="1.7" />
  </svg>
);

/**
 * The shell every dashboard widget sits in: header, body, footer.
 * Charts, lists, stats and tables are dropped inside it as children.
 */
export function Widget({
  title,
  subtitle,
  eyebrow,
  actions = null,
  onMenu,
  footer = null,
  tone = 'default',
  flat = false,
  flush = false,
  rule = false,
  scroll = false,
  height,
  loading = false,
  empty = false,
  emptyTitle = 'No data yet',
  emptyMessage,
  className = '',
  children,
  ...rest
}) {
  useCSS();
  const hasHead = title || subtitle || eyebrow || actions || onMenu;
  return (
    <section
      className={'ilp-wg' + (tone !== 'default' ? ' ilp-wg--' + tone : '') + (flat ? ' ilp-wg--flat' : '') + (className ? ' ' + className : '')}
      {...rest}
      style={{ ...(height ? { height } : null), ...(rest.style || {}) }}
    >
      {hasHead && (
        <header className={'ilp-wg__hd' + (rule ? ' ilp-wg__hd--rule' : '')}>
          <div className="ilp-wg__t">
            {eyebrow && <span className="ilp-wg__eyebrow">{eyebrow}</span>}
            {title && <div className="ilp-wg__ttl">{title}</div>}
            {subtitle && <div className="ilp-wg__sub">{subtitle}</div>}
          </div>
          {(actions || onMenu) && (
            <div className="ilp-wg__act">
              {actions}
              {onMenu && (
                <button type="button" className="ilp-wg__menu" aria-label="Widget options" onClick={onMenu}><IcDots /></button>
              )}
            </div>
          )}
        </header>
      )}

      <div className={'ilp-wg__body' + (flush ? ' ilp-wg__body--flush' : '') + (scroll ? ' ilp-wg__body--scroll' : '')}>
        {loading
          ? [80, 60, 92, 70].map((w, i) => <div className="ilp-wg__sk" key={i} style={{ width: w + '%' }} />)
          : empty
            ? <div className="ilp-wg__empty"><b>{emptyTitle}</b>{emptyMessage && <span>{emptyMessage}</span>}</div>
            : children}
      </div>

      {footer && <footer className="ilp-wg__ft">{footer}</footer>}
    </section>
  );
}
