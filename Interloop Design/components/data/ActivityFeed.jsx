import React from 'react';

const CSS = `
.ilp-af{display:flex;flex-direction:column;min-height:0;font-family:var(--font-sans);color:var(--text-primary)}
.ilp-af *{box-sizing:border-box}

/* header */
.ilp-af__hd{display:flex;align-items:center;gap:var(--space-3);flex-wrap:wrap;padding-bottom:var(--space-4)}
.ilp-af__title{font-family:var(--font-sans);font-size:var(--fs-lg);font-weight:var(--weight-bold);letter-spacing:-0.01em;margin-right:auto}
.ilp-af__tabs{display:flex;gap:2px;padding:3px;background:var(--il-grayblue-100);border-radius:var(--radius-pill)}
.ilp-af__tab{display:inline-flex;align-items:center;gap:6px;height:28px;padding:0 13px;font:inherit;font-size:var(--fs-sm);font-weight:var(--weight-semibold);color:var(--text-secondary);background:transparent;border:0;border-radius:var(--radius-pill);cursor:pointer;white-space:nowrap;transition:background var(--dur-fast) var(--ease-standard),color var(--dur-fast) var(--ease-standard)}
.ilp-af__tab:hover{color:var(--text-primary)}
.ilp-af__tab[aria-selected="true"]{background:var(--surface-card);color:var(--text-primary);box-shadow:var(--shadow-xs)}
.ilp-af__tab:focus-visible{outline:none;box-shadow:var(--ring)}
.ilp-af__tab i{font-style:normal;font-size:var(--fs-xs);font-weight:var(--weight-bold);color:var(--text-muted);font-variant-numeric:tabular-nums}
.ilp-af__tab[aria-selected="true"] i{color:var(--il-blue-600)}

/* scroll body */
.ilp-af__body{flex:1 1 auto;min-height:0;overflow-y:auto;overscroll-behavior:contain;padding-right:2px}

/* day header */
.ilp-af__day{position:sticky;top:0;z-index:2;display:flex;align-items:center;gap:var(--space-3);padding:6px 0 14px;background:linear-gradient(var(--surface-card) 62%,transparent)}
.ilp-af__daylabel{font-size:var(--fs-xs);font-weight:var(--weight-bold);letter-spacing:.08em;text-transform:uppercase;color:var(--text-muted);white-space:nowrap}
.ilp-af__daylabel--now{color:var(--il-blue-600)}
.ilp-af__dayrule{flex:1;height:1px;background:var(--border-subtle)}
.ilp-af__daycount{font-size:var(--fs-xs);font-weight:var(--weight-semibold);color:var(--text-disabled);font-variant-numeric:tabular-nums}

/* entry */
.ilp-af__list{position:relative;display:flex;flex-direction:column}
.ilp-af__item{position:relative;display:grid;grid-template-columns:34px minmax(0,1fr);gap:var(--space-4);padding:0 0 var(--space-5)}
.ilp-af__item:last-child{padding-bottom:var(--space-2)}
.ilp-af__rail{position:relative;display:flex;justify-content:center}
.ilp-af__rail::before{content:"";position:absolute;top:34px;bottom:-22px;left:50%;width:2px;margin-left:-1px;background:var(--border-subtle)}
.ilp-af__item:last-child .ilp-af__rail::before{display:none}
.ilp-af__node{position:relative;z-index:1;display:grid;place-items:center;width:34px;height:34px;flex:none;border-radius:50%;background:var(--surface-card);border:1px solid var(--border-default);color:var(--text-secondary)}
.ilp-af__node svg{width:15px;height:15px}
.ilp-af__node--info{background:var(--il-blue-100);border-color:var(--il-blue-200);color:var(--il-blue-700)}
.ilp-af__node--success{background:var(--il-earth-soft);border-color:#dcebb4;color:var(--il-earth-ink)}
.ilp-af__node--warning{background:var(--il-sun-soft);border-color:#fbdcc7;color:var(--il-sun-ink)}
.ilp-af__node--danger{background:var(--il-red-soft);border-color:#f8cfcb;color:var(--il-red-ink)}
.ilp-af__node--brand{background:var(--il-air-soft);border-color:#c8e2e2;color:var(--il-air-ink)}
.ilp-af__node img{width:100%;height:100%;border-radius:50%;object-fit:cover}

.ilp-af__main{min-width:0;padding-top:5px}
.ilp-af__line{display:flex;align-items:baseline;gap:6px;flex-wrap:wrap;font-size:var(--fs-sm);line-height:1.5;color:var(--text-secondary)}
.ilp-af__who{font-weight:var(--weight-bold);color:var(--text-primary)}
.ilp-af__target{font-weight:var(--weight-semibold);color:var(--text-link);text-decoration:none}
.ilp-af__target:hover{color:var(--il-blue-800);text-decoration:underline}
.ilp-af__when{margin-left:auto;padding-left:var(--space-3);font-size:var(--fs-xs);color:var(--text-muted);white-space:nowrap}
.ilp-af__role{font-size:var(--fs-xs);color:var(--text-muted)}

/* payloads */
.ilp-af__quote{margin-top:9px;padding:11px 14px;font-size:var(--fs-sm);line-height:1.55;color:var(--text-primary);background:var(--il-grayblue-50);border:1px solid var(--border-subtle);border-radius:var(--radius-md);text-wrap:pretty}
.ilp-af__quote em{color:var(--text-secondary);font-style:normal}
.ilp-af__change{display:inline-flex;align-items:center;gap:8px;margin-top:9px;padding:6px 10px;background:var(--surface-card);border:1px solid var(--border-subtle);border-radius:var(--radius-md)}
.ilp-af__change svg{width:14px;height:14px;color:var(--text-disabled)}
.ilp-af__pill{display:inline-flex;align-items:center;height:22px;padding:0 10px;font-size:var(--fs-xs);font-weight:var(--weight-semibold);border-radius:var(--radius-pill);background:var(--il-grayblue-100);color:var(--text-secondary);white-space:nowrap}
.ilp-af__pill--info{background:var(--il-blue-100);color:var(--il-blue-800)}
.ilp-af__pill--success{background:var(--il-earth-soft);color:var(--il-earth-ink)}
.ilp-af__pill--warning{background:var(--il-sun-soft);color:var(--il-sun-ink)}
.ilp-af__pill--danger{background:var(--il-red-soft);color:var(--il-red-ink)}
.ilp-af__pill--old{opacity:.75;text-decoration:line-through;text-decoration-thickness:1px}

.ilp-af__files{display:flex;flex-wrap:wrap;gap:8px;margin-top:9px}
.ilp-af__file{display:inline-flex;align-items:center;gap:9px;padding:7px 12px 7px 8px;background:var(--surface-card);border:1px solid var(--border-default);border-radius:var(--radius-md);text-decoration:none;transition:border-color var(--dur-fast) var(--ease-standard),box-shadow var(--dur-fast) var(--ease-standard)}
.ilp-af__file:hover{border-color:var(--il-blue-300);box-shadow:var(--shadow-xs)}
.ilp-af__ext{display:grid;place-items:center;width:26px;height:26px;flex:none;font-size:9px;font-weight:var(--weight-bold);letter-spacing:.02em;color:#fff;background:var(--il-grayblue-400);border-radius:var(--radius-sm);text-transform:uppercase}
.ilp-af__ext--pdf{background:var(--il-red)}
.ilp-af__ext--img{background:var(--il-air)}
.ilp-af__ext--xls{background:var(--il-earth-ink)}
.ilp-af__fmeta{display:flex;flex-direction:column;gap:1px;min-width:0}
.ilp-af__fname{font-size:var(--fs-xs);font-weight:var(--weight-semibold);color:var(--text-primary);white-space:nowrap;overflow:hidden;text-overflow:ellipsis;max-width:170px}
.ilp-af__fsize{font-size:10px;color:var(--text-muted)}

.ilp-af__stats{display:flex;flex-wrap:wrap;gap:var(--space-5);margin-top:11px;padding:11px 14px;background:var(--il-grayblue-50);border-radius:var(--radius-md)}
.ilp-af__stat{display:flex;flex-direction:column;gap:2px}
.ilp-af__stat span{font-size:10px;font-weight:var(--weight-bold);letter-spacing:.07em;text-transform:uppercase;color:var(--text-muted)}
.ilp-af__stat b{font-size:var(--fs-base);font-weight:var(--weight-bold);font-variant-numeric:tabular-nums}
.ilp-af__stat b.up{color:var(--il-earth-ink)}
.ilp-af__stat b.down{color:var(--il-red-ink)}

.ilp-af__tags{display:flex;flex-wrap:wrap;gap:6px;margin-top:9px}
.ilp-af__tag{display:inline-flex;align-items:center;height:21px;padding:0 9px;font-size:var(--fs-xs);font-weight:var(--weight-semibold);color:var(--text-secondary);background:var(--surface-card);border:1px solid var(--border-default);border-radius:var(--radius-pill)}

.ilp-af__acts{display:flex;gap:8px;margin-top:11px}
.ilp-af__act{height:30px;padding:0 13px;font:inherit;font-size:var(--fs-xs);font-weight:var(--weight-bold);color:var(--text-secondary);background:var(--surface-card);border:1px solid var(--border-default);border-radius:var(--radius-md);cursor:pointer;transition:background var(--dur-fast) var(--ease-standard),color var(--dur-fast) var(--ease-standard)}
.ilp-af__act:hover{background:var(--surface-hover);color:var(--text-primary);border-color:var(--border-strong)}
.ilp-af__act--primary{color:#fff;background:var(--brand-primary);border-color:var(--brand-primary)}
.ilp-af__act--primary:hover{background:var(--brand-primary-hover);color:#fff;border-color:var(--brand-primary-hover)}

/* footer / states */
.ilp-af__more{display:flex;justify-content:center;padding:var(--space-4) 0 var(--space-2)}
.ilp-af__more button{height:36px;padding:0 20px;font:inherit;font-size:var(--fs-sm);font-weight:var(--weight-bold);color:var(--text-secondary);background:var(--surface-card);border:1px solid var(--border-default);border-radius:var(--radius-pill);cursor:pointer;transition:background var(--dur-fast) var(--ease-standard)}
.ilp-af__more button:hover:not(:disabled){background:var(--surface-hover);color:var(--text-primary);border-color:var(--border-strong)}
.ilp-af__more button:disabled{opacity:.6;cursor:default}
.ilp-af__end{padding:var(--space-4) 0;text-align:center;font-size:var(--fs-xs);color:var(--text-disabled)}
.ilp-af__empty{display:flex;flex-direction:column;align-items:center;gap:8px;padding:56px 20px;text-align:center;color:var(--text-muted)}
.ilp-af__empty svg{width:26px;height:26px;color:var(--text-disabled)}
.ilp-af__empty b{font-size:var(--fs-base);color:var(--text-secondary)}
.ilp-af__empty span{font-size:var(--fs-sm);max-width:34ch}

/* skeleton */
.ilp-af__sk{display:grid;grid-template-columns:34px minmax(0,1fr);gap:var(--space-4);padding-bottom:var(--space-5)}
.ilp-af__skd,.ilp-af__skl{background:var(--il-grayblue-100);border-radius:var(--radius-sm);animation:ilp-af-pulse 1.3s var(--ease-standard) infinite}
.ilp-af__skd{width:34px;height:34px;border-radius:50%}
.ilp-af__skl{height:11px;margin-bottom:8px}
@keyframes ilp-af-pulse{50%{opacity:.45}}

/* dense */
.ilp-af--dense .ilp-af__item{grid-template-columns:26px minmax(0,1fr);gap:var(--space-3);padding-bottom:var(--space-4)}
.ilp-af--dense .ilp-af__node{width:26px;height:26px}
.ilp-af--dense .ilp-af__node svg{width:12px;height:12px}
.ilp-af--dense .ilp-af__rail::before{top:26px;bottom:-18px}
.ilp-af--dense .ilp-af__main{padding-top:3px}
`;

