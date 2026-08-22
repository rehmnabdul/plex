import React from 'react';

const CSS = `
.ilp-mb *{box-sizing:border-box}

/* ---------- app bar ---------- */
.ilp-mb__bar{display:flex;align-items:center;gap:10px;flex:none;min-height:56px;padding:6px 8px 6px 6px;background:var(--surface-card);border-bottom:1px solid var(--border-subtle);font-family:var(--font-sans);position:relative;z-index:5}
.ilp-mb__bar--brand{background:var(--il-grayblue-700);border-bottom-color:transparent;color:#fff}
.ilp-mb__bar--accent{background:var(--brand-primary);border-bottom-color:transparent;color:#fff}
.ilp-mb__bt{display:grid;place-items:center;width:44px;height:44px;flex:none;padding:0;color:inherit;background:transparent;border:0;border-radius:var(--radius-md);cursor:pointer}
.ilp-mb__bt:active{background:color-mix(in srgb,currentColor 12%,transparent)}
.ilp-mb__bt svg{width:22px;height:22px}
.ilp-mb__bt--badge{position:relative}
.ilp-mb__bt--badge b{position:absolute;top:5px;right:5px;min-width:17px;height:17px;padding:0 4px;display:grid;place-items:center;font-size:11px;font-weight:var(--weight-bold);color:#fff;background:var(--status-danger);border-radius:var(--radius-pill)}
.ilp-mb__ttls{min-width:0;flex:1;padding:0 2px}
.ilp-mb__ttl{font-size:17px;font-weight:var(--weight-bold);letter-spacing:-0.015em;line-height:1.2;overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
.ilp-mb__sub{margin-top:1px;font-size:12px;line-height:1.3;color:var(--text-muted);overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
.ilp-mb__bar--brand .ilp-mb__sub,.ilp-mb__bar--accent .ilp-mb__sub{color:rgba(255,255,255,.72)}
.ilp-mb__bar--center .ilp-mb__ttls{text-align:center}

/* ---------- screen body ---------- */
.ilp-mb__screen{flex:1 1 auto;min-height:0;overflow-y:auto;overscroll-behavior:contain;-webkit-overflow-scrolling:touch;background:var(--surface-page);font-family:var(--font-sans)}
.ilp-mb__screen--pad{padding:14px}
.ilp-mb__sec{padding:18px 16px 8px;font-size:12px;font-weight:var(--weight-bold);letter-spacing:.08em;text-transform:uppercase;color:var(--text-secondary)}

/* ---------- tab bar ---------- */
.ilp-mb__tabs{display:flex;flex:none;padding:6px 6px 2px;background:var(--surface-card);border-top:1px solid var(--border-subtle);font-family:var(--font-sans)}
.ilp-mb__tab{flex:1;display:flex;flex-direction:column;align-items:center;justify-content:center;gap:3px;min-height:52px;padding:5px 2px;font:inherit;font-size:12px;font-weight:var(--weight-semibold);color:var(--text-secondary);background:transparent;border:0;border-radius:var(--radius-md);cursor:pointer;position:relative}
.ilp-mb__tab svg{width:23px;height:23px}
.ilp-mb__tab--on{color:var(--brand-primary)}
.ilp-mb__tab:active{background:var(--surface-hover)}
.ilp-mb__tab b{position:absolute;top:2px;left:50%;margin-left:6px;min-width:17px;height:17px;padding:0 4px;display:grid;place-items:center;font-size:11px;font-weight:var(--weight-bold);color:#fff;background:var(--status-danger);border-radius:var(--radius-pill)}
.ilp-mb__tab--fab{flex:none;width:64px}
.ilp-mb__fab{display:grid;place-items:center;width:52px;height:52px;margin-top:-16px;color:#fff;background:var(--brand-primary);border:3px solid var(--surface-card);border-radius:50%;box-shadow:var(--shadow-brand)}
.ilp-mb__fab svg{width:24px;height:24px}

/* ---------- bottom sheet ---------- */
.ilp-mb__scrim{position:absolute;inset:0;z-index:40;background:rgba(51,59,74,.45);animation:ilp-mb-fade var(--dur-normal) var(--ease-out)}
.ilp-mb__sheet{position:absolute;left:0;right:0;bottom:0;z-index:41;display:flex;flex-direction:column;max-height:88%;background:var(--surface-card);border-radius:var(--radius-xl) var(--radius-xl) 0 0;box-shadow:0 -12px 40px rgba(51,59,74,.22);font-family:var(--font-sans);animation:ilp-mb-up var(--dur-normal) var(--ease-out)}
@keyframes ilp-mb-fade{from{opacity:0}}
@keyframes ilp-mb-up{from{transform:translateY(100%)}}
.ilp-mb__grab{flex:none;display:flex;justify-content:center;padding:9px 0 4px;cursor:grab}
.ilp-mb__grab i{width:38px;height:4px;border-radius:2px;background:var(--il-grayblue-200)}
.ilp-mb__shd{display:flex;align-items:center;gap:10px;flex:none;padding:6px 18px 12px}
.ilp-mb__shd .h{min-width:0;flex:1}
.ilp-mb__shd .h b{display:block;font-size:18px;font-weight:var(--weight-bold);letter-spacing:-0.015em}
.ilp-mb__shd .h span{display:block;margin-top:2px;font-size:13px;color:var(--text-muted)}
.ilp-mb__shb{flex:1 1 auto;min-height:0;overflow-y:auto;padding:0 18px 6px}
.ilp-mb__shf{display:flex;gap:10px;flex:none;padding:12px 18px calc(14px + env(safe-area-inset-bottom,0px));border-top:1px solid var(--border-subtle)}
.ilp-mb__shf>*{flex:1}

/* ---------- buttons sized for gloves ---------- */
.ilp-mb__btn{display:inline-flex;align-items:center;justify-content:center;gap:9px;width:100%;min-height:52px;padding:0 20px;font:inherit;font-size:16px;font-weight:var(--weight-bold);color:#fff;background:var(--brand-primary);border:1px solid transparent;border-radius:var(--radius-md);cursor:pointer;transition:background var(--dur-fast) var(--ease-standard)}
.ilp-mb__btn:active{transform:scale(.985)}
.ilp-mb__btn svg{width:20px;height:20px}
.ilp-mb__btn--lg{min-height:60px;font-size:17px}
.ilp-mb__btn--secondary{color:var(--text-primary);background:var(--surface-card);border-color:var(--border-strong)}
.ilp-mb__btn--ghost{color:var(--text-secondary);background:transparent}
.ilp-mb__btn--danger{background:var(--status-danger)}
.ilp-mb__btn--success{background:var(--il-earth-ink)}
.ilp-mb__btn[disabled]{opacity:.45;cursor:not-allowed}
.ilp-mb__bt:focus-visible,.ilp-mb__tab:focus-visible,.ilp-mb__btn:focus-visible{outline:none;box-shadow:var(--ring)}

/* ---------- app root ---------- */
.ilp-mb__shell{display:flex;flex-direction:column;height:100%;min-height:0;background:var(--surface-page);font-family:var(--font-sans)}
`;

