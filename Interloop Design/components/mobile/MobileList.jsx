import React from 'react';

const CSS = `
.ilp-ml{font-family:var(--font-sans);background:var(--surface-card)}
.ilp-ml *{box-sizing:border-box}
.ilp-ml--card{margin:0 12px 12px;border-radius:var(--radius-lg);border:1px solid var(--border-subtle);overflow:hidden}
.ilp-ml__row{position:relative;display:flex;align-items:center;gap:13px;width:100%;min-height:64px;padding:12px 14px;text-align:left;font:inherit;color:inherit;background:var(--surface-card);border:0;cursor:pointer;-webkit-tap-highlight-color:transparent}
.ilp-ml--comfortable .ilp-ml__row{min-height:72px}
.ilp-ml--glove .ilp-ml__row{min-height:84px;padding:16px;gap:16px}
.ilp-ml--compact .ilp-ml__row{min-height:56px;padding:10px 14px}
.ilp-ml__row+.ilp-ml__row{border-top:1px solid var(--border-subtle)}
.ilp-ml__row:active{background:var(--il-grayblue-50)}
.ilp-ml__row[disabled]{opacity:.5}
.ilp-ml__row:focus-visible{outline:none;box-shadow:var(--ring);z-index:1}
.ilp-ml__stripe{position:absolute;left:0;top:0;bottom:0;width:4px}

.ilp-ml__ic{display:grid;place-items:center;width:44px;height:44px;flex:none;border-radius:var(--radius-md);background:var(--il-blue-100);color:var(--il-blue-700)}
.ilp-ml--glove .ilp-ml__ic{width:52px;height:52px}
.ilp-ml__ic svg{width:21px;height:21px}
.ilp-ml__ic--success{background:var(--il-earth-soft);color:var(--il-earth-ink)}
.ilp-ml__ic--warning{background:var(--il-sun-soft);color:var(--il-sun-ink)}
.ilp-ml__ic--danger{background:var(--il-red-soft);color:var(--il-red-ink)}
.ilp-ml__ic--neutral{background:var(--il-grayblue-100);color:var(--text-secondary)}
.ilp-ml__av{display:grid;place-items:center;width:44px;height:44px;flex:none;border-radius:50%;font-size:15px;font-weight:var(--weight-bold);color:#fff}

.ilp-ml__m{flex:1 1 auto;min-width:0}
.ilp-ml__t{display:flex;align-items:center;gap:8px;font-size:16px;font-weight:var(--weight-bold);line-height:1.3;letter-spacing:-0.01em}
.ilp-ml__t>span{overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
.ilp-ml__s{margin-top:3px;font-size:13px;line-height:1.4;color:var(--text-secondary);overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
.ilp-ml__meta{display:flex;flex-wrap:wrap;align-items:center;gap:6px 12px;margin-top:7px;font-size:12px;color:var(--text-muted)}
.ilp-ml__meta i{display:inline-flex;align-items:center;gap:4px;font-style:normal}
.ilp-ml__meta svg{width:13px;height:13px}
.ilp-ml__bar{height:6px;margin-top:9px;border-radius:3px;background:var(--il-grayblue-100);overflow:hidden}
.ilp-ml__bar b{display:block;height:100%;border-radius:3px;background:var(--brand-primary)}

.ilp-ml__end{display:flex;align-items:center;gap:10px;flex:none}
.ilp-ml__val{text-align:right}
.ilp-ml__val b{display:block;font-size:16px;font-weight:var(--weight-bold);font-variant-numeric:tabular-nums;line-height:1.2}
.ilp-ml__val span{display:block;margin-top:2px;font-size:12px;color:var(--text-secondary)}
.ilp-ml__chev{width:18px;height:18px;flex:none;color:var(--text-disabled)}
.ilp-ml__pill{display:inline-flex;align-items:center;gap:5px;height:24px;padding:0 10px;font-size:12px;font-weight:var(--weight-bold);border-radius:var(--radius-pill);background:var(--il-grayblue-100);color:var(--text-secondary);white-space:nowrap}
.ilp-ml__pill::before{content:"";width:6px;height:6px;border-radius:50%;background:currentColor}
.ilp-ml__pill--info{background:var(--il-blue-100);color:var(--il-blue-800)}
.ilp-ml__pill--success{background:var(--il-earth-soft);color:var(--il-earth-ink)}
.ilp-ml__pill--warning{background:var(--il-sun-soft);color:var(--il-sun-ink)}
.ilp-ml__pill--danger{background:var(--il-red-soft);color:var(--il-red-ink)}
.ilp-ml__cb{width:26px;height:26px;flex:none;margin:0;accent-color:var(--brand-primary)}
.ilp-ml--glove .ilp-ml__cb{width:30px;height:30px}

/* ---------- task card ---------- */
.ilp-mc{position:relative;margin:0 12px 12px;padding:16px;background:var(--surface-card);border:1px solid var(--border-subtle);border-radius:var(--radius-lg);box-shadow:var(--shadow-xs);font-family:var(--font-sans);overflow:hidden}
.ilp-mc__stripe{position:absolute;left:0;top:0;bottom:0;width:5px}
.ilp-mc__hd{display:flex;align-items:flex-start;gap:10px}
.ilp-mc__hd .h{min-width:0;flex:1}
.ilp-mc__eyebrow{font-size:12px;font-weight:var(--weight-bold);letter-spacing:.07em;text-transform:uppercase;color:var(--text-secondary)}
.ilp-mc__ttl{margin-top:3px;font-size:18px;font-weight:var(--weight-bold);letter-spacing:-0.015em;line-height:1.25}
.ilp-mc__sub{margin-top:4px;font-size:13px;line-height:1.45;color:var(--text-secondary)}
.ilp-mc__facts{display:grid;grid-template-columns:repeat(auto-fit,minmax(84px,1fr));gap:12px;margin-top:14px;padding-top:14px;border-top:1px solid var(--border-subtle)}
.ilp-mc__facts dt{font-size:12px;font-weight:var(--weight-bold);letter-spacing:.07em;text-transform:uppercase;color:var(--text-secondary)}
.ilp-mc__facts dd{margin:3px 0 0;font-size:15px;font-weight:var(--weight-bold);font-variant-numeric:tabular-nums}
.ilp-mc__acts{display:flex;gap:10px;margin-top:14px}
.ilp-mc__acts>*{flex:1}
`;