function useCSS() {
  React.useEffect(() => {
    if (document.getElementById('ilp-af-css')) return;
    const s = document.createElement('style');
    s.id = 'ilp-af-css';
    s.textContent = CSS;
    document.head.appendChild(s);
  }, []);
}

const I = (d) => (p) => (
  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true" {...p}>
    {d.map((x, i) => <path key={i} d={x} />)}
  </svg>
);
const IcComment = I(['M21 12a8 8 0 0 1-8 8H7l-4 3v-7.5A8 8 0 0 1 11 4h2a8 8 0 0 1 8 8Z']);
const IcUpload = I(['M12 16V4', 'm7 9 5-5 5 5', 'M4 20h16']);
const IcCheck = I(['m4 12.5 5 5L20 6.5']);
const IcX = I(['M6 6l12 12', 'M18 6 6 18']);
const IcArrow = I(['M4 12h15', 'm13 6 6 6-6 6']);
const IcAt = I(['M16 12a4 4 0 1 1-4-4', 'M16 8v5a3 3 0 0 0 5 2.2A9 9 0 1 0 17 20']);
const IcFlag = I(['M5 21V4', 'M5 5h13l-2.5 4L18 13H5']);
const IcCog = I(['M12 15.2a3.2 3.2 0 1 0 0-6.4 3.2 3.2 0 0 0 0 6.4Z', 'M19.4 14.6a1.6 1.6 0 0 0 .3 1.8l.1.1a2 2 0 1 1-2.8 2.8l-.1-.1a1.6 1.6 0 0 0-2.7 1.1V21a2 2 0 1 1-4 0v-.1a1.6 1.6 0 0 0-2.8-1.1l-.1.1a2 2 0 1 1-2.8-2.8l.1-.1A1.6 1.6 0 0 0 3.5 14H3a2 2 0 1 1 0-4h.1a1.6 1.6 0 0 0 1.1-2.8l-.1-.1a2 2 0 1 1 2.8-2.8l.1.1A1.6 1.6 0 0 0 10 3.5V3a2 2 0 1 1 4 0v.1a1.6 1.6 0 0 0 2.7 1.1l.1-.1a2 2 0 1 1 2.8 2.8l-.1.1a1.6 1.6 0 0 0 1.1 2.7h.4a2 2 0 1 1 0 4h-.1a1.6 1.6 0 0 0-1.5 1Z']);
const IcAlert = I(['M12 4.5 2.5 20h19L12 4.5Z', 'M12 10v4.5', 'M12 17.6v.1']);
const IcClock = I(['M12 21a9 9 0 1 0 0-18 9 9 0 0 0 0 18Z', 'M12 7.5V12l3 2']);
const IcInbox = I(['M3 5h18v14H3z', 'M3 13h5l1.5 2.5h5L16 13h5']);