function useCSS() {
  React.useEffect(() => {
    if (document.getElementById('ilp-mb-css')) return;
    const s = document.createElement('style');
    s.id = 'ilp-mb-css';
    s.textContent = CSS;
    document.head.appendChild(s);
  }, []);
}

const IcBack = (p) => (
  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.4" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true" {...p}>
    <path d="M15 5l-7 7 7 7" />
  </svg>
);
const IcClose = (p) => (
  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.4" strokeLinecap="round" aria-hidden="true" {...p}>
    <path d="M6 6l12 12" /><path d="M18 6 6 18" />
  </svg>
);

/** Vertical app root: app bar, scrolling screen, tab bar. Use outside a PhoneFrame. */
export function MobileShell({ className = '', children, ...rest }) {
  useCSS();
  return <div className={'ilp-mb ilp-mb__shell' + (className ? ' ' + className : '')} {...rest}>{children}</div>;
}

/** Top app bar. Back, title, subtitle, up to two trailing actions. */
export function MobileAppBar({
  title, subtitle, onBack, backLabel = 'Back', actions = null,
  tone = 'default', center = false, className = '', ...rest
}) {
  useCSS();
  return (
    <header
      className={'ilp-mb ilp-mb__bar' + (tone !== 'default' ? ' ilp-mb__bar--' + tone : '') + (center ? ' ilp-mb__bar--center' : '') + (className ? ' ' + className : '')}
      {...rest}
    >
      {onBack ? (
        <button type="button" className="ilp-mb__bt" aria-label={backLabel} onClick={onBack}><IcBack /></button>
      ) : <span style={{ width: 8 }} />}
      <div className="ilp-mb__ttls">
        <div className="ilp-mb__ttl">{title}</div>
        {subtitle && <div className="ilp-mb__sub">{subtitle}</div>}
      </div>
      {actions}
    </header>
  );
}

