import React from 'react';

const CSS = `
.ilp-st{position:relative;display:flex;flex-direction:column;min-width:0;font-family:var(--font-sans);padding:20px;background:var(--surface-card);text-align:left}
.ilp-st *{box-sizing:border-box}
.ilp-st--card{border:1px solid var(--border-subtle);border-radius:var(--radius-lg);box-shadow:var(--shadow-sm)}
.ilp-st--brand{background:var(--il-grayblue-700);color:#fff}
.ilp-st--brand .ilp-st__lbl,.ilp-st--brand .ilp-st__hint{color:rgba(255,255,255,.6)}
.ilp-st--accent{background:var(--il-blue-500);color:#fff}
.ilp-st--accent .ilp-st__lbl,.ilp-st--accent .ilp-st__hint{color:rgba(255,255,255,.78)}
.ilp-st__stripe{position:absolute;left:0;top:0;bottom:0;width:3px}

.ilp-st__top{display:flex;align-items:flex-start;gap:12px}
.ilp-st__body{min-width:0;flex:1}
.ilp-st__lbl{display:flex;align-items:center;gap:5px;font-size:10px;font-weight:var(--weight-bold);letter-spacing:.08em;text-transform:uppercase;color:var(--text-muted)}
.ilp-st__go{width:13px;height:13px;flex:none;opacity:0;transform:translateX(-3px);transition:opacity var(--dur-fast) var(--ease-standard),transform var(--dur-fast) var(--ease-standard)}
.ilp-st--click:hover .ilp-st__go,.ilp-st--click:focus-visible .ilp-st__go{opacity:1;transform:none}
.ilp-st__val{margin-top:8px;font-size:var(--fs-3xl);font-weight:var(--weight-black);letter-spacing:-0.025em;line-height:1;font-variant-numeric:tabular-nums}
.ilp-st__val small{margin-left:4px;font-size:var(--fs-base);font-weight:var(--weight-bold);letter-spacing:0;opacity:.7}
.ilp-st__row{display:flex;align-items:center;gap:8px;margin-top:10px;flex-wrap:wrap}
.ilp-st__hint{font-size:var(--fs-xs);color:var(--text-muted)}
.ilp-st__delta{display:inline-flex;align-items:center;gap:3px;height:20px;padding:0 7px;font-size:var(--fs-xs);font-weight:var(--weight-bold);font-variant-numeric:tabular-nums;border-radius:var(--radius-pill);background:var(--il-grayblue-100);color:var(--text-secondary)}
.ilp-st__delta svg{width:12px;height:12px}
.ilp-st__delta--good{background:var(--il-earth-soft);color:var(--il-earth-ink)}
.ilp-st__delta--bad{background:var(--il-red-soft);color:var(--il-red-ink)}
.ilp-st__ic{display:grid;place-items:center;width:42px;height:42px;flex:none;border-radius:var(--radius-md);background:var(--il-blue-100);color:var(--il-blue-700)}
.ilp-st__ic svg{width:20px;height:20px}
.ilp-st__ic--success{background:var(--il-earth-soft);color:var(--il-earth-ink)}
.ilp-st__ic--warning{background:var(--il-sun-soft);color:var(--il-sun-ink)}
.ilp-st__ic--danger{background:var(--il-red-soft);color:var(--il-red-ink)}
.ilp-st--brand .ilp-st__ic,.ilp-st--accent .ilp-st__ic{background:rgba(255,255,255,.16);color:#fff}
.ilp-st__spark{margin-top:auto;padding-top:16px}
.ilp-st__bar{height:5px;margin-top:auto;border-radius:3px;background:var(--il-grayblue-100);overflow:hidden}
.ilp-st--brand .ilp-st__bar,.ilp-st--accent .ilp-st__bar{background:rgba(255,255,255,.2)}
.ilp-st__bar i{display:block;height:100%;border-radius:3px;background:var(--brand-primary);transition:width var(--dur-slow) var(--ease-out)}
.ilp-st--accent .ilp-st__bar i{background:#fff}

/* interactive tiles */
.ilp-st--click{width:100%;font:inherit;color:inherit;border:0;cursor:pointer;text-decoration:none;transition:background var(--dur-fast) var(--ease-standard),box-shadow var(--dur-fast) var(--ease-standard)}
.ilp-st--click:hover{background:var(--il-grayblue-50)}
.ilp-st--click:active{background:var(--il-grayblue-100)}
.ilp-st--click:focus-visible{outline:none;box-shadow:var(--ring);z-index:1}
.ilp-st--click.ilp-st--card:hover{box-shadow:var(--shadow-md)}
.ilp-st--brand.ilp-st--click:hover{background:var(--il-grayblue-600)}
.ilp-st--accent.ilp-st--click:hover{background:var(--il-blue-600)}

.ilp-sg{display:grid;background:var(--surface-card);border:1px solid var(--border-subtle);border-radius:var(--radius-lg);overflow:hidden;box-shadow:var(--shadow-sm)}
.ilp-sg>*{box-shadow:1px 0 0 var(--border-subtle),0 1px 0 var(--border-subtle)}

.ilp-pr{position:relative;display:inline-flex;flex-direction:column;align-items:center;font-family:var(--font-sans)}
.ilp-pr svg{display:block;transform:rotate(-90deg)}
.ilp-pr__track{stroke:var(--il-grayblue-100)}
.ilp-pr__arc{transition:stroke-dashoffset var(--dur-slow) var(--ease-out);stroke-linecap:round}
.ilp-pr__mid{position:absolute;top:0;left:0;right:0;display:flex;flex-direction:column;align-items:center;justify-content:center;text-align:center}
.ilp-pr__mid b{font-size:var(--fs-xl);font-weight:var(--weight-black);letter-spacing:-0.02em;line-height:1;font-variant-numeric:tabular-nums}
.ilp-pr__mid span{margin-top:3px;font-size:10px;font-weight:var(--weight-bold);letter-spacing:.06em;text-transform:uppercase;color:var(--text-muted)}
.ilp-pr__cap{margin-top:10px;font-size:var(--fs-xs);font-weight:var(--weight-semibold);color:var(--text-secondary);text-align:center}
`;