const TYPES = {
  comment:  { icon: IcComment, tone: 'info' },
  mention:  { icon: IcAt,      tone: 'info' },
  upload:   { icon: IcUpload,  tone: 'neutral' },
  approval: { icon: IcCheck,   tone: 'success' },
  rejected: { icon: IcX,       tone: 'danger' },
  status:   { icon: IcArrow,   tone: 'brand' },
  flag:     { icon: IcFlag,    tone: 'warning' },
  alert:    { icon: IcAlert,   tone: 'danger' },
  schedule: { icon: IcClock,   tone: 'neutral' },
  system:   { icon: IcCog,     tone: 'neutral' },
};

const EXT_KIND = { pdf: 'pdf', png: 'img', jpg: 'img', jpeg: 'img', webp: 'img', xlsx: 'xls', xls: 'xls', csv: 'xls' };
const sameDay = (a, b) => a.toDateString() === b.toDateString();

function dayLabel(d, now) {
  if (sameDay(d, now)) return 'Today';
  const y = new Date(now); y.setDate(y.getDate() - 1);
  if (sameDay(d, y)) return 'Yesterday';
  const opts = d.getFullYear() === now.getFullYear()
    ? { weekday: 'short', month: 'short', day: 'numeric' }
    : { month: 'short', day: 'numeric', year: 'numeric' };
  return d.toLocaleDateString('en-US', opts);
}