/** Icon action for the app bar. 44px target minimum. */
export function MobileAction({ icon, label, badge, onClick, ...rest }) {
  useCSS();
  return (
    <button
      type="button" aria-label={label} onClick={onClick}
      className={'ilp-mb__bt' + (badge ? ' ilp-mb__bt--badge' : '')} {...rest}
    >
      {icon}
      {badge != null && <b>{badge > 99 ? '99+' : badge}</b>}
    </button>
  );
}

/** Scrolling body between the app bar and the tab bar. */
export function MobileScreen({ padded = false, className = '', children, ...rest }) {
  useCSS();
  return (
    <div className={'ilp-mb ilp-mb__screen' + (padded ? ' ilp-mb__screen--pad' : '') + (className ? ' ' + className : '')} {...rest}>
      {children}
    </div>
  );
}

/** All-caps group heading inside a screen. */
export function MobileSectionLabel({ children }) {
  useCSS();
  return <div className="ilp-mb ilp-mb__sec">{children}</div>;
}

/** Bottom tab bar. Three to five destinations, optionally with a centre action. */
export function MobileTabBar({ tabs = [], value, onChange, fab, onFab, fabLabel = 'New', className = '', ...rest }) {
  useCSS();
  const half = Math.ceil(tabs.length / 2);
  const render = (t) => (
    <button
      key={t.key} type="button"
      className={'ilp-mb__tab' + (value === t.key ? ' ilp-mb__tab--on' : '')}
      aria-current={value === t.key ? 'page' : undefined}
      onClick={() => onChange && onChange(t.key)}
    >
      {t.icon}
      <span>{t.label}</span>
      {t.badge != null && <b>{t.badge > 99 ? '99+' : t.badge}</b>}
    </button>
  );
  return (
    <nav className={'ilp-mb ilp-mb__tabs' + (className ? ' ' + className : '')} {...rest}>
      {fab ? (
        <>
          {tabs.slice(0, half).map(render)}
          <div className="ilp-mb__tab ilp-mb__tab--fab">
            <button type="button" className="ilp-mb__fab" aria-label={fabLabel} onClick={onFab}>{fab}</button>
          </div>
          {tabs.slice(half).map(render)}
        </>
      ) : tabs.map(render)}
    </nav>
  );
}

/** Bottom sheet — the mobile substitute for a dialog. */
export function MobileSheet({
  open = true, title, subtitle, onClose, footer = null,
  closeLabel = 'Close', className = '', children, ...rest
}) {
  useCSS();
  if (!open) return null;
  return (
    <>
      <div className="ilp-mb ilp-mb__scrim" onClick={onClose} />
      <section className={'ilp-mb ilp-mb__sheet' + (className ? ' ' + className : '')} role="dialog" aria-modal="true" aria-label={title} {...rest}>
        <div className="ilp-mb__grab"><i /></div>
        {(title || onClose) && (
          <header className="ilp-mb__shd">
            <div className="h">
              {title && <b>{title}</b>}
              {subtitle && <span>{subtitle}</span>}
            </div>
            {onClose && <button type="button" className="ilp-mb__bt" aria-label={closeLabel} onClick={onClose}><IcClose /></button>}
          </header>
        )}
        <div className="ilp-mb__shb">{children}</div>
        {footer && <footer className="ilp-mb__shf">{footer}</footer>}
      </section>
    </>
  );
}

/** Full-width touch button. 52px standard, 60px for gloved use. */export function MobileButton({ variant = 'primary', size = 'md', icon = null, className = '', children, ...rest }) {
  useCSS();
  return (
    <button
      type="button"
      className={'ilp-mb__btn' + (variant !== 'primary' ? ' ilp-mb__btn--' + variant : '') + (size === 'lg' ? ' ilp-mb__btn--lg' : '') + (className ? ' ' + className : '')}
      {...rest}
    >
      {icon}{children}
    </button>
  );
}