function useCSS() {
  React.useEffect(() => {
    if (document.getElementById('ilp-st-css')) return;
    const s = document.createElement('style');
    s.id = 'ilp-st-css';
    s.textContent = CSS;
    document.head.appendChild(s);
  }, []);
}

const IcUp = (p) => <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.4" strokeLinecap="round" strokeLinejoin="round" {...p}><path d="M7 17 17 7" /><path d="M9 7h8v8" /></svg>;
const IcDown = (p) => <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.4" strokeLinecap="round" strokeLinejoin="round" {...p}><path d="M7 7l10 10" /><path d="M17 9v8H9" /></svg>;

const IcGo = (p) => <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.4" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true" {...p}><path d="M5 12h13" /><path d="m12 6 6 6-6 6" /></svg>;

const STRIPE = { brand: 'var(--brand-primary)', success: 'var(--status-success)', warning: 'var(--status-warning)', danger: 'var(--status-danger)' };

/** Inline sparkline for a stat tile — no axes, last point marked. */
function MiniSpark({ data, color, width = 108, height = 34 }) {
  const max = Math.max(...data);
  const min = Math.min(...data);
  const span = max - min || 1;
  const pts = data.map((v, i) => [(i / (data.length - 1)) * (width - 4) + 2, height - 3 - ((v - min) / span) * (height - 8)]);
  const d = `M${pts.map((p) => p.join(',')).join('L')}`;
  return (
    <svg width={width} height={height} aria-hidden="true">
      <path d={`${d}L${pts[pts.length - 1][0]},${height}L${pts[0][0]},${height}Z`} fill={color} opacity="0.15" />
      <path d={d} fill="none" stroke={color} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" />
      <circle cx={pts[pts.length - 1][0]} cy={pts[pts.length - 1][1]} r="3" fill={color} />
    </svg>
  );
}

/**
 * A single KPI: label, big number, delta, and optionally a sparkline or a
 * progress bar. Use inside StatGrid, or standalone with `card`.
 */