function timeLabel(d, now) {
  const mins = Math.round((now - d) / 60000);
  if (mins < 1) return 'just now';
  if (mins < 60) return mins + 'm ago';
  if (sameDay(d, now)) return Math.round(mins / 60) + 'h ago';
  return d.toLocaleTimeString('en-US', { hour: 'numeric', minute: '2-digit' });
}

/** Date-grouped activity timeline: comments, uploads, status changes, approvals, alerts. */
export function ActivityFeed({
  items = [],
  title,
  tabs = null,
  activeTab,
  onTabChange,
  now = new Date(),
  groupByDay = true,
  density,
  dense: denseProp = false,
  showActor = true,
  hasMore = false,
  loading = false,
  onLoadMore,
  onItemAction,
  endMessage = 'You have reached the beginning of this activity log.',
  emptyTitle = 'Nothing here yet',
  emptyMessage = 'Activity on this record will appear as your team works on it.',
  maxHeight,
  className = '',
  ...rest
}) {
  useCSS();
  const dense = density ? density === 'compact' : denseProp;
  const [tab, setTab] = React.useState(activeTab ?? (tabs && tabs[0] ? tabs[0].id : 'all'));
  const current = activeTab ?? tab;
  const pick = (id) => { setTab(id); onTabChange && onTabChange(id); };

  const shown = React.useMemo(() => {
    const list = [...items].sort((a, b) => new Date(b.time) - new Date(a.time));
    if (!tabs || current === 'all' || activeTab !== undefined) return list;
    const def = tabs.find((t) => t.id === current);
    if (!def || !def.types) return list;
    return list.filter((i) => def.types.includes(i.type));
  }, [items, tabs, current, activeTab]);

  const groups = React.useMemo(() => {
    if (!groupByDay) return [{ key: 'all', label: null, items: shown }];
    const map = new Map();
    for (const it of shown) {
      const d = new Date(it.time);
      const k = d.toDateString();
      if (!map.has(k)) map.set(k, { key: k, date: d, items: [] });
      map.get(k).items.push(it);
    }
    return [...map.values()].map((g) => ({ ...g, label: dayLabel(g.date, now) }));
  }, [shown, groupByDay, now]);

  return (
    <div className={'ilp-af' + (dense ? ' ilp-af--dense' : '') + (className ? ' ' + className : '')} {...rest} style={{ ...(maxHeight ? { maxHeight, height: maxHeight } : null), ...(rest.style || {}) }}>
      {(title || tabs) && (
        <div className="ilp-af__hd">
          {title && <h3 className="ilp-af__title">{title}</h3>}
          {tabs && (
            <div className="ilp-af__tabs" role="tablist">
              {tabs.map((t) => (
                <button key={t.id} type="button" className="ilp-af__tab" role="tab" aria-selected={current === t.id} onClick={() => pick(t.id)}>
                  {t.label}{t.count != null && <i>{t.count}</i>}
                </button>
              ))}
            </div>
          )}
        </div>
      )}

      <div className="ilp-af__body">
        {loading && shown.length === 0 ? (
          [0, 1, 2, 3].map((i) => (
            <div className="ilp-af__sk" key={i}>
              <div className="ilp-af__skd" />
              <div>
                <div className="ilp-af__skl" style={{ width: '62%' }} />
                <div className="ilp-af__skl" style={{ width: '38%' }} />
              </div>
            </div>
          ))
        ) : shown.length === 0 ? (
          <div className="ilp-af__empty"><IcInbox /><b>{emptyTitle}</b><span>{emptyMessage}</span></div>
        ) : (
          groups.map((g) => (
            <section key={g.key}>
              {g.label && (
                <header className="ilp-af__day">
                  <span className={'ilp-af__daylabel' + (g.label === 'Today' ? ' ilp-af__daylabel--now' : '')}>{g.label}</span>
                  <span className="ilp-af__dayrule" />
                  <span className="ilp-af__daycount">{g.items.length}</span>
                </header>
              )}
              <div className="ilp-af__list">
                {g.items.map((it) => {
                  const def = TYPES[it.type] || TYPES.system;
                  const Icon = def.icon;
                  const tone = it.tone || def.tone;
                  const avatar = showActor && it.actor && it.actor.src;
                  return (
                    <article className="ilp-af__item" key={it.id}>
                      <div className="ilp-af__rail">
                        <span className={'ilp-af__node' + (tone && tone !== 'neutral' ? ' ilp-af__node--' + tone : '')}>
                          {avatar ? <img src={it.actor.src} alt="" /> : <Icon />}
                        </span>
                      </div>
                      <div className="ilp-af__main">
                        <div className="ilp-af__line">
                          {it.actor && <span className="ilp-af__who">{it.actor.name}</span>}
                          <span>{it.action}</span>
                          {it.target && (it.targetHref
                            ? <a className="ilp-af__target" href={it.targetHref}>{it.target}</a>
                            : <span className="ilp-af__target">{it.target}</span>)}
                          {it.actor?.role && <span className="ilp-af__role">· {it.actor.role}</span>}
                          <time className="ilp-af__when" dateTime={new Date(it.time).toISOString()}>{timeLabel(new Date(it.time), now)}</time>
                        </div>

                        {it.body && <div className="ilp-af__quote">{it.body}</div>}

                        {(it.from || it.to) && (
                          <div className="ilp-af__change">
                            {it.from && <span className={'ilp-af__pill ilp-af__pill--old' + (it.fromTone ? ' ilp-af__pill--' + it.fromTone : '')}>{it.from}</span>}
                            <IcArrow />
                            {it.to && <span className={'ilp-af__pill' + (it.toTone ? ' ilp-af__pill--' + it.toTone : '')}>{it.to}</span>}
                          </div>
                        )}

                        {it.stats && (
                          <div className="ilp-af__stats">
                            {it.stats.map((s) => (
                              <div className="ilp-af__stat" key={s.label}>
                                <span>{s.label}</span><b className={s.trend || ''}>{s.value}</b>
                              </div>
                            ))}
                          </div>
                        )}

                        {it.attachments && (
                          <div className="ilp-af__files">
                            {it.attachments.map((f) => {
                              const ext = (f.name.split('.').pop() || '').toLowerCase();
                              return (
                                <a className="ilp-af__file" href={f.href || '#'} key={f.name}>
                                  <span className={'ilp-af__ext ilp-af__ext--' + (EXT_KIND[ext] || 'doc')}>{ext.slice(0, 3)}</span>
                                  <span className="ilp-af__fmeta">
                                    <span className="ilp-af__fname">{f.name}</span>
                                    {f.size && <span className="ilp-af__fsize">{f.size}</span>}
                                  </span>
                                </a>
                              );
                            })}
                          </div>
                        )}

                        {it.tags && <div className="ilp-af__tags">{it.tags.map((t) => <span className="ilp-af__tag" key={t}>{t}</span>)}</div>}

                        {it.actions && (
                          <div className="ilp-af__acts">
                            {it.actions.map((a) => (
                              <button
                                key={a.id} type="button"
                                className={'ilp-af__act' + (a.primary ? ' ilp-af__act--primary' : '')}
                                onClick={() => onItemAction && onItemAction(a.id, it)}
                              >{a.label}</button>
                            ))}
                          </div>
                        )}
                      </div>
                    </article>
                  );
                })}
              </div>
            </section>
          ))
        )}

        {shown.length > 0 && (hasMore
          ? <div className="ilp-af__more"><button type="button" disabled={loading} onClick={onLoadMore}>{loading ? 'Loading…' : 'Load earlier activity'}</button></div>
          : endMessage && <div className="ilp-af__end">{endMessage}</div>)}
      </div>
    </div>
  );
}