function useCSS() {
  React.useEffect(() => {
    if (document.getElementById('ilp-ml-css')) return;
    const s = document.createElement('style');
    s.id = 'ilp-ml-css';
    s.textContent = CSS;
    document.head.appendChild(s);
  }, []);
}

const IcChev = (p) => (
  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.4" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true" {...p}>
    <path d="M9 5l7 7-7 7" />
  </svg>
);

const TINTS = ['var(--il-blue-500)', 'var(--il-air)', 'var(--il-sun)', 'var(--il-earth)', 'var(--il-grayblue-500)'];
const initials = (n) => n.trim().split(/\s+/).slice(0, 2).map((p) => p[0]?.toUpperCase() || '').join('');
const tint = (n) => TINTS[[...n].reduce((a, c) => a + c.charCodeAt(0), 0) % TINTS.length];
const STRIPE = { success: 'var(--status-success)', warning: 'var(--status-warning)', danger: 'var(--status-danger)', info: 'var(--brand-primary)', neutral: 'var(--il-grayblue-300)' };

/**
 * Touch list. Rows are 64px by default, 84px in `glove` density — a shop-floor
 * operator wearing gloves cannot hit a 44px target reliably.
 */
export function MobileList({
  items = [],
  density = 'default',
  card = false,
  onItemClick,
  onToggle,
  showChevron = true,
  className = '',
  ...rest
}) {
  useCSS();
  return (
    <div
      className={'ilp-ml ilp-ml--' + density + (card ? ' ilp-ml--card' : '') + (className ? ' ' + className : '')}
      role="list" {...rest}
    >
      {items.map((it, i) => {
        const Tag = onItemClick || it.onClick ? 'button' : 'div';
        return (
          <Tag
            key={it.id ?? i}
            role="listitem"
            type={Tag === 'button' ? 'button' : undefined}
            disabled={it.disabled}
            className="ilp-ml__row"
            onClick={() => (it.onClick ? it.onClick(it) : onItemClick && onItemClick(it, i))}
          >
            {it.stripe && <span className="ilp-ml__stripe" style={{ background: STRIPE[it.stripe] || it.stripe }} />}
            {it.checkable && (
              <input
                type="checkbox" className="ilp-ml__cb" checked={!!it.checked}
                onClick={(e) => e.stopPropagation()}
                onChange={() => onToggle && onToggle(it, i)}
                aria-label={it.title}
              />
            )}
            {it.avatar !== undefined && !it.icon && (
              <span className="ilp-ml__av" style={{ background: tint(it.title || '?') }}>{initials(it.title || '?')}</span>
            )}
            {it.icon && <span className={'ilp-ml__ic' + (it.tone ? ' ilp-ml__ic--' + it.tone : '')}>{it.icon}</span>}

            <span className="ilp-ml__m">
              <span className="ilp-ml__t">
                <span>{it.title}</span>
                {it.status && <span className={'ilp-ml__pill' + (it.statusTone ? ' ilp-ml__pill--' + it.statusTone : '')}>{it.status}</span>}
              </span>
              {it.subtitle && <span className="ilp-ml__s">{it.subtitle}</span>}
              {it.meta && (
                <span className="ilp-ml__meta">
                  {it.meta.map((m, mi) => <i key={mi}>{m.icon}{m.label}</i>)}
                </span>
              )}
              {it.progress != null && (
                <span className="ilp-ml__bar"><b style={{ width: Math.max(0, Math.min(100, it.progress)) + '%', background: it.progressColor }} /></span>
              )}
            </span>

            <span className="ilp-ml__end">
              {(it.value != null || it.valueLabel) && (
                <span className="ilp-ml__val">
                  {it.value != null && <b>{it.value}</b>}
                  {it.valueLabel && <span>{it.valueLabel}</span>}
                </span>
              )}
              {it.trailing}
              {showChevron && (onItemClick || it.onClick) && !it.checkable && <IcChev className="ilp-ml__chev" />}
            </span>
          </Tag>
        );
      })}
    </div>
  );
}

/** The task card an operator acts on — one job, its facts, its actions. */
export function MobileCard({
  eyebrow, title, subtitle, stripe, status, statusTone,
  facts = [], actions = null, onClick, className = '', children, ...rest
}) {
  useCSS();
  return (
    <article className={'ilp-mc' + (className ? ' ' + className : '')} onClick={onClick} {...rest}>
      {stripe && <span className="ilp-mc__stripe" style={{ background: STRIPE[stripe] || stripe }} />}
      <div className="ilp-mc__hd">
        <div className="h">
          {eyebrow && <div className="ilp-mc__eyebrow">{eyebrow}</div>}
          <div className="ilp-mc__ttl">{title}</div>
          {subtitle && <div className="ilp-mc__sub">{subtitle}</div>}
        </div>
        {status && <span className={'ilp-ml__pill' + (statusTone ? ' ilp-ml__pill--' + statusTone : '')}>{status}</span>}
      </div>
      {facts.length > 0 && (
        <dl className="ilp-mc__facts">
          {facts.map((f) => <div key={f.label}><dt>{f.label}</dt><dd>{f.value}</dd></div>)}
        </dl>
      )}
      {children}
      {actions && <div className="ilp-mc__acts">{actions}</div>}
    </article>
  );
}
