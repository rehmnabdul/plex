import React from 'react';

const CSS = `
.ilp-tb *{box-sizing:border-box}

/* ---------- device shell ---------- */
.ilp-tb__dev{position:relative;display:inline-block;font-family:var(--font-sans);flex:none}
.ilp-tb__body{position:relative;padding:14px;background:var(--il-grayblue-950);border-radius:32px;box-shadow:var(--shadow-xl),0 0 0 1px rgba(0,0,0,.25)}
.ilp-tb--flat .ilp-tb__body{padding:0;background:transparent;border:1px solid var(--border-default);border-radius:var(--radius-xl);box-shadow:var(--shadow-md)}
.ilp-tb__screen{position:relative;display:flex;flex-direction:column;overflow:hidden;border-radius:20px;background:var(--surface-page)}
.ilp-tb--flat .ilp-tb__screen{border-radius:var(--radius-xl)}
.ilp-tb__cam{position:absolute;z-index:8;width:7px;height:7px;border-radius:50%;background:rgba(255,255,255,.22);box-shadow:inset 0 0 0 1px rgba(0,0,0,.4)}
.ilp-tb__status{display:flex;align-items:center;gap:14px;flex:none;height:34px;padding:0 22px;font-size:13px;font-weight:var(--weight-bold);color:var(--text-primary);position:relative;z-index:7}
.ilp-tb__status .r{margin-left:auto;display:flex;align-items:center;gap:8px}
.ilp-tb__status svg{width:16px;height:16px}
.ilp-tb__batt{display:flex;align-items:center;gap:2px}
.ilp-tb__batt i{display:block;width:24px;height:12px;padding:1.5px;border:1.5px solid currentColor;border-radius:3px;opacity:.9}
.ilp-tb__batt i b{display:block;height:100%;background:currentColor;border-radius:1px}
.ilp-tb__view{flex:1 1 auto;min-height:0;display:flex;position:relative}
.ilp-tb__home{flex:none;display:flex;align-items:center;justify-content:center;height:20px}
.ilp-tb__home i{display:block;width:170px;height:5px;border-radius:3px;background:var(--il-grayblue-800);opacity:.3}
.ilp-tb__cap{margin-top:12px;text-align:center;font-size:var(--fs-xs);font-weight:var(--weight-bold);color:var(--text-secondary)}
.ilp-tb__cap span{display:block;margin-top:2px;font-weight:var(--weight-regular);color:var(--text-muted)}

/* ---------- side rail ---------- */
.ilp-tr{display:flex;flex-direction:column;flex:none;width:92px;padding:10px 8px;background:var(--il-grayblue-700);color:#fff;font-family:var(--font-sans)}
.ilp-tr--wide{width:216px;padding:12px}
.ilp-tr__brand{display:flex;align-items:center;justify-content:center;height:48px;margin-bottom:6px;flex:none}
.ilp-tr--wide .ilp-tr__brand{justify-content:flex-start;padding:0 8px}
.ilp-tr__items{display:flex;flex-direction:column;gap:4px;flex:1 1 auto;min-height:0;overflow-y:auto}
.ilp-tr__it{position:relative;display:flex;flex-direction:column;align-items:center;justify-content:center;gap:5px;min-height:64px;padding:9px 4px;font:inherit;font-size:11px;font-weight:var(--weight-bold);color:rgba(255,255,255,.7);background:transparent;border:0;border-radius:var(--radius-md);cursor:pointer;transition:background var(--dur-fast) var(--ease-standard),color var(--dur-fast) var(--ease-standard)}
.ilp-tr--wide .ilp-tr__it{flex-direction:row;justify-content:flex-start;gap:12px;min-height:48px;padding:10px 12px;font-size:var(--fs-base);font-weight:var(--weight-semibold)}
.ilp-tr__it svg{width:23px;height:23px;flex:none}
.ilp-tr__it:hover{background:rgba(255,255,255,.08);color:#fff}
.ilp-tr__it:focus-visible{outline:none;box-shadow:var(--ring)}
.ilp-tr__it--on{background:var(--brand-primary);color:#fff}
.ilp-tr__it--on:hover{background:var(--brand-primary)}
.ilp-tr__bd{position:absolute;top:7px;right:14px;min-width:19px;height:19px;padding:0 5px;display:grid;place-items:center;font-size:11px;font-weight:var(--weight-bold);color:#fff;background:var(--status-danger);border-radius:var(--radius-pill)}
.ilp-tr--wide .ilp-tr__bd{position:static;margin-left:auto}
.ilp-tr__foot{flex:none;padding-top:8px;margin-top:8px;border-top:1px solid rgba(255,255,255,.12);display:flex;justify-content:center}

/* ---------- split view ---------- */
.ilp-sv{display:flex;flex:1 1 auto;min-width:0;min-height:0;font-family:var(--font-sans);background:var(--surface-page)}
.ilp-sv__master{display:flex;flex-direction:column;flex:none;min-height:0;background:var(--surface-card);border-right:1px solid var(--border-default);transition:width var(--dur-normal) var(--ease-standard)}
.ilp-sv__master--hidden{width:0 !important;overflow:hidden;border-right:0}
.ilp-sv__mhd{display:flex;align-items:center;gap:10px;flex:none;padding:14px 16px 12px;border-bottom:1px solid var(--border-subtle)}
.ilp-sv__mhd .t{min-width:0;flex:1}
.ilp-sv__mhd .t b{display:block;font-size:var(--fs-base);font-weight:var(--weight-bold);letter-spacing:-0.01em}
.ilp-sv__mhd .t span{display:block;margin-top:2px;font-size:var(--fs-xs);color:var(--text-secondary)}
.ilp-sv__mbody{flex:1 1 auto;min-height:0;overflow-y:auto}
.ilp-sv__detail{display:flex;flex-direction:column;flex:1 1 auto;min-width:0;min-height:0}
.ilp-sv__dbody{flex:1 1 auto;min-height:0;overflow-y:auto;padding:20px}
.ilp-sv__dbody--flush{padding:0}
.ilp-sv__empty{flex:1;display:flex;flex-direction:column;align-items:center;justify-content:center;gap:8px;padding:40px;text-align:center;color:var(--text-muted)}
.ilp-sv__empty b{font-size:var(--fs-lg);font-weight:var(--weight-bold);color:var(--text-secondary)}
.ilp-sv__empty span{font-size:var(--fs-sm);max-width:36ch;line-height:1.6}

/* ---------- toolbar ---------- */
.ilp-tt{display:flex;align-items:center;gap:12px;flex:none;min-height:62px;padding:10px 20px;background:var(--surface-card);border-bottom:1px solid var(--border-default);font-family:var(--font-sans)}
.ilp-tt__back{display:grid;place-items:center;width:40px;height:40px;flex:none;padding:0;color:var(--text-secondary);background:transparent;border:0;border-radius:var(--radius-md);cursor:pointer}
.ilp-tt__back:hover{background:var(--surface-hover);color:var(--text-primary)}
.ilp-tt__back:focus-visible{outline:none;box-shadow:var(--ring)}
.ilp-tt__back svg{width:21px;height:21px}
.ilp-tt__t{min-width:0;flex:1}
.ilp-tt__t b{display:block;font-size:var(--fs-lg);font-weight:var(--weight-bold);letter-spacing:-0.015em;line-height:1.2;overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
.ilp-tt__t span{display:block;margin-top:2px;font-size:var(--fs-xs);color:var(--text-muted);overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
.ilp-tt__acts{display:flex;align-items:center;gap:10px;flex:none}
`;

