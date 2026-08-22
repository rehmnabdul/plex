import React from 'react';

const CSS = `
.ilp-gt{display:flex;flex-direction:column;min-height:0;background:var(--surface-card);border:1px solid var(--border-default);border-radius:var(--radius-lg);box-shadow:var(--shadow-sm);font-family:var(--font-sans);color:var(--text-primary);overflow:hidden;position:relative}
.ilp-gt *{box-sizing:border-box}

/* toolbar */
.ilp-gt__tools{display:flex;flex:none;align-items:center;gap:10px;flex-wrap:wrap;padding:11px 14px;border-bottom:1px solid var(--border-default);min-height:56px}
.ilp-gt__ttl{font-size:var(--fs-base);font-weight:var(--weight-bold);letter-spacing:-0.01em;margin-right:auto}
.ilp-gt__ttl span{display:block;margin-top:2px;font-size:var(--fs-xs);font-weight:var(--weight-regular);color:var(--text-muted)}
.ilp-gt__seg{display:flex;gap:2px;padding:3px;background:var(--il-grayblue-100);border-radius:var(--radius-md)}
.ilp-gt__seg button{height:26px;padding:0 12px;font:inherit;font-size:var(--fs-xs);font-weight:var(--weight-semibold);color:var(--text-secondary);background:transparent;border:0;border-radius:var(--radius-sm);cursor:pointer}
.ilp-gt__seg button[aria-pressed="true"]{background:var(--surface-card);color:var(--text-primary);box-shadow:var(--shadow-xs)}
.ilp-gt__seg button:focus-visible{outline:none;box-shadow:var(--ring)}

/* body */
.ilp-gt__body{display:flex;flex:1 1 auto;min-height:0}
.ilp-gt__pane{display:flex;flex-direction:column;flex:none;border-right:1px solid var(--border-default);background:var(--surface-card);z-index:3}
.ilp-gt__scroll{flex:1 1 auto;min-width:0;overflow:auto;position:relative}
.ilp-gt__canvas{position:relative}

/* headers */
.ilp-gt__hd{position:sticky;top:0;z-index:4;flex:none;background:var(--il-grayblue-50);border-bottom:1px solid var(--border-strong)}
.ilp-gt__hcol{display:flex;align-items:center;height:100%;padding:0 12px;font-size:10px;font-weight:var(--weight-bold);letter-spacing:.07em;text-transform:uppercase;color:var(--text-muted)}
.ilp-gt__tick{position:absolute;top:0;display:flex;align-items:center;justify-content:center;font-size:10px;font-weight:var(--weight-bold);color:var(--text-secondary);border-left:1px solid var(--border-subtle);white-space:nowrap;overflow:hidden}
.ilp-gt__tick--major{font-size:11px;letter-spacing:.05em;text-transform:uppercase;color:var(--text-muted);justify-content:flex-start;padding-left:9px;border-left-color:var(--border-default)}
.ilp-gt__tick--off{color:var(--text-disabled)}

/* rows */
.ilp-gt__row{display:flex;align-items:center;gap:9px;padding:0 12px;border-bottom:1px solid var(--border-subtle);white-space:nowrap;overflow:hidden;background:var(--surface-card)}
.ilp-gt__row--group{background:var(--il-grayblue-50);font-weight:var(--weight-bold)}
.ilp-gt__row--on{background:var(--il-blue-50)}
.ilp-gt__row button.tw{display:grid;place-items:center;width:18px;height:18px;flex:none;padding:0;color:var(--text-muted);background:none;border:0;border-radius:var(--radius-xs);cursor:pointer}
.ilp-gt__row button.tw:hover{background:var(--il-grayblue-200);color:var(--text-primary)}
.ilp-gt__row button.tw svg{width:13px;height:13px;transition:transform var(--dur-fast) var(--ease-standard)}
.ilp-gt__row button.tw svg.open{transform:rotate(90deg)}
.ilp-gt__nm{flex:1 1 auto;min-width:0;font-size:var(--fs-sm);overflow:hidden;text-overflow:ellipsis}
.ilp-gt__nm em{display:block;font-style:normal;font-size:var(--fs-xs);font-weight:var(--weight-regular);color:var(--text-muted);overflow:hidden;text-overflow:ellipsis}
.ilp-gt__meta{flex:none;font-size:var(--fs-xs);font-variant-numeric:tabular-nums;color:var(--text-muted)}
.ilp-gt__crit{width:6px;height:6px;flex:none;border-radius:50%;background:var(--status-danger)}

/* lanes */
.ilp-gt__lane{position:absolute;left:0;right:0;border-bottom:1px solid var(--border-subtle)}
.ilp-gt__lane--group{background:var(--il-grayblue-50)}
.ilp-gt__lane--on{background:var(--il-blue-50)}
.ilp-gt__grid{position:absolute;top:0;bottom:0;width:1px;background:var(--border-subtle)}
.ilp-gt__grid--major{background:var(--border-default)}
.ilp-gt__off{position:absolute;top:0;bottom:0;background:var(--il-grayblue-50);opacity:.7}
.ilp-gt__today{position:absolute;top:0;bottom:0;width:2px;background:var(--status-danger);z-index:5;pointer-events:none}
.ilp-gt__today::after{content:"TODAY";position:absolute;top:2px;left:4px;font-size:9px;font-weight:var(--weight-bold);letter-spacing:.08em;color:var(--status-danger)}

/* bars */
.ilp-gt__bar{position:absolute;border-radius:4px;cursor:pointer;transition:filter var(--dur-fast) var(--ease-standard)}
.ilp-gt__bar:hover{filter:brightness(1.06)}
.ilp-gt__bar:focus-visible{outline:none;box-shadow:var(--ring)}
.ilp-gt__fill{position:absolute;left:0;top:0;bottom:0;border-radius:4px 0 0 4px;background:rgba(255,255,255,.4)}
.ilp-gt__blabel{position:absolute;top:50%;transform:translateY(-50%);left:calc(100% + 8px);font-size:var(--fs-xs);font-weight:var(--weight-semibold);color:var(--text-secondary);white-space:nowrap;pointer-events:none}
.ilp-gt__inlabel{position:absolute;inset:0;display:flex;align-items:center;padding:0 8px;font-size:11px;font-weight:var(--weight-bold);color:#fff;white-space:nowrap;overflow:hidden;pointer-events:none}
.ilp-gt__base{position:absolute;height:4px;border-radius:2px;background:var(--il-grayblue-300);opacity:.75}
.ilp-gt__sum{position:absolute;height:9px;border-radius:2px;background:var(--il-grayblue-600)}
.ilp-gt__sum::before,.ilp-gt__sum::after{content:"";position:absolute;top:100%;border:5px solid transparent;border-top-color:var(--il-grayblue-600)}
.ilp-gt__sum::before{left:0}
.ilp-gt__sum::after{right:0}
.ilp-gt__ms{position:absolute;width:15px;height:15px;transform:rotate(45deg);border-radius:2px;cursor:pointer}
.ilp-gt__dep{position:absolute;inset:0;pointer-events:none;overflow:visible}
.ilp-gt__dep path{fill:none;stroke:var(--il-grayblue-400);stroke-width:1.4}
.ilp-gt__dep path.crit{stroke:var(--status-danger);stroke-width:1.8}
.ilp-gt__dep polygon{fill:var(--il-grayblue-400)}
.ilp-gt__dep polygon.crit{fill:var(--status-danger)}

/* tooltip + legend */
.ilp-gt__tip{position:fixed;z-index:900;min-width:190px;padding:10px 12px;background:var(--surface-card);border:1px solid var(--border-default);border-radius:var(--radius-md);box-shadow:var(--shadow-lg);pointer-events:none;font-size:var(--fs-xs);line-height:1.55}
.ilp-gt__tip b{display:block;padding-bottom:6px;margin-bottom:6px;border-bottom:1px solid var(--border-subtle);font-size:var(--fs-sm);font-weight:var(--weight-bold);color:var(--text-primary)}
.ilp-gt__tip div{display:flex;gap:14px}
.ilp-gt__tip span{color:var(--text-muted)}
.ilp-gt__tip em{margin-left:auto;font-style:normal;font-weight:var(--weight-bold);font-variant-numeric:tabular-nums;color:var(--text-primary)}
.ilp-gt__foot{display:flex;flex:none;align-items:center;gap:16px;flex-wrap:wrap;padding:9px 14px;border-top:1px solid var(--border-default);font-size:var(--fs-xs);color:var(--text-muted)}
.ilp-gt__key{display:inline-flex;align-items:center;gap:6px}
.ilp-gt__key i{width:14px;height:9px;border-radius:2px;flex:none}
.ilp-gt__key i.ms{width:11px;height:11px;border-radius:2px;transform:rotate(45deg)}
`;

