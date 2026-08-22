import React from 'react';

const CSS = `
.ilp-dl{display:flex;flex-direction:column;font-family:var(--font-sans)}
.ilp-dl *{box-sizing:border-box}
.ilp-dl--divided .ilp-dl__row+.ilp-dl__row{border-top:1px solid var(--border-subtle)}
.ilp-dl__row{display:flex;align-items:center;gap:13px;padding:12px 0;min-width:0;text-align:left;background:none;border:0;font:inherit;color:inherit;width:100%}
.ilp-dl--inset .ilp-dl__row{padding-left:20px;padding-right:20px}
.ilp-dl--compact .ilp-dl__row{padding-top:8px;padding-bottom:8px;gap:11px}
.ilp-dl__row--click{cursor:pointer;transition:background var(--dur-fast) var(--ease-standard)}
.ilp-dl__row--click:hover{background:var(--il-grayblue-50)}
.ilp-dl__row--click:focus-visible{outline:none;box-shadow:var(--ring)}

.ilp-dl__rank{display:grid;place-items:center;width:26px;height:26px;flex:none;border-radius:var(--radius-sm);font-size:var(--fs-xs);font-weight:var(--weight-bold);font-variant-numeric:tabular-nums;background:var(--il-grayblue-100);color:var(--text-secondary)}
.ilp-dl__rank--1{background:var(--il-blue-500);color:#fff}
.ilp-dl__rank--2{background:var(--il-blue-200);color:var(--il-blue-800)}
.ilp-dl__rank--3{background:var(--il-blue-100);color:var(--il-blue-700)}
.ilp-dl__ic{display:grid;place-items:center;width:36px;height:36px;flex:none;border-radius:var(--radius-md);background:var(--il-blue-100);color:var(--il-blue-700)}
.ilp-dl__ic svg{width:17px;height:17px}
.ilp-dl__ic--success{background:var(--il-earth-soft);color:var(--il-earth-ink)}
.ilp-dl__ic--warning{background:var(--il-sun-soft);color:var(--il-sun-ink)}
.ilp-dl__ic--danger{background:var(--il-red-soft);color:var(--il-red-ink)}
.ilp-dl__ic--neutral{background:var(--il-grayblue-100);color:var(--text-secondary)}
.ilp-dl__sw{width:10px;height:10px;flex:none;border-radius:3px}

.ilp-dl__m{flex:1 1 auto;min-width:0}
.ilp-dl__ttl{display:flex;align-items:center;gap:7px;font-size:var(--fs-sm);font-weight:var(--weight-bold);line-height:1.35;color:var(--text-primary)}
.ilp-dl__ttl span{overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
.ilp-dl__sub{margin-top:2px;font-size:var(--fs-xs);line-height:1.4;color:var(--text-muted);overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
.ilp-dl__bar{height:5px;margin-top:7px;border-radius:3px;background:var(--il-grayblue-100);overflow:hidden}
.ilp-dl__bar i{display:block;height:100%;border-radius:3px;background:var(--brand-primary);transition:width var(--dur-slow) var(--ease-out)}

.ilp-dl__end{display:flex;flex-direction:column;align-items:flex-end;gap:3px;flex:none;text-align:right}
.ilp-dl__val{font-size:var(--fs-sm);font-weight:var(--weight-bold);font-variant-numeric:tabular-nums;white-space:nowrap}
.ilp-dl__meta{font-size:var(--fs-xs);color:var(--text-muted);white-space:nowrap}
.ilp-dl__delta{display:inline-flex;align-items:center;gap:3px;font-size:var(--fs-xs);font-weight:var(--weight-bold);font-variant-numeric:tabular-nums}
.ilp-dl__delta svg{width:12px;height:12px}
.ilp-dl__delta--up{color:var(--il-earth-ink)}
.ilp-dl__delta--down{color:var(--il-red-ink)}
.ilp-dl__delta--flat{color:var(--text-muted)}

.ilp-dl__check{width:17px;height:17px;flex:none;margin:0;accent-color:var(--brand-primary);cursor:pointer}
.ilp-dl__row--done .ilp-dl__ttl{color:var(--text-muted);text-decoration:line-through;text-decoration-thickness:1px}
.ilp-dl__tag{display:inline-flex;align-items:center;height:19px;padding:0 8px;font-size:10px;font-weight:var(--weight-bold);letter-spacing:.03em;border-radius:var(--radius-pill);background:var(--il-grayblue-100);color:var(--text-secondary);flex:none}
.ilp-dl__tag--info{background:var(--il-blue-100);color:var(--il-blue-800)}
.ilp-dl__tag--success{background:var(--il-earth-soft);color:var(--il-earth-ink)}
.ilp-dl__tag--warning{background:var(--il-sun-soft);color:var(--il-sun-ink)}
.ilp-dl__tag--danger{background:var(--il-red-soft);color:var(--il-red-ink)}
.ilp-dl__avatar{width:36px;height:36px;flex:none;border-radius:50%;object-fit:cover;background:var(--il-grayblue-100)}
.ilp-dl__initials{display:grid;place-items:center;width:36px;height:36px;flex:none;border-radius:50%;font-size:var(--fs-xs);font-weight:var(--weight-bold);color:#fff}
`;