export function StatTile({
  label,
  value,
  unit,
  hint,
  delta,
  direction = 'flat',
  invert = false,
  icon = null,
  iconTone = 'info',
  tone = 'default',
  stripe,
  spark,
  sparkColor = 'var(--brand-primary)',
  progress,
  progressColor,
  card = false,
  onClick,
  href,
  as,
  className = '',
  ...rest
}) {
  useCSS();
  const good = direction === 'flat' ? null : invert ? direction === 'down' : direction === 'up';
  const interactive = !!(onClick || href);
  const Tag = as || (href ? 'a' : onClick ? 'button' : 'div');
  return (
    <Tag
      className={'ilp-st' + (card ? ' ilp-st--card' : '') + (tone !== 'default' ? ' ilp-st--' + tone : '')
        + (interactive ? ' ilp-st--click' : '') + (className ? ' ' + className : '')}
      type={Tag === 'button' ? 'button' : undefined}
      href={href}
      onClick={onClick}
      {...rest}
    >
      {stripe && <span className="ilp-st__stripe" style={{ background: STRIPE[stripe] || stripe }} />}
      <div className="ilp-st__top">
        <div className="ilp-st__body">
          <div className="ilp-st__lbl">{label}{interactive && <IcGo className="ilp-st__go" />}</div>
          <div className="ilp-st__val">{value}{unit && <small>{unit}</small>}</div>
          {(delta || hint) && (
            <div className="ilp-st__row">
              {delta && (
                <span className={'ilp-st__delta' + (good === true ? ' ilp-st__delta--good' : good === false ? ' ilp-st__delta--bad' : '')}>
                  {direction === 'up' ? <IcUp /> : direction === 'down' ? <IcDown /> : null}{delta}
                </span>
              )}
              {hint && <span className="ilp-st__hint">{hint}</span>}
            </div>
          )}
        </div>
        {icon && <span className={'ilp-st__ic ilp-st__ic--' + iconTone}>{icon}</span>}
      </div>
      {spark && <div className="ilp-st__spark"><MiniSpark data={spark} color={sparkColor} /></div>}
      {progress != null && (
        <div className="ilp-st__bar" style={{ marginTop: spark ? 12 : undefined }}><i style={{ width: Math.max(0, Math.min(100, progress)) + '%', background: progressColor }} /></div>
      )}
    </Tag>
  );
}

/** Hairline-divided grid of StatTiles — the classic KPI strip. */
export function StatGrid({ columns = 4, minWidth = 200, children, className = '', ...rest }) {
  useCSS();
  return (
    <div
      className={'ilp-sg' + (className ? ' ' + className : '')}
      style={{ gridTemplateColumns: columns ? `repeat(auto-fit,minmax(${minWidth}px,1fr))` : undefined }}
      {...rest}
    >
      {children}
    </div>
  );
}

/** Circular percentage — completion, capacity, score out of a target. */
export function ProgressRing({
  value = 0,
  max = 100,
  size = 132,
  thickness = 12,
  color = 'var(--brand-primary)',
  label,
  caption,
  display,
  className = '',
  ...rest
}) {
  useCSS();
  const pct = Math.max(0, Math.min(1, value / max));
  const r = size / 2 - thickness / 2;
  const c = 2 * Math.PI * r;
  return (
    <div className={'ilp-pr' + (className ? ' ' + className : '')} {...rest}>
      <svg width={size} height={size} role="img" aria-label={`${Math.round(pct * 100)}%`}>
        <circle className="ilp-pr__track" cx={size / 2} cy={size / 2} r={r} fill="none" strokeWidth={thickness} />
        <circle
          className="ilp-pr__arc" cx={size / 2} cy={size / 2} r={r} fill="none"
          stroke={color} strokeWidth={thickness}
          strokeDasharray={c} strokeDashoffset={c * (1 - pct)}
        />
      </svg>
      <div className="ilp-pr__mid" style={{ height: size }}>
        <b>{display ?? `${Math.round(pct * 100)}%`}</b>
        {label && <span>{label}</span>}
      </div>
      {caption && <div className="ilp-pr__cap">{caption}</div>}
    </div>
  );
}
