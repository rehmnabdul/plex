import React from 'react';

const CSS = `
.ilp-cal{display:flex;flex-direction:column;min-height:0;background:var(--surface-card);border:1px solid var(--border-default);border-radius:var(--radius-lg);box-shadow:var(--shadow-sm);font-family:var(--font-sans);color:var(--text-primary);overflow:hidden}
.ilp-cal *{box-sizing:border-box}

/* toolbar */
.ilp-cal__bar{display:flex;flex:none;align-items:center;gap:10px;flex-wrap:wrap;padding:11px 14px;border-bottom:1px solid var(--border-default);min-height:58px}
.ilp-cal__ttl{font-size:var(--fs-lg);font-weight:var(--weight-bold);letter-spacing:-0.015em;min-width:190px}
.ilp-cal__nav{display:flex;gap:4px}
.ilp-cal__nav button{display:grid;place-items:center;height:32px;min-width:32px;padding:0 10px;font:inherit;font-size:var(--fs-sm);font-weight:var(--weight-semibold);color:var(--text-secondary);background:var(--surface-card);border:1px solid var(--border-default);border-radius:var(--radius-md);cursor:pointer}
.ilp-cal__nav button:hover{background:var(--surface-hover);color:var(--text-primary)}
.ilp-cal__nav button:focus-visible{outline:none;box-shadow:var(--ring)}
.ilp-cal__nav svg{width:15px;height:15px}
.ilp-cal__seg{display:flex;gap:2px;margin-left:auto;padding:3px;background:var(--il-grayblue-100);border-radius:var(--radius-md)}
.ilp-cal__seg button{height:26px;padding:0 13px;font:inherit;font-size:var(--fs-xs);font-weight:var(--weight-semibold);color:var(--text-secondary);background:transparent;border:0;border-radius:var(--radius-sm);cursor:pointer}
.ilp-cal__seg button[aria-pressed="true"]{background:var(--surface-card);color:var(--text-primary);box-shadow:var(--shadow-xs)}
.ilp-cal__seg button:focus-visible{outline:none;box-shadow:var(--ring)}

/* shared head */
.ilp-cal__dow{display:grid;flex:none;border-bottom:1px solid var(--border-default);background:var(--il-grayblue-50)}
.ilp-cal__dow span{padding:8px 10px;font-size:10px;font-weight:var(--weight-bold);letter-spacing:.07em;text-transform:uppercase;color:var(--text-muted);text-align:center}
.ilp-cal__dow span.off{color:var(--text-disabled)}

/* month */
.ilp-cal__month{flex:1 1 auto;min-height:0;display:grid;grid-auto-rows:1fr;overflow-y:auto}
.ilp-cal__week{display:grid;grid-template-columns:repeat(7,1fr);border-bottom:1px solid var(--border-subtle);min-height:104px}
.ilp-cal__cell{position:relative;display:flex;flex-direction:column;gap:3px;padding:5px 6px;border-right:1px solid var(--border-subtle);min-width:0;cursor:pointer;transition:background var(--dur-fast) var(--ease-standard)}
.ilp-cal__cell:last-child{border-right:0}
.ilp-cal__cell:hover{background:var(--il-grayblue-50)}
.ilp-cal__cell--out{background:var(--il-grayblue-50)}
.ilp-cal__cell--out .ilp-cal__dnum{color:var(--text-disabled)}
.ilp-cal__cell--wknd{background:color-mix(in srgb,var(--il-grayblue-50) 55%,transparent)}
.ilp-cal__cell:focus-visible{outline:none;box-shadow:var(--ring) inset}
.ilp-cal__dnum{align-self:flex-start;display:grid;place-items:center;min-width:24px;height:24px;padding:0 6px;font-size:var(--fs-sm);font-weight:var(--weight-semibold);font-variant-numeric:tabular-nums;color:var(--text-secondary);border-radius:var(--radius-pill)}
.ilp-cal__dnum--today{background:var(--brand-primary);color:#fff;font-weight:var(--weight-bold)}
.ilp-cal__more{align-self:flex-start;padding:1px 4px;font-size:var(--fs-xs);font-weight:var(--weight-bold);color:var(--text-link);background:none;border:0;cursor:pointer}
.ilp-cal__more:hover{text-decoration:underline}

/* event chip */
.ilp-cal__ev{display:flex;align-items:center;gap:5px;width:100%;padding:3px 7px;font:inherit;font-size:var(--fs-xs);font-weight:var(--weight-semibold);text-align:left;border:0;border-radius:var(--radius-sm);cursor:pointer;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;background:var(--il-blue-100);color:var(--il-blue-800)}
.ilp-cal__ev:hover{filter:brightness(.96)}
.ilp-cal__ev:focus-visible{outline:none;box-shadow:var(--ring)}
.ilp-cal__ev i{width:6px;height:6px;flex:none;border-radius:50%;background:currentColor}
.ilp-cal__ev b{font-weight:var(--weight-bold);font-variant-numeric:tabular-nums;opacity:.75}
.ilp-cal__ev span{overflow:hidden;text-overflow:ellipsis}
.ilp-cal__ev--success{background:var(--il-earth-soft);color:var(--il-earth-ink)}
.ilp-cal__ev--warning{background:var(--il-sun-soft);color:var(--il-sun-ink)}
.ilp-cal__ev--danger{background:var(--il-red-soft);color:var(--il-red-ink)}
.ilp-cal__ev--neutral{background:var(--il-grayblue-100);color:var(--text-secondary)}
.ilp-cal__ev--solid{background:var(--brand-primary);color:#fff}
.ilp-cal__ev--done{text-decoration:line-through;opacity:.65}

/* time grid */
.ilp-cal__grid{flex:1 1 auto;min-height:0;overflow-y:auto;position:relative}
.ilp-cal__gin{position:relative;display:grid}
.ilp-cal__gut{border-right:1px solid var(--border-default)}
.ilp-cal__hr{position:relative;border-bottom:1px solid var(--border-subtle)}
.ilp-cal__hlab{position:absolute;top:-7px;right:8px;font-size:10px;font-weight:var(--weight-semibold);color:var(--text-muted);font-variant-numeric:tabular-nums}
.ilp-cal__col{position:relative;border-right:1px solid var(--border-subtle)}
.ilp-cal__col--wknd{background:color-mix(in srgb,var(--il-grayblue-50) 55%,transparent)}
.ilp-cal__slot{position:absolute;left:3px;right:3px;padding:4px 7px;border-radius:var(--radius-sm);font-size:var(--fs-xs);font-weight:var(--weight-semibold);text-align:left;border:0;cursor:pointer;overflow:hidden;background:var(--il-blue-100);color:var(--il-blue-800);box-shadow:inset 3px 0 0 var(--brand-primary)}
.ilp-cal__slot:hover{filter:brightness(.97)}
.ilp-cal__slot:focus-visible{outline:none;box-shadow:var(--ring)}
.ilp-cal__slot b{display:block;font-weight:var(--weight-bold);overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
.ilp-cal__slot em{display:block;font-style:normal;font-weight:var(--weight-regular);opacity:.8;font-variant-numeric:tabular-nums}
.ilp-cal__slot--success{background:var(--il-earth-soft);color:var(--il-earth-ink);box-shadow:inset 3px 0 0 var(--il-earth-ink)}
.ilp-cal__slot--warning{background:var(--il-sun-soft);color:var(--il-sun-ink);box-shadow:inset 3px 0 0 var(--il-sun-ink)}
.ilp-cal__slot--danger{background:var(--il-red-soft);color:var(--il-red-ink);box-shadow:inset 3px 0 0 var(--il-red-ink)}
.ilp-cal__slot--neutral{background:var(--il-grayblue-100);color:var(--text-secondary);box-shadow:inset 3px 0 0 var(--il-grayblue-400)}
.ilp-cal__now{position:absolute;left:0;right:0;height:2px;background:var(--status-danger);z-index:3;pointer-events:none}
.ilp-cal__now::before{content:"";position:absolute;left:-4px;top:-3px;width:8px;height:8px;border-radius:50%;background:var(--status-danger)}

/* all-day strip */
.ilp-cal__allday{display:grid;flex:none;min-height:34px;background:var(--surface-card);border-bottom:1px solid var(--border-default)}
.ilp-cal__adlab{display:flex;align-items:center;justify-content:flex-end;padding:0 8px;font-size:10px;font-weight:var(--weight-bold);letter-spacing:.06em;text-transform:uppercase;color:var(--text-muted);border-right:1px solid var(--border-default)}
.ilp-cal__adcol{display:flex;flex-direction:column;gap:3px;padding:4px;border-right:1px solid var(--border-subtle);min-width:0}

/* agenda */
.ilp-cal__ag{flex:1 1 auto;min-height:0;overflow-y:auto}
.ilp-cal__agd{display:flex;align-items:center;gap:10px;padding:10px 16px 8px;background:var(--il-grayblue-50);border-bottom:1px solid var(--border-subtle);position:sticky;top:0;z-index:1}
.ilp-cal__agd b{font-size:var(--fs-sm);font-weight:var(--weight-bold)}
.ilp-cal__agd span{font-size:var(--fs-xs);color:var(--text-muted)}
.ilp-cal__agd em{margin-left:auto;font-style:normal;font-size:var(--fs-xs);color:var(--text-muted)}
.ilp-cal__agr{display:flex;align-items:center;gap:12px;width:100%;padding:11px 16px;font:inherit;text-align:left;background:var(--surface-card);border:0;border-bottom:1px solid var(--border-subtle);cursor:pointer}
.ilp-cal__agr:hover{background:var(--il-grayblue-50)}
.ilp-cal__agr:focus-visible{outline:none;box-shadow:var(--ring) inset}
.ilp-cal__agt{flex:none;width:104px;font-size:var(--fs-xs);font-weight:var(--weight-semibold);font-variant-numeric:tabular-nums;color:var(--text-secondary)}
.ilp-cal__agb{width:4px;height:32px;flex:none;border-radius:2px;background:var(--brand-primary)}
.ilp-cal__agm{min-width:0;flex:1}
.ilp-cal__agm b{display:block;font-size:var(--fs-sm);font-weight:var(--weight-bold);overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
.ilp-cal__agm span{display:block;margin-top:2px;font-size:var(--fs-xs);color:var(--text-muted);overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
.ilp-cal__empty{padding:48px 20px;text-align:center;color:var(--text-muted);font-size:var(--fs-sm)}
.ilp-cal__empty b{display:block;margin-bottom:4px;font-size:var(--fs-base);color:var(--text-secondary)}

/* drag & drop */
.ilp-cal__ev,.ilp-cal__slot{cursor:grab}
.ilp-cal__ev:active,.ilp-cal__slot:active{cursor:grabbing}
.ilp-cal__ev--drag,.ilp-cal__slot--drag{opacity:.4}
.ilp-cal__cell--over{background:var(--il-blue-50);box-shadow:inset 0 0 0 2px var(--brand-primary)}
.ilp-cal__col--over{background:var(--il-blue-50)}
.ilp-cal__ghost{position:absolute;left:3px;right:3px;border:2px dashed var(--brand-primary);border-radius:var(--radius-sm);background:color-mix(in srgb,var(--il-blue-500) 10%,transparent);pointer-events:none;z-index:4}
.ilp-cal__grip{position:absolute;left:0;right:0;bottom:0;height:7px;cursor:ns-resize}
.ilp-cal__grip::after{content:"";position:absolute;left:50%;bottom:2px;width:22px;height:2px;margin-left:-11px;border-radius:2px;background:currentColor;opacity:0}
.ilp-cal__slot:hover .ilp-cal__grip::after{opacity:.5}

/* detail popover */
.ilp-cal__back{position:fixed;inset:0;z-index:880}
.ilp-cal__pop{position:fixed;z-index:881;width:296px;padding:16px;background:var(--surface-card);border:1px solid var(--border-default);border-radius:var(--radius-lg);box-shadow:var(--shadow-xl);animation:ilp-cal-pop var(--dur-fast) var(--ease-out)}
@keyframes ilp-cal-pop{from{opacity:0;transform:scale(.97)}}
.ilp-cal__pop h4{display:flex;align-items:flex-start;gap:8px;margin:0 0 4px;font-size:var(--fs-base);font-weight:var(--weight-bold);letter-spacing:-0.01em;line-height:1.3}
.ilp-cal__pop h4 i{width:9px;height:9px;flex:none;margin-top:5px;border-radius:50%;background:var(--brand-primary)}
.ilp-cal__pop dl{display:flex;flex-direction:column;gap:7px;margin:12px 0 0}
.ilp-cal__pop .r{display:flex;gap:12px;font-size:var(--fs-xs);line-height:1.5}
.ilp-cal__pop dt{flex:none;width:62px;color:var(--text-muted)}
.ilp-cal__pop dd{margin:0;font-weight:var(--weight-semibold);color:var(--text-primary)}
.ilp-cal__pop .acts{display:flex;gap:8px;margin-top:16px;padding-top:14px;border-top:1px solid var(--border-subtle)}
.ilp-cal__pop .acts button{flex:1;height:34px;font:inherit;font-size:var(--fs-sm);font-weight:var(--weight-bold);border-radius:var(--radius-md);cursor:pointer}
.ilp-cal__pop .acts .g{color:var(--text-secondary);background:var(--surface-card);border:1px solid var(--border-default)}
.ilp-cal__pop .acts .g:hover{background:var(--surface-hover);color:var(--text-primary)}
.ilp-cal__pop .acts .p{color:#fff;background:var(--brand-primary);border:1px solid var(--brand-primary)}
.ilp-cal__pop .acts .p:hover{background:var(--brand-primary-hover)}
.ilp-cal__pop .acts .d{flex:none;width:38px;display:grid;place-items:center;color:var(--il-red-ink);background:var(--surface-card);border:1px solid var(--border-default)}
.ilp-cal__pop .acts .d:hover{background:var(--il-red-soft);border-color:#f8cfcb}
.ilp-cal__pop .acts svg{width:16px;height:16px}
`;