function useCSS() {
  React.useEffect(() => {
    if (document.getElementById('ilp-gantt-css')) return;
    const s = document.createElement('style');
    s.id = 'ilp-gantt-css';
    s.textContent = CSS;
    document.head.appendChild(s);
  }, []);
}

const IcChev = (p) => <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.4" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true" {...p}><path d="M9 5l7 7-7 7" /></svg>;

const DAY = 86400000;
const d = (v) => (v instanceof Date ? v : new Date(v));
const days = (a, b) => Math.round((d(b) - d(a)) / DAY);
const addDays = (v, n) => new Date(d(v).getTime() + n * DAY);
const fmtDate = (v) => d(v).toLocaleDateString('en-GB', { day: '2-digit', month: 'short' });
const MONTH = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

const STATUS = {
  done: 'var(--il-earth)',
  active: 'var(--brand-primary)',
  planned: 'var(--il-grayblue-300)',
  late: 'var(--status-danger)',
  risk: 'var(--il-sun)',
  blocked: 'var(--il-grayblue-500)',
};

const SCALE = { day: 34, week: 15, month: 4.4 };

/**
 * Gantt chart: scheduled bars against a time axis, with dependencies,
 * baselines, milestones, roll-up phases and a today marker.
 */
export function GanttChart({
  tasks = [],
  scale: scaleProp = 'week',
  scales = ['day', 'week', 'month'],
  start,
  end,
  today = new Date(),
  title,
  subtitle,
  actions = null,
  taskPaneWidth = 300,
  rowHeight = 38,
  height = 520,
  showDependencies = true,
  showBaseline = true,
  showToday = true,
  showLegend = true,
  showToolbar = true,
  onTaskClick,
  className = '',
  ...rest
}) {
  useCSS();
  const [scale, setScale] = React.useState(scaleProp);
  const [closed, setClosed] = React.useState(() => new Set());
  const [sel, setSel] = React.useState(null);
  const [tip, setTip] = React.useState(null);
  const scrollRef = React.useRef(null);
  const paneRef = React.useRef(null);

  /* ---- rows: groups then their children, honouring collapse ---- */
  const rows = React.useMemo(() => {
    const kids = new Map();
    for (const t of tasks) if (t.parentId) (kids.get(t.parentId) || kids.set(t.parentId, []).get(t.parentId)).push(t);
    const out = [];
    for (const t of tasks) {
      if (t.parentId) continue;
      const children = kids.get(t.id) || [];
      out.push({ ...t, depth: 0, isGroup: children.length > 0, open: !closed.has(t.id), childIds: children.map((c) => c.id) });
      if (children.length && !closed.has(t.id)) for (const c of children) out.push({ ...c, depth: 1, isGroup: false });
    }
    return out;
  }, [tasks, closed]);

  /* ---- range ---- */
  const dates = tasks.flatMap((t) => [t.start, t.end, t.baselineStart, t.baselineEnd].filter(Boolean).map(d));
  const min = start ? d(start) : new Date(Math.min(...dates.map((x) => x.getTime())));
  const max = end ? d(end) : new Date(Math.max(...dates.map((x) => x.getTime())));
  const from = addDays(min, -2);
  const to = addDays(max, 3);
  const span = Math.max(1, days(from, to));
  const dayW = SCALE[scale];
  const W = span * dayW;
  const x = (v) => days(from, v) * dayW;

  /* ---- axis ticks ---- */
  const ticks = React.useMemo(() => {
    const minor = [];
    const major = [];
    let cursor = new Date(from);
    while (cursor <= to) {
      const left = x(cursor);
      if (scale === 'day') {
        const wknd = cursor.getDay() === 0 || cursor.getDay() === 6;
        minor.push({ left, w: dayW, label: String(cursor.getDate()), off: wknd });
        if (cursor.getDate() === 1 || left === 0) major.push({ left, label: `${MONTH[cursor.getMonth()]} ${cursor.getFullYear()}` });
        cursor = addDays(cursor, 1);
      } else if (scale === 'week') {
        minor.push({ left, w: dayW * 7, label: fmtDate(cursor) });
        if (cursor.getDate() <= 7) major.push({ left, label: `${MONTH[cursor.getMonth()]} ${cursor.getFullYear()}` });
        cursor = addDays(cursor, 7);
      } else {
        const next = new Date(cursor.getFullYear(), cursor.getMonth() + 1, 1);
        minor.push({ left, w: (days(cursor, next)) * dayW, label: MONTH[cursor.getMonth()] });
        if (cursor.getMonth() === 0 || left === 0) major.push({ left, label: String(cursor.getFullYear()) });
        cursor = next;
      }
    }
    return { minor, major };
  }, [from, to, scale, dayW]);

  const rowIndex = new Map(rows.map((r, i) => [r.id, i]));
  const barTop = (i) => i * rowHeight + (rowHeight - 16) / 2;

  const rollup = (r) => {
    if (!r.isGroup) return null;
    const kids = tasks.filter((t) => r.childIds.includes(t.id));
    if (!kids.length) return null;
    return {
      s: new Date(Math.min(...kids.map((k) => d(k.start).getTime()))),
      e: new Date(Math.max(...kids.map((k) => d(k.end || k.start).getTime()))),
    };
  };

  const deps = React.useMemo(() => {
    if (!showDependencies) return [];
    const out = [];
    for (const r of rows) {
      for (const fromId of r.dependsOn || []) {
        const a = rows.find((q) => q.id === fromId);
        if (!a) continue;
        const ai = rowIndex.get(a.id);
        const bi = rowIndex.get(r.id);
        const ax = x(a.end || a.start) + (a.milestone ? 8 : 0);
        const ay = barTop(ai) + 8;
        const bx = x(r.start);
        const by = barTop(bi) + 8;
        const mid = Math.max(ax + 10, bx - 12);
        out.push({
          key: `${a.id}-${r.id}`,
          crit: r.critical || a.critical,
          d: `M${ax},${ay} H${mid} V${by} H${bx - 6}`,
          tip: [bx - 6, by],
        });
      }
    }
    return out;
  }, [rows, showDependencies, dayW, scale, closed]);

  const bodyH = rows.length * rowHeight;
  const todayX = showToday ? x(today) : null;

  /* Open on now, not on the start of the plan — a finished April is not what
     anyone came to read. Re-runs on zoom, since today's pixel moves with it. */
  React.useEffect(() => {
    const el = scrollRef.current;
    if (!el) return;
    const active = rows.find((r) => r.status === 'active');
    const target = showToday ? x(today) : x(active ? active.start : from);
    el.scrollLeft = Math.max(0, target - el.clientWidth / 3);
  }, [scale, showToday]);

  return (
    <div className={'ilp-gt' + (className ? ' ' + className : '')} {...rest} style={{ height, ...(rest.style || {}) }}>
      {showToolbar && (title || actions || scales.length > 1) && (
        <div className="ilp-gt__tools">
          {title && <div className="ilp-gt__ttl">{title}{subtitle && <span>{subtitle}</span>}</div>}
          {!title && <span style={{ marginRight: 'auto' }} />}
          {actions}
          {scales.length > 1 && (
            <div className="ilp-gt__seg">
              {scales.map((s) => (
                <button key={s} type="button" aria-pressed={scale === s} onClick={() => setScale(s)}>
                  {s[0].toUpperCase() + s.slice(1)}
                </button>
              ))}
            </div>
          )}
        </div>
      )}

      <div className="ilp-gt__body">
        {/* task pane */}
        <div className="ilp-gt__pane" style={{ width: taskPaneWidth }}>
          <div className="ilp-gt__hd" style={{ height: 52 }}>
            <div className="ilp-gt__hcol" style={{ height: 52 }}>Task</div>
          </div>
          <div ref={paneRef} style={{ flex: 1, overflow: 'hidden' }}>
            {rows.map((r, i) => (
              <div
                key={r.id}
                className={'ilp-gt__row' + (r.isGroup ? ' ilp-gt__row--group' : '') + (sel === r.id ? ' ilp-gt__row--on' : '')}
                style={{ height: rowHeight, paddingLeft: 12 + r.depth * 16 }}
                onMouseEnter={() => setSel(r.id)}
                onMouseLeave={() => setSel(null)}
                onClick={() => onTaskClick && onTaskClick(r)}
              >
                {r.isGroup ? (
                  <button
                    type="button" className="tw" aria-label={(r.open ? 'Collapse ' : 'Expand ') + r.name}
                    aria-expanded={r.open}
                    onClick={(e) => {
                      e.stopPropagation();
                      setClosed((c) => { const n = new Set(c); n.has(r.id) ? n.delete(r.id) : n.add(r.id); return n; });
                    }}
                  ><IcChev className={r.open ? 'open' : ''} /></button>
                ) : <span style={{ width: r.depth ? 0 : 18, flex: 'none' }} />}
                {r.critical && <span className="ilp-gt__crit" title="On the critical path" />}
                <span className="ilp-gt__nm">{r.name}{r.meta && <em>{r.meta}</em>}</span>
                {r.progress != null && !r.isGroup && <span className="ilp-gt__meta">{r.progress}%</span>}
              </div>
            ))}
            <div style={{ height: 14 }} aria-hidden="true" />
          </div>
        </div>

        {/* timeline */}
        <div
          className="ilp-gt__scroll" ref={scrollRef}
          onScroll={(e) => { if (paneRef.current) paneRef.current.scrollTop = e.currentTarget.scrollTop; }}
        >
          <div className="ilp-gt__canvas" style={{ width: W, height: bodyH + 52 }}>
            <div className="ilp-gt__hd" style={{ height: 52, width: W, position: 'sticky', top: 0 }}>
              {ticks.major.map((t) => (
                <div key={'M' + t.left} className="ilp-gt__tick ilp-gt__tick--major" style={{ left: t.left, height: 26, width: 220 }}>{t.label}</div>
              ))}
              {ticks.minor.map((t) => (
                <div key={'m' + t.left} className={'ilp-gt__tick' + (t.off ? ' ilp-gt__tick--off' : '')} style={{ left: t.left, top: 26, height: 26, width: t.w }}>{t.label}</div>
              ))}
            </div>

            <div style={{ position: 'relative', height: bodyH }}>
              {scale === 'day' && ticks.minor.filter((t) => t.off).map((t) => (
                <div key={'o' + t.left} className="ilp-gt__off" style={{ left: t.left, width: t.w }} />
              ))}
              {ticks.minor.map((t) => <div key={'g' + t.left} className="ilp-gt__grid" style={{ left: t.left }} />)}
              {ticks.major.map((t) => <div key={'G' + t.left} className="ilp-gt__grid ilp-gt__grid--major" style={{ left: t.left }} />)}

              {rows.map((r, i) => (
                <div
                  key={'l' + r.id}
                  className={'ilp-gt__lane' + (r.isGroup ? ' ilp-gt__lane--group' : '') + (sel === r.id ? ' ilp-gt__lane--on' : '')}
                  style={{ top: i * rowHeight, height: rowHeight }}
                />
              ))}

              {showDependencies && (
                <svg className="ilp-gt__dep" width={W} height={bodyH}>
                  {deps.map((dep) => (
                    <g key={dep.key}>
                      <path d={dep.d} className={dep.crit ? 'crit' : ''} />
                      <polygon className={dep.crit ? 'crit' : ''} points={`${dep.tip[0]},${dep.tip[1] - 4} ${dep.tip[0] + 6},${dep.tip[1]} ${dep.tip[0]},${dep.tip[1] + 4}`} />
                    </g>
                  ))}
                </svg>
              )}

              {rows.map((r, i) => {
                const top = barTop(i);
                const show = (e) => setTip({
                  x: e.clientX, y: e.clientY, name: r.name,
                  rows: [
                    ['Start', fmtDate(r.start)],
                    r.milestone ? null : ['Finish', fmtDate(r.end)],
                    r.progress != null ? ['Progress', r.progress + '%'] : null,
                    r.owner ? ['Owner', r.owner] : null,
                    r.baselineEnd && !r.milestone ? ['Baseline', fmtDate(r.baselineEnd)] : null,
                  ].filter(Boolean),
                });

                if (r.milestone) {
                  return (
                    <span
                      key={'b' + r.id} className="ilp-gt__ms" tabIndex={0} role="button" aria-label={r.name}
                      style={{ left: x(r.start) - 7, top: top + 1, background: STATUS[r.status] || STATUS.planned }}
                      onMouseEnter={show} onMouseMove={show} onMouseLeave={() => setTip(null)}
                      onClick={() => onTaskClick && onTaskClick(r)}
                    />
                  );
                }

                if (r.isGroup) {
                  const roll = rollup(r);
                  if (!roll) return null;
                  return (
                    <span
                      key={'b' + r.id} className="ilp-gt__sum"
                      style={{ left: x(roll.s), width: Math.max(6, x(roll.e) - x(roll.s)), top: top + 4 }}
                      onMouseEnter={(e) => setTip({ x: e.clientX, y: e.clientY, name: r.name, rows: [['Start', fmtDate(roll.s)], ['Finish', fmtDate(roll.e)], ['Tasks', String(r.childIds.length)]] })}
                      onMouseLeave={() => setTip(null)}
                    />
                  );
                }

                const left = x(r.start);
                const w = Math.max(6, x(r.end) - left);
                const color = STATUS[r.status] || STATUS.planned;
                return (
                  <React.Fragment key={'b' + r.id}>
                    {showBaseline && r.baselineStart && r.baselineEnd && (
                      <span className="ilp-gt__base" style={{ left: x(r.baselineStart), width: Math.max(4, x(r.baselineEnd) - x(r.baselineStart)), top: top + 19 }} />
                    )}
                    <span
                      className="ilp-gt__bar" tabIndex={0} role="button" aria-label={r.name}
                      style={{ left, width: w, top, height: 16, background: color }}
                      onMouseEnter={show} onMouseMove={show} onMouseLeave={() => setTip(null)}
                      onClick={() => onTaskClick && onTaskClick(r)}
                    >
                      {r.progress > 0 && <span className="ilp-gt__fill" style={{ width: `${Math.min(100, r.progress)}%`, background: 'rgba(255,255,255,.42)' }} />}
                      {w > 64 && r.label && <span className="ilp-gt__inlabel">{r.label}</span>}
                    </span>
                    {r.owner && w <= 64 && <span className="ilp-gt__blabel" style={{ left: left + w + 8, top: top + 8 }}>{r.owner}</span>}
                  </React.Fragment>
                );
              })}

              {todayX != null && todayX >= 0 && todayX <= W && <div className="ilp-gt__today" style={{ left: todayX }} />}
            </div>
          </div>
        </div>
      </div>

      {showLegend && (
        <div className="ilp-gt__foot">
          <span className="ilp-gt__key"><i style={{ background: STATUS.done }} />Complete</span>
          <span className="ilp-gt__key"><i style={{ background: STATUS.active }} />In progress</span>
          <span className="ilp-gt__key"><i style={{ background: STATUS.risk }} />At risk</span>
          <span className="ilp-gt__key"><i style={{ background: STATUS.late }} />Late</span>
          <span className="ilp-gt__key"><i style={{ background: STATUS.planned }} />Planned</span>
          <span className="ilp-gt__key"><i className="ms" style={{ background: STATUS.active }} />Milestone</span>
          {showBaseline && <span className="ilp-gt__key"><i style={{ background: 'var(--il-grayblue-300)', height: 4 }} />Baseline</span>}
          <span className="ilp-gt__key" style={{ marginLeft: 'auto' }}><span className="ilp-gt__crit" />Critical path</span>
        </div>
      )}

      {tip && (
        <div className="ilp-gt__tip" style={{ left: tip.x + 14, top: tip.y + 14 }}>
          <b>{tip.name}</b>
          {tip.rows.map(([k, v]) => <div key={k}><span>{k}</span><em>{v}</em></div>)}
        </div>
      )}
    </div>
  );
}