function useCSS() {
  React.useEffect(() => {
    if (document.getElementById('ilp-tablet-css')) return;
    const s = document.createElement('style');
    s.id = 'ilp-tablet-css';
    s.textContent = CSS;
    document.head.appendChild(s);
  }, []);
}

const IcSignal = (p) => (
  <svg viewBox="0 0 24 24" fill="currentColor" aria-hidden="true" {...p}>
    <rect x="2" y="14" width="3.5" height="6" rx="1" opacity=".9" /><rect x="7.5" y="10" width="3.5" height="10" rx="1" opacity=".9" />
    <rect x="13" y="6" width="3.5" height="14" rx="1" opacity=".9" /><rect x="18.5" y="3" width="3.5" height="17" rx="1" opacity=".35" />
  </svg>
);
const IcWifi = (p) => (
  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" aria-hidden="true" {...p}>
    <path d="M2.5 8.5a15 15 0 0 1 19 0" /><path d="M6 12.5a10 10 0 0 1 12 0" /><path d="M9.5 16.5a5 5 0 0 1 5 0" /><path d="M12 20h.01" />
  </svg>
);
const IcBack = (p) => <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.4" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true" {...p}><path d="M15 5l-7 7 7 7" /></svg>;
const IcPanel = (p) => <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true" {...p}><path d="M3 4h18v16H3z" /><path d="M9 4v16" /></svg>;