function useCSS() {
  React.useEffect(() => {
    if (document.getElementById('ilp-calendar-css')) return;
    const s = document.createElement('style');
    s.id = 'ilp-calendar-css';
    s.textContent = CSS;
    document.head.appendChild(s);
  }, []);
}

const Ic = (d, w = 2.4) => (p) => (
  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={w} strokeLinecap="round" strokeLinejoin="round" aria-hidden="true" {...p}>{d.map((x, i) => <path key={i} d={x} />)}</svg>
);
const IcL = Ic(['M15 5l-7 7 7 7']);
const IcR = Ic(['M9 5l7 7-7 7']);
const IcTrash = Ic(['M4 7h16', 'M9 7V4h6v3', 'M6 7l1 13h10l1-13'], 2);

const DOW = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
const MONTHS = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
const d = (v) => (v instanceof Date ? v : new Date(v));
const iso = (x) => `${x.getFullYear()}-${String(x.getMonth() + 1).padStart(2, '0')}-${String(x.getDate()).padStart(2, '0')}`;
const same = (a, b) => a && b && iso(d(a)) === iso(d(b));
const hhmm = (x) => `${String(x.getHours()).padStart(2, '0')}:${String(x.getMinutes()).padStart(2, '0')}`;
const startOfWeek = (x) => { const c = new Date(x); c.setDate(c.getDate() - ((c.getDay() + 6) % 7)); c.setHours(0, 0, 0, 0); return c; };
const addDays = (x, n) => { const c = new Date(x); c.setDate(c.getDate() + n); return c; };