function useCSS() {
  React.useEffect(() => {
    if (document.getElementById('ilp-dl-css')) return;
    const s = document.createElement('style');
    s.id = 'ilp-dl-css';
    s.textContent = CSS;
    document.head.appendChild(s);
  }, []);
}

const IcUp = (p) => <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.4" strokeLinecap="round" strokeLinejoin="round" {...p}><path d="M7 17 17 7" /><path d="M9 7h8v8" /></svg>;
const IcDown = (p) => <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.4" strokeLinecap="round" strokeLinejoin="round" {...p}><path d="M7 7l10 10" /><path d="M17 9v8H9" /></svg>;

const TINTS = ['var(--il-blue-500)', 'var(--il-air)', 'var(--il-sun)', 'var(--il-earth)', 'var(--il-grayblue-500)'];
const initials = (n) => n.trim().split(/\s+/).slice(0, 2).map((p) => p[0]?.toUpperCase() || '').join('');
const tint = (n) => TINTS[[...n].reduce((a, c) => a + c.charCodeAt(0), 0) % TINTS.length];

/**
 * The list widget family: ranked lists, people lists, icon lists, checklists.
 * One row model, four leading treatments.
 */
export function DataList({
  items = [],
  variant = 'plain',
  divided = true,
  density,
  compact: compactProp = false,
  inset = false,
  onItemClick,
  onToggle,
  className = '',
  ...rest
}) {
  useCSS();
  const compact = density ? density === 'compact' : compactProp;
  const ranked = variant === 'ranked';
  const check = variant === 'check';

  return (
    <div
      className={'ilp-dl' + (divided ? ' ilp-dl--divided' : '') + (compact ? ' ilp-dl--compact' : '') + (inset ? ' ilp-dl--inset' : '') + (className ? ' ' + className : '')}
      role="list"
      {...rest}
    >
      {items.map((it, i) => {
        const Tag = onItemClick ? 'button' : 'div';
        const dir = it.direction || (it.delta ? (String(it.delta).trim().startsWith('-') || String(it.delta).trim().startsWith('−') ? 'down' : 'up') : 'flat');
        return (
          <Tag
            key={it.id ?? it.title ?? i}
            role="listitem"
            type={Tag === 'button' ? 'button' : undefined}
            className={'ilp-dl__row' + (onItemClick ? ' ilp-dl__row--click' : '') + (it.done ? ' ilp-dl__row--done' : '')}
            onClick={onItemClick ? () => onItemClick(it, i) : undefined}
          >
            {check && (
              <input
                type="checkbox" className="ilp-dl__check" checked={!!it.done}
                onClick={(e) => e.stopPropagation()}
                onChange={() => onToggle && onToggle(it, i)}
                aria-label={it.title}
              />
            )}
            {ranked && <span className={'ilp-dl__rank' + (i < 3 ? ' ilp-dl__rank--' + (i + 1) : '')}>{i + 1}</span>}
            {variant === 'people' && (it.avatar
              ? <img className="ilp-dl__avatar" src={it.avatar} alt="" />
              : <span className="ilp-dl__initials" style={{ background: tint(it.title || '?') }}>{initials(it.title || '?')}</span>)}
            {variant === 'icon' && it.icon && (
              <span className={'ilp-dl__ic' + (it.tone ? ' ilp-dl__ic--' + it.tone : '')}>{it.icon}</span>
            )}
            {variant === 'swatch' && <span className="ilp-dl__sw" style={{ background: it.color }} />}

            <span className="ilp-dl__m">
              <span className="ilp-dl__ttl">
                <span>{it.title}</span>
                {it.tag && <span className={'ilp-dl__tag' + (it.tagTone ? ' ilp-dl__tag--' + it.tagTone : '')}>{it.tag}</span>}
              </span>
              {it.subtitle && <span className="ilp-dl__sub">{it.subtitle}</span>}
              {it.progress != null && (
                <span className="ilp-dl__bar"><i style={{ width: Math.max(0, Math.min(100, it.progress)) + '%', background: it.color || undefined }} /></span>
              )}
            </span>

            {(it.value != null || it.meta || it.delta) && (
              <span className="ilp-dl__end">
                {it.value != null && <span className="ilp-dl__val">{it.value}</span>}
                {it.delta && (
                  <span className={'ilp-dl__delta ilp-dl__delta--' + dir}>
                    {dir === 'up' ? <IcUp /> : dir === 'down' ? <IcDown /> : null}{it.delta}
                  </span>
                )}
                {it.meta && <span className="ilp-dl__meta">{it.meta}</span>}
              </span>
            )}
          </Tag>
        );
      })}
    </div>
  );
}
