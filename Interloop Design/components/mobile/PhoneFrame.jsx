import React from 'react';

const CSS = `
.ilp-ph{position:relative;display:inline-block;font-family:var(--font-sans);flex:none}
.ilp-ph *{box-sizing:border-box}
.ilp-ph__body{position:relative;background:var(--il-grayblue-950);border-radius:44px;padding:12px;box-shadow:var(--shadow-xl),0 0 0 1px rgba(0,0,0,.25)}
.ilp-ph--flat .ilp-ph__body{padding:0;border-radius:var(--radius-xl);box-shadow:var(--shadow-md);background:transparent;border:1px solid var(--border-default)}
.ilp-ph__screen{position:relative;overflow:hidden;border-radius:34px;background:var(--surface-page);display:flex;flex-direction:column}
.ilp-ph--flat .ilp-ph__screen{border-radius:var(--radius-xl)}
.ilp-ph--dark .ilp-ph__screen{background:var(--il-grayblue-900);color:#fff}

.ilp-ph__notch{position:absolute;top:0;left:50%;transform:translateX(-50%);width:124px;height:28px;background:var(--il-grayblue-950);border-radius:0 0 18px 18px;z-index:6}
.ilp-ph__status{display:flex;align-items:center;flex:none;height:44px;padding:0 22px 0 26px;font-size:13px;font-weight:var(--weight-bold);color:var(--text-primary);background:transparent;position:relative;z-index:7}
.ilp-ph--dark .ilp-ph__status{color:#fff}
.ilp-ph__status .t{letter-spacing:-0.01em}
.ilp-ph__status .r{margin-left:auto;display:flex;align-items:center;gap:6px}
.ilp-ph__status svg{width:16px;height:16px}
.ilp-ph__batt{display:flex;align-items:center;gap:2px}
.ilp-ph__batt i{display:block;width:22px;height:11px;border:1.5px solid currentColor;border-radius:3px;padding:1.5px;opacity:.9}
.ilp-ph__batt i b{display:block;height:100%;background:currentColor;border-radius:1px}
.ilp-ph__batt u{display:block;width:2px;height:4px;background:currentColor;border-radius:0 1px 1px 0;opacity:.5}

.ilp-ph__view{flex:1 1 auto;min-height:0;display:flex;flex-direction:column;position:relative}
.ilp-ph__home{flex:none;display:flex;align-items:center;justify-content:center;height:24px}
.ilp-ph__home i{display:block;width:134px;height:5px;border-radius:3px;background:var(--il-grayblue-800);opacity:.35}
.ilp-ph--dark .ilp-ph__home i{background:#fff;opacity:.4}
.ilp-ph__cap{margin-top:12px;text-align:center;font-size:var(--fs-xs);font-weight:var(--weight-bold);color:var(--text-secondary)}
.ilp-ph__cap span{display:block;margin-top:2px;font-weight:var(--weight-regular);color:var(--text-muted)}
`;

function useCSS() {
  React.useEffect(() => {
    if (document.getElementById('ilp-ph-css')) return;
    const s = document.createElement('style');
    s.id = 'ilp-ph-css';
    s.textContent = CSS;
    document.head.appendChild(s);
  }, []);
}

const IcSignal = (p) => (
  <svg viewBox="0 0 24 24" fill="currentColor" aria-hidden="true" {...p}>
    <rect x="2" y="14" width="3.5" height="6" rx="1" opacity=".9" />
    <rect x="7.5" y="10" width="3.5" height="10" rx="1" opacity=".9" />
    <rect x="13" y="6" width="3.5" height="14" rx="1" opacity=".9" />
    <rect x="18.5" y="3" width="3.5" height="17" rx="1" opacity=".35" />
  </svg>
);
const IcWifi = (p) => (
  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" aria-hidden="true" {...p}>
    <path d="M2.5 8.5a15 15 0 0 1 19 0" /><path d="M6 12.5a10 10 0 0 1 12 0" /><path d="M9.5 16.5a5 5 0 0 1 5 0" /><path d="M12 20h.01" />
  </svg>
);

/**
 * Device shell for showing a mobile screen in context. Purely presentational —
 * everything inside is real, scrollable UI.
 */
export function PhoneFrame({
  width = 390,
  height = 844,
  time = '09:41',
  carrier,
  dark = false,
  flat = false,
  showStatusBar = true,
  showHome = true,
  battery = 82,
  caption,
  captionNote,
  scale,
  className = '',
  children,
  ...rest
}) {
  useCSS();
  const frame = (
    <div className={'ilp-ph' + (dark ? ' ilp-ph--dark' : '') + (flat ? ' ilp-ph--flat' : '') + (className ? ' ' + className : '')} {...rest}>
      <div className="ilp-ph__body">
        <div className="ilp-ph__screen" style={{ width, height }}>
          {!flat && <span className="ilp-ph__notch" />}
          {showStatusBar && (
            <div className="ilp-ph__status">
              <span className="t">{time}</span>
              <span className="r">
                {carrier && <span style={{ fontSize: 11, opacity: 0.7 }}>{carrier}</span>}
                <IcSignal /><IcWifi />
                <span className="ilp-ph__batt"><i><b style={{ width: `${battery}%` }} /></i><u /></span>
              </span>
            </div>
          )}
          <div className="ilp-ph__view">{children}</div>
          {showHome && <div className="ilp-ph__home"><i /></div>}
        </div>
      </div>
      {caption && <div className="ilp-ph__cap">{caption}{captionNote && <span>{captionNote}</span>}</div>}
    </div>
  );
  if (!scale) return frame;
  return (
    <div style={{ width: width * scale + (flat ? 0 : 24), height: height * scale + (flat ? 0 : 24) + (caption ? 34 : 0) }}>
      <div style={{ transform: `scale(${scale})`, transformOrigin: 'top left' }}>{frame}</div>
    </div>
  );
}