/** 11-inch tablet shell — 834×1194 portrait, 1194×834 landscape. */
export function TabletFrame({
  orientation = 'landscape',
  width,
  height,
  time = '09:41',
  date = 'Tue 4 Aug',
  battery = 76,
  flat = false,
  showStatusBar = true,
  showHome = true,
  caption,
  captionNote,
  scale,
  className = '',
  children,
  ...rest
}) {
  useCSS();
  const land = orientation === 'landscape';
  const w = width ?? (land ? 1194 : 834);
  const h = height ?? (land ? 834 : 1194);
  const frame = (
    <div className={'ilp-tb ilp-tb__dev' + (flat ? ' ilp-tb--flat' : '') + (className ? ' ' + className : '')} {...rest}>
      <div className="ilp-tb__body">
        <div className="ilp-tb__screen" style={{ width: w, height: h }}>
          {!flat && <span className="ilp-tb__cam" style={land ? { left: 6, top: '50%' } : { top: 6, left: '50%' }} />}
          {showStatusBar && (
            <div className="ilp-tb__status">
              <span>{time}</span>
              <span style={{ color: 'var(--text-muted)', fontWeight: 'var(--weight-semibold)' }}>{date}</span>
              <span className="r">
                <IcSignal /><IcWifi />
                <span className="ilp-tb__batt"><i><b style={{ width: `${battery}%` }} /></i></span>
              </span>
            </div>
          )}
          <div className="ilp-tb__view">{children}</div>
          {showHome && <div className="ilp-tb__home"><i /></div>}
        </div>
      </div>
      {caption && <div className="ilp-tb__cap">{caption}{captionNote && <span>{captionNote}</span>}</div>}
    </div>
  );
  if (!scale) return frame;
  return (
    <div style={{ width: w * scale + (flat ? 2 : 28), height: h * scale + (flat ? 2 : 28) + (caption ? 36 : 0) }}>
      <div style={{ transform: `scale(${scale})`, transformOrigin: 'top left' }}>{frame}</div>
    </div>
  );
}

/**
 * Vertical navigation rail. On a tablet the thumbs rest at the sides, not the
 * bottom — a phone tab bar is the wrong instrument here.
 */
export function TabletRail({
  items = [], value, onChange, header, footer, wide = false, className = '', ...rest
}) {
  useCSS();
  return (
    <nav className={'ilp-tb ilp-tr' + (wide ? ' ilp-tr--wide' : '') + (className ? ' ' + className : '')} aria-label="Main" {...rest}>
      {header && <div className="ilp-tr__brand">{header}</div>}
      <div className="ilp-tr__items">
        {items.map((it) => (
          <button
            key={it.key} type="button"
            className={'ilp-tr__it' + (value === it.key ? ' ilp-tr__it--on' : '')}
            aria-current={value === it.key ? 'page' : undefined}
            onClick={() => onChange && onChange(it.key)}
          >
            {it.icon}
            <span>{it.label}</span>
            {it.badge != null && <span className="ilp-tr__bd">{it.badge > 99 ? '99+' : it.badge}</span>}
          </button>
        ))}
      </div>
      {footer && <div className="ilp-tr__foot">{footer}</div>}
    </nav>
  );
}

/** Toolbar above a detail pane. */
export function TabletToolbar({ title, subtitle, onBack, onToggleMaster, actions, className = '', ...rest }) {
  useCSS();
  return (
    <header className={'ilp-tb ilp-tt' + (className ? ' ' + className : '')} {...rest}>
      {onToggleMaster && (
        <button type="button" className="ilp-tt__back" aria-label="Toggle list pane" onClick={onToggleMaster}><IcPanel /></button>
      )}
      {onBack && <button type="button" className="ilp-tt__back" aria-label="Back" onClick={onBack}><IcBack /></button>}
      <div className="ilp-tt__t">
        <b>{title}</b>
        {subtitle && <span>{subtitle}</span>}
      </div>
      {actions && <div className="ilp-tt__acts">{actions}</div>}
    </header>
  );
}

/**
 * Master–detail split. The tablet's defining layout: the list stays on screen
 * while the record is worked, so nobody loses their place going back.
 */
export function SplitView({
  master,
  masterTitle,
  masterSubtitle,
  masterActions,
  masterWidth = 380,
  masterHidden = false,
  detail,
  detailFlush = false,
  emptyTitle = 'Nothing selected',
  emptyMessage = 'Pick a record from the list to work on it.',
  className = '',
  ...rest
}) {
  useCSS();
  return (
    <div className={'ilp-tb ilp-sv' + (className ? ' ' + className : '')} {...rest}>
      <div
        className={'ilp-sv__master' + (masterHidden ? ' ilp-sv__master--hidden' : '')}
        style={{ width: masterWidth }}
      >
        {(masterTitle || masterActions) && (
          <div className="ilp-sv__mhd">
            <div className="t">
              {masterTitle && <b>{masterTitle}</b>}
              {masterSubtitle && <span>{masterSubtitle}</span>}
            </div>
            {masterActions}
          </div>
        )}
        <div className="ilp-sv__mbody">{master}</div>
      </div>
      <div className="ilp-sv__detail">
        {detail || (
          <div className="ilp-sv__empty"><b>{emptyTitle}</b><span>{emptyMessage}</span></div>
        )}
      </div>
    </div>
  );
}

/** Scrolling body for the detail pane. */
export function SplitDetailBody({ flush = false, className = '', children, ...rest }) {
  useCSS();
  return <div className={'ilp-tb ilp-sv__dbody' + (flush ? ' ilp-sv__dbody--flush' : '') + (className ? ' ' + className : '')} {...rest}>{children}</div>;
}