/**
 * Calendar — month, week, day and agenda views over a single event list.
 * For scheduling work: inspections, audits, line bookings.
 */
export function Calendar({
  events = [],
  view: viewProp = 'month',
  views = ['month', 'week', 'day', 'agenda'],
  date: dateProp,
  today = new Date(),
  onDateChange,
  onViewChange,
  onEventClick,
  onDayClick,
  onSelectSlot,
  onEventDrop,
  onEventResize,
  onEventEdit,
  onEventDelete,
  editable = false,
  showDetail = true,
  snapMinutes = 15,
  dayStart = 6,
  dayEnd = 20,
  maxPerDay = 3,
  height = 640,
  showWeekends = true,
  actions = null,
  className = '',
  ...rest
}) {
  useCSS();
  const [view, setView] = React.useState(viewProp);
  const [cursor, setCursor] = React.useState(dateProp ? d(dateProp) : today);
  const [drag, setDrag] = React.useState(null);
  const [over, setOver] = React.useState(null);
  const [detail, setDetail] = React.useState(null);
  const resizing = React.useRef(null);
  const cols = showWeekends ? 7 : 5;

  const lengthOf = (e) => (e.end ? d(e.end) - d(e.start) : 3600000);
  const moveTo = (e, next) => {
    const nextEnd = e.allDay ? null : new Date(next.getTime() + lengthOf(e));
    onEventDrop && onEventDrop(e, next, nextEnd);
  };
  /** Drop on a day: keep the clock time, change the date. */
  const dropOnDay = (e, day) => {
    const s = d(e.start);
    const next = new Date(day);
    next.setHours(s.getHours(), s.getMinutes(), 0, 0);
    moveTo(e, next);
  };
  const openDetail = (e, ev) => {
    if (onEventClick) onEventClick(e);
    if (!showDetail) return;
    const r = ev.currentTarget.getBoundingClientRect();
    setDetail({
      event: e,
      left: Math.min(Math.max(12, r.left), window.innerWidth - 308),
      top: Math.min(r.bottom + 8, window.innerHeight - 260),
    });
  };

  const go = (n) => {
    const next = view === 'month'
      ? new Date(cursor.getFullYear(), cursor.getMonth() + n, 1)
      : addDays(cursor, n * (view === 'day' ? 1 : 7));
    setCursor(next);
    onDateChange && onDateChange(next);
  };
  const pickView = (v) => { setView(v); onViewChange && onViewChange(v); };

  const byDay = React.useMemo(() => {
    const m = new Map();
    for (const e of events) {
      const k = iso(d(e.start));
      if (!m.has(k)) m.set(k, []);
      m.get(k).push(e);
    }
    for (const list of m.values()) list.sort((a, b) => d(a.start) - d(b.start));
    return m;
  }, [events]);

  const dayEvents = (x) => (byDay.get(iso(x)) || []).filter((e) => showWeekends || (x.getDay() !== 0 && x.getDay() !== 6));

  const span = (s, e) => `${s.getDate()} ${MONTHS[s.getMonth()].slice(0, 3)} – ${e.getDate()} ${MONTHS[e.getMonth()].slice(0, 3)} ${e.getFullYear()}`;
  const heading = view === 'month'
    ? `${MONTHS[cursor.getMonth()]} ${cursor.getFullYear()}`
    : view === 'day'
      ? cursor.toLocaleDateString('en-GB', { weekday: 'long', day: 'numeric', month: 'long', year: 'numeric' })
      : view === 'agenda'
        ? span(startOfWeek(cursor), addDays(startOfWeek(cursor), 13))
        : span(startOfWeek(cursor), addDays(startOfWeek(cursor), cols - 1));

  /** Concurrent events split into side-by-side lanes; nothing paints over anything. */
  const laneOut = (list) => {
    const items = list
      .map((e) => {
        const st = d(e.start);
        return { e, s: st, en: e.end ? d(e.end) : new Date(st.getTime() + 3600000) };
      })
      .sort((a, b) => a.s - b.s || b.en - a.en);
    const out = [];
    let cluster = [];
    let clusterEnd = null;
    const flush = () => {
      if (!cluster.length) return;
      const lanes = [];
      for (const it of cluster) {
        let i = lanes.findIndex((endAt) => endAt <= it.s);
        if (i < 0) { i = lanes.length; lanes.push(it.en); } else lanes[i] = it.en;
        it.lane = i;
      }
      for (const it of cluster) it.lanes = lanes.length;
      out.push(...cluster);
      cluster = [];
      clusterEnd = null;
    };
    for (const it of items) {
      if (clusterEnd && it.s >= clusterEnd) flush();
      cluster.push(it);
      clusterEnd = clusterEnd && clusterEnd > it.en ? clusterEnd : it.en;
    }
    flush();
    return out;
  };

  const Chip = ({ e }) => (
    <button
      type="button"
      draggable={editable}
      onDragStart={(ev) => { ev.stopPropagation(); setDrag(e); }}
      onDragEnd={() => { setDrag(null); setOver(null); }}
      className={'ilp-cal__ev' + (e.tone ? ' ilp-cal__ev--' + e.tone : '') + (e.done ? ' ilp-cal__ev--done' : '')
        + (drag && drag.id === e.id ? ' ilp-cal__ev--drag' : '')}
      onClick={(ev) => { ev.stopPropagation(); openDetail(e, ev); }}
      title={e.title}
    >
      {e.allDay ? <i /> : <b>{hhmm(d(e.start))}</b>}
      <span>{e.title}</span>
    </button>
  );

  /* ---------- month ---------- */
  const renderMonth = () => {
    const first = new Date(cursor.getFullYear(), cursor.getMonth(), 1);
    const gridStart = startOfWeek(first);
    const weeks = [];
    for (let w = 0; w < 6; w++) {
      const row = [];
      for (let i = 0; i < cols; i++) row.push(addDays(gridStart, w * 7 + i));
      weeks.push(row);
      if (w >= 4 && addDays(gridStart, (w + 1) * 7).getMonth() !== cursor.getMonth()) break;
    }
    return (
      <>
        <div className="ilp-cal__dow" style={{ gridTemplateColumns: `repeat(${cols},1fr)` }}>
          {DOW.slice(0, cols).map((n, i) => <span key={n} className={i > 4 ? 'off' : ''}>{n}</span>)}
        </div>
        <div className="ilp-cal__month">
          {weeks.map((row, wi) => (
            <div className="ilp-cal__week" key={wi} style={{ gridTemplateColumns: `repeat(${cols},1fr)` }}>
              {row.map((x) => {
                const list = dayEvents(x);
                const out = x.getMonth() !== cursor.getMonth();
                const wknd = x.getDay() === 0 || x.getDay() === 6;
                return (
                  <div
                    key={x.getTime()} tabIndex={0} role="button" aria-label={x.toDateString()}
                    className={'ilp-cal__cell' + (out ? ' ilp-cal__cell--out' : '') + (wknd && !out ? ' ilp-cal__cell--wknd' : '')
                      + (over === iso(x) ? ' ilp-cal__cell--over' : '')}
                    onDragOver={editable && drag ? (ev) => { ev.preventDefault(); setOver(iso(x)); } : undefined}
                    onDragLeave={editable ? () => setOver(null) : undefined}
                    onDrop={editable && drag ? (ev) => { ev.preventDefault(); dropOnDay(drag, x); setDrag(null); setOver(null); } : undefined}
                    onClick={() => onDayClick && onDayClick(x, list)}
                  >
                    <span className={'ilp-cal__dnum' + (same(x, today) ? ' ilp-cal__dnum--today' : '')}>{x.getDate()}</span>
                    {list.slice(0, maxPerDay).map((e) => <Chip e={e} key={e.id} />)}
                    {list.length > maxPerDay && (
                      <button
                        type="button" className="ilp-cal__more"
                        onClick={(ev) => { ev.stopPropagation(); setCursor(x); pickView('day'); }}
                      >+{list.length - maxPerDay} more</button>
                    )}
                  </div>
                );
              })}
            </div>
          ))}
        </div>
      </>
    );
  };

  /* ---------- week / day time grid ---------- */
  const renderGrid = (count) => {
    const startDay = count === 1 ? new Date(cursor) : startOfWeek(cursor);
    const list = Array.from({ length: count }, (_, i) => addDays(startDay, i));
    const hours = dayEnd - dayStart;
    const hourH = 52;
    const at = (x) => ((x.getHours() + x.getMinutes() / 60) - dayStart) * hourH;
    const nowIn = list.some((x) => same(x, today));
    // An all-day event has no hour — never fabricate one. It goes in the strip.
    const allDay = list.map((x) => dayEvents(x).filter((e) => e.allDay));
    const hasAllDay = allDay.some((a) => a.length > 0);

    return (
      <>
        <div className="ilp-cal__dow" style={{ gridTemplateColumns: `64px repeat(${count},1fr)` }}>
          <span />
          {list.map((x) => (
            <span key={x.getTime()} className={x.getDay() === 0 || x.getDay() === 6 ? 'off' : ''}>
              {DOW[(x.getDay() + 6) % 7]} {x.getDate()}
            </span>
          ))}
        </div>
        {hasAllDay && (
          <div className="ilp-cal__allday" style={{ gridTemplateColumns: `64px repeat(${count},1fr)` }}>
            <span className="ilp-cal__adlab">All day</span>
            {list.map((x, i) => (
              <div className="ilp-cal__adcol" key={x.getTime()}>
                {allDay[i].map((e) => <Chip e={e} key={e.id} />)}
              </div>
            ))}
          </div>
        )}
        <div className="ilp-cal__grid">
          <div className="ilp-cal__gin" style={{ gridTemplateColumns: `64px repeat(${count},1fr)`, height: hours * hourH }}>
            <div className="ilp-cal__gut">
              {Array.from({ length: hours }, (_, i) => (
                <div className="ilp-cal__hr" key={i} style={{ height: hourH }}>
                  {i > 0 && <span className="ilp-cal__hlab">{String(dayStart + i).padStart(2, '0')}:00</span>}
                </div>
              ))}
            </div>
            {list.map((x) => {
              const wknd = x.getDay() === 0 || x.getDay() === 6;
              return (
                <div
                  key={x.getTime()}
                  className={'ilp-cal__col' + (wknd ? ' ilp-cal__col--wknd' : '') + (over === 'g' + iso(x) ? ' ilp-cal__col--over' : '')}
                  onDragOver={editable && drag ? (ev) => { ev.preventDefault(); setOver('g' + iso(x)); } : undefined}
                  onDragLeave={editable ? () => setOver(null) : undefined}
                  onDrop={editable && drag ? (ev) => {
                    ev.preventDefault();
                    const y = ev.clientY - ev.currentTarget.getBoundingClientRect().top;
                    const mins = Math.round(((y / hourH) * 60) / snapMinutes) * snapMinutes;
                    const next = new Date(x);
                    next.setHours(dayStart, 0, 0, 0);
                    next.setMinutes(Math.max(0, Math.min((dayEnd - dayStart) * 60 - 30, mins)));
                    moveTo(drag, next);
                    setDrag(null); setOver(null);
                  } : undefined}
                  onClick={(e) => {
                    if (!onSelectSlot) return;
                    const y = e.clientY - e.currentTarget.getBoundingClientRect().top;
                    const h = Math.max(dayStart, Math.min(dayEnd - 1, Math.floor(y / hourH) + dayStart));
                    const slot = new Date(x);
                    slot.setHours(h, 0, 0, 0);
                    onSelectSlot(slot);
                  }}
                >
                  {Array.from({ length: hours }, (_, i) => <div className="ilp-cal__hr" key={i} style={{ height: hourH }} />)}
                  {laneOut(dayEvents(x).filter((e) => !e.allDay)).map(({ e, s, en, lane, lanes }) => {
                    const top = Math.max(0, at(s));
                    const h = Math.max(24, at(en) - at(s));
                    const colW = `calc((100% - 6px) / ${lanes})`;
                    const colX = `calc(3px + ${lane} * (100% - 6px) / ${lanes})`;
                    return (
                      <button
                        key={e.id} type="button"
                        draggable={editable}
                        onDragStart={(ev) => { ev.stopPropagation(); setDrag(e); }}
                        onDragEnd={() => { setDrag(null); setOver(null); }}
                        className={'ilp-cal__slot' + (e.tone ? ' ilp-cal__slot--' + e.tone : '')
                          + (drag && drag.id === e.id ? ' ilp-cal__slot--drag' : '')}
                        style={{ top, height: h, left: colX, width: colW, right: 'auto' }}
                        onClick={(ev) => { ev.stopPropagation(); openDetail(e, ev); }}
                      >
                        <b>{e.title}</b>
                        {h > 38 && <em>{hhmm(s)} – {hhmm(en)}{e.meta ? ` · ${e.meta}` : ''}</em>}
                        {editable && onEventResize && (
                          <span
                            className="ilp-cal__grip" role="separator" aria-label={`Resize ${e.title}`}
                            onClick={(ev) => ev.stopPropagation()}
                            onMouseDown={(ev) => {
                              ev.preventDefault(); ev.stopPropagation();
                              resizing.current = { e, startY: ev.clientY, h };
                              const move = (m) => {
                                const rc = resizing.current;
                                if (!rc) return;
                                const mins = Math.round((((m.clientY - rc.startY) / hourH) * 60) / snapMinutes) * snapMinutes;
                                rc.mins = mins;
                              };
                              const up = () => {
                                const rc = resizing.current;
                                window.removeEventListener('mousemove', move);
                                window.removeEventListener('mouseup', up);
                                resizing.current = null;
                                if (rc && rc.mins) {
                                  const nextEnd = new Date(en.getTime() + rc.mins * 60000);
                                  if (nextEnd > s) onEventResize(e, s, nextEnd);
                                }
                              };
                              window.addEventListener('mousemove', move);
                              window.addEventListener('mouseup', up);
                            }}
                          />
                        )}
                      </button>
                    );
                  })}
                  {nowIn && same(x, today) && (
                    <div className="ilp-cal__now" style={{ top: at(d(today)) }} />
                  )}
                </div>
              );
            })}
          </div>
        </div>
      </>
    );
  };

  /* ---------- agenda ---------- */
  const renderAgenda = () => {
    const from = startOfWeek(cursor);
    const groups = [];
    for (let i = 0; i < 14; i++) {
      const x = addDays(from, i);
      const list = dayEvents(x);
      if (list.length) groups.push({ date: x, list });
    }
    if (!groups.length) {
      return <div className="ilp-cal__empty"><b>Nothing scheduled</b>No work is booked in the next two weeks.</div>;
    }
    return (
      <div className="ilp-cal__ag">
        {groups.map((g) => (
          <section key={g.date.getTime()}>
            <header className="ilp-cal__agd">
              <b>{same(g.date, today) ? 'Today' : g.date.toLocaleDateString('en-GB', { weekday: 'long', day: 'numeric', month: 'short' })}</b>
              <span>{g.date.toLocaleDateString('en-GB', { day: '2-digit', month: 'short', year: 'numeric' })}</span>
              <em>{g.list.length} item{g.list.length > 1 ? 's' : ''}</em>
            </header>
            {g.list.map((e) => (
              <button key={e.id} type="button" className="ilp-cal__agr" onClick={(ev) => openDetail(e, ev)}>
                <span className="ilp-cal__agt">{e.allDay ? 'All day' : `${hhmm(d(e.start))}${e.end ? ' – ' + hhmm(d(e.end)) : ''}`}</span>
                <span className="ilp-cal__agb" style={{ background: e.tone === 'success' ? 'var(--il-earth)' : e.tone === 'warning' ? 'var(--il-sun)' : e.tone === 'danger' ? 'var(--status-danger)' : e.tone === 'neutral' ? 'var(--il-grayblue-300)' : 'var(--brand-primary)' }} />
                <span className="ilp-cal__agm"><b>{e.title}</b>{e.meta && <span>{e.meta}</span>}</span>
              </button>
            ))}
          </section>
        ))}
      </div>
    );
  };

  return (
    <div className={'ilp-cal' + (className ? ' ' + className : '')} {...rest} style={{ height, ...(rest.style || {}) }}>
      <div className="ilp-cal__bar">
        <span className="ilp-cal__ttl">{heading}</span>
        <div className="ilp-cal__nav">
          <button type="button" aria-label="Previous" onClick={() => go(-1)}><IcL /></button>
          <button type="button" onClick={() => { setCursor(new Date(today)); onDateChange && onDateChange(new Date(today)); }}>Today</button>
          <button type="button" aria-label="Next" onClick={() => go(1)}><IcR /></button>
        </div>
        {actions}
        {views.length > 1 && (
          <div className="ilp-cal__seg">
            {views.map((v) => (
              <button key={v} type="button" aria-pressed={view === v} onClick={() => pickView(v)}>
                {v[0].toUpperCase() + v.slice(1)}
              </button>
            ))}
          </div>
        )}
      </div>
      {view === 'month' && renderMonth()}
      {view === 'week' && renderGrid(cols)}
      {view === 'day' && renderGrid(1)}
      {view === 'agenda' && renderAgenda()}

      {detail && (
        <>
          <div className="ilp-cal__back" onMouseDown={() => setDetail(null)} />
          <div className="ilp-cal__pop" role="dialog" aria-label={detail.event.title} style={{ left: detail.left, top: detail.top }}>
            <h4>
              <i style={{ background: detail.event.tone === 'success' ? 'var(--il-earth)' : detail.event.tone === 'warning' ? 'var(--il-sun)' : detail.event.tone === 'danger' ? 'var(--status-danger)' : detail.event.tone === 'neutral' ? 'var(--il-grayblue-300)' : 'var(--brand-primary)' }} />
              {detail.event.title}
            </h4>
            <dl>
              <div className="r"><dt>When</dt><dd>{detail.event.allDay
                ? `${d(detail.event.start).toLocaleDateString('en-GB', { weekday: 'short', day: '2-digit', month: 'short' })} · all day`
                : `${d(detail.event.start).toLocaleDateString('en-GB', { weekday: 'short', day: '2-digit', month: 'short' })} · ${hhmm(d(detail.event.start))}${detail.event.end ? ' – ' + hhmm(d(detail.event.end)) : ''}`}</dd></div>
              {detail.event.meta && <div className="r"><dt>Details</dt><dd>{detail.event.meta}</dd></div>}
              <div className="r"><dt>Status</dt><dd>{detail.event.done ? 'Completed' : detail.event.tone === 'danger' ? 'Blocked' : detail.event.tone === 'warning' ? 'At risk' : 'Scheduled'}</dd></div>
            </dl>
            <div className="acts">
              <button type="button" className="g" onClick={() => setDetail(null)}>Close</button>
              {onEventEdit && <button type="button" className="p" onClick={() => { onEventEdit(detail.event); setDetail(null); }}>Edit</button>}
              {onEventDelete && (
                <button type="button" className="d" aria-label="Delete event" onClick={() => { onEventDelete(detail.event); setDetail(null); }}><IcTrash /></button>
              )}
            </div>
          </div>
        </>
      )}
    </div>
  );
}
