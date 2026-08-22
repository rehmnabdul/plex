import React from 'react';

const CSS = `
.ilp-tabs{font-family:var(--font-sans);position:relative;min-width:0}
.ilp-tabs *{box-sizing:border-box}
.ilp-tabs__wrap{position:relative;display:flex;align-items:center;min-width:0}
.ilp-tabs__list{display:flex;position:relative;min-width:0;scrollbar-width:none;-ms-overflow-style:none}
.ilp-tabs__list::-webkit-scrollbar{display:none}
.ilp-tabs--scroll .ilp-tabs__list{overflow-x:auto;scroll-behavior:smooth}

.ilp-tab{position:relative;display:inline-flex;align-items:center;gap:8px;flex:none;appearance:none;background:none;border:0;cursor:pointer;font-family:inherit;font-weight:var(--weight-semibold);color:var(--text-secondary);white-space:nowrap;transition:color var(--dur-fast) var(--ease-standard),background var(--dur-fast) var(--ease-standard)}
.ilp-tab:focus-visible{outline:none;box-shadow:var(--ring);border-radius:var(--radius-sm);z-index:1}
.ilp-tab[disabled]{opacity:.42;cursor:not-allowed}
.ilp-tab svg{width:16px;height:16px;flex:none}
.ilp-tab__count{font-size:var(--fs-xs);font-weight:var(--weight-bold);background:var(--il-grayblue-100);color:var(--text-secondary);padding:1px 7px;border-radius:var(--radius-pill);font-variant-numeric:tabular-nums}
.ilp-tab__dot{width:7px;height:7px;flex:none;border-radius:50%;background:var(--brand-primary)}
.ilp-tab__dot--danger{background:var(--status-danger)}
.ilp-tab__dot--warning{background:var(--status-warning)}

/* sizes */
.ilp-tabs--sm .ilp-tab{font-size:var(--fs-sm)}
.ilp-tabs--md .ilp-tab{font-size:var(--fs-base)}
.ilp-tabs--lg .ilp-tab{font-size:var(--fs-lg)}

/* ---- line ---- */
.ilp-tabs--line .ilp-tabs__list{gap:24px;border-bottom:1px solid var(--border-subtle)}
.ilp-tabs--line.ilp-tabs--sm .ilp-tab{padding:9px 1px}
.ilp-tabs--line.ilp-tabs--md .ilp-tab{padding:12px 2px}
.ilp-tabs--line.ilp-tabs--lg .ilp-tab{padding:15px 2px}
.ilp-tabs--line .ilp-tab:hover:not([disabled]){color:var(--text-primary)}
.ilp-tabs--line .ilp-tab[aria-selected="true"]{color:var(--text-brand)}
.ilp-tabs--line .ilp-tab[aria-selected="true"] .ilp-tab__count{background:var(--il-blue-100);color:var(--text-brand)}
.ilp-tabs__ink{position:absolute;bottom:0;height:2px;border-radius:2px 2px 0 0;background:var(--brand-primary);transition:transform var(--dur-normal) var(--ease-standard),width var(--dur-normal) var(--ease-standard);pointer-events:none}

/* ---- pill ---- */
.ilp-tabs--pill .ilp-tabs__list{background:var(--il-grayblue-100);padding:4px;border-radius:var(--radius-md);gap:2px}
.ilp-tabs--pill .ilp-tab{padding:7px 15px;border-radius:var(--radius-sm)}
.ilp-tabs--pill.ilp-tabs--sm .ilp-tab{padding:5px 12px}
.ilp-tabs--pill.ilp-tabs--lg .ilp-tab{padding:10px 20px}
.ilp-tabs--pill .ilp-tab:hover:not([disabled]){color:var(--text-primary)}
.ilp-tabs--pill .ilp-tab[aria-selected="true"]{background:var(--surface-card);color:var(--text-primary);box-shadow:var(--shadow-xs)}

/* ---- enclosed ---- */
.ilp-tabs--enclosed .ilp-tabs__list{gap:3px;border-bottom:1px solid var(--border-default)}
.ilp-tabs--enclosed .ilp-tab{padding:10px 18px;margin-bottom:-1px;border:1px solid transparent;border-radius:var(--radius-md) var(--radius-md) 0 0}
.ilp-tabs--enclosed .ilp-tab:hover:not([disabled]){color:var(--text-primary);background:var(--il-grayblue-50)}
.ilp-tabs--enclosed .ilp-tab[aria-selected="true"]{color:var(--text-primary);background:var(--surface-card);border-color:var(--border-default);border-bottom-color:var(--surface-card)}

/* ---- vertical ---- */
.ilp-tabs--vertical{flex:none;min-width:180px}
.ilp-tabs--vertical .ilp-tabs__wrap{display:block}
.ilp-tabs--vertical .ilp-tabs__list{flex-direction:column;gap:2px;width:100%;border-bottom:0;border-right:1px solid var(--border-subtle);padding-right:0}
.ilp-tabs--vertical .ilp-tab{justify-content:flex-start;width:100%;padding:10px 14px;border-radius:var(--radius-md) 0 0 var(--radius-md);text-align:left}
.ilp-tabs--vertical .ilp-tab .ilp-tab__count{margin-left:auto}
.ilp-tabs--vertical .ilp-tab[aria-selected="true"]{background:var(--il-blue-50);color:var(--text-brand)}
.ilp-tabs--vertical .ilp-tabs__ink{bottom:auto;right:-1px;width:2px !important;height:0;border-radius:2px 0 0 2px;transition:transform var(--dur-normal) var(--ease-standard),height var(--dur-normal) var(--ease-standard)}

/* ---- overflow controls ---- */
.ilp-tabs__nav{display:grid;place-items:center;width:28px;height:28px;flex:none;padding:0;color:var(--text-secondary);background:var(--surface-card);border:1px solid var(--border-default);border-radius:var(--radius-sm);cursor:pointer;z-index:2}
.ilp-tabs__nav:hover{background:var(--surface-hover);color:var(--text-primary)}
.ilp-tabs__nav[disabled]{opacity:.35;cursor:not-allowed}
.ilp-tabs__nav svg{width:15px;height:15px}
.ilp-tabs__nav--l{margin-right:8px}
.ilp-tabs__nav--r{margin-left:8px}
.ilp-tabs__fade{position:absolute;top:0;bottom:1px;width:36px;pointer-events:none;z-index:1}
.ilp-tabs__fade--l{left:0;background:linear-gradient(90deg,var(--surface-card),transparent)}
.ilp-tabs__fade--r{right:0;background:linear-gradient(270deg,var(--surface-card),transparent)}
`;

function useCSS() {
  React.useEffect(() => {
    if (document.getElementById('ilp-tabs-css')) return;
    const s = document.createElement('style');
    s.id = 'ilp-tabs-css';
    s.textContent = CSS;
    document.head.appendChild(s);
  }, []);
}

const IcLeft = (p) => <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.4" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true" {...p}><path d="M15 5l-7 7 7 7" /></svg>;
const IcRight = (p) => <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.4" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true" {...p}><path d="M9 5l7 7-7 7" /></svg>;

/**
 * Tab strip implementing the WAI-ARIA tabs pattern: roving tabindex, arrow-key
 * navigation, Home/End, and automatic or manual activation. Overflowing strips
 * scroll with edge fades and step buttons instead of wrapping.
 */
export function Tabs({
  tabs = [],
  value,
  onChange,
  variant = 'line',
  size = 'md',
  orientation = 'horizontal',
  activation = 'automatic',
  scrollable = true,
  idPrefix,
  className = '',
  ...rest
}) {
  useCSS();
  const vertical = orientation === 'vertical';
  const [internal, setInternal] = React.useState(value ?? tabs[0]?.value);
  const active = value !== undefined ? value : internal;
  const activeIndex = Math.max(0, tabs.findIndex((t) => t.value === active));
  const [focusIndex, setFocusIndex] = React.useState(activeIndex);
  const [ink, setInk] = React.useState(null);
  const [overflow, setOverflow] = React.useState({ left: false, right: false });

  const listRef = React.useRef(null);
  const btnRefs = React.useRef([]);
  const auto = React.useId();
  const prefix = idPrefix || auto;

  React.useEffect(() => { setFocusIndex(activeIndex); }, [activeIndex]);

  const select = (v) => {
    if (value === undefined) setInternal(v);
    onChange && onChange(v);
  };

  /* sliding indicator — measured, so it survives font loading and resize */
  const measure = React.useCallback(() => {
    const list = listRef.current;
    const el = btnRefs.current[activeIndex];
    if (!list || !el) return;
    setInk(vertical
      ? { transform: `translateY(${el.offsetTop}px)`, height: el.offsetHeight, width: 2 }
      : { transform: `translateX(${el.offsetLeft}px)`, width: el.offsetWidth });
    setOverflow({
      left: list.scrollLeft > 2,
      right: list.scrollLeft + list.clientWidth < list.scrollWidth - 2,
    });
  }, [activeIndex, vertical]);

  React.useEffect(() => {
    measure();
    const list = listRef.current;
    if (!list || typeof ResizeObserver === 'undefined') return;
    const ro = new ResizeObserver(measure);
    ro.observe(list);
    return () => ro.disconnect();
  }, [measure, tabs.length]);

  /* keep the active tab in view when it changes off-screen */
  React.useEffect(() => {
    const el = btnRefs.current[activeIndex];
    const list = listRef.current;
    if (!el || !list || vertical) return;
    const left = el.offsetLeft;
    const right = left + el.offsetWidth;
    if (left < list.scrollLeft) list.scrollLeft = left - 16;
    else if (right > list.scrollLeft + list.clientWidth) list.scrollLeft = right - list.clientWidth + 16;
  }, [activeIndex, vertical]);

  const step = (dir) => {
    const list = listRef.current;
    if (list) list.scrollLeft += dir * Math.max(160, list.clientWidth * 0.7);
  };

  const focusTab = (i) => {
    setFocusIndex(i);
    btnRefs.current[i]?.focus();
    if (activation === 'automatic' && !tabs[i].disabled) select(tabs[i].value);
  };

  const nextEnabled = (from, dir) => {
    for (let n = 1; n <= tabs.length; n++) {
      const i = (from + dir * n + tabs.length * n) % tabs.length;
      if (!tabs[i].disabled) return i;
    }
    return from;
  };

  const onKeyDown = (e) => {
    const prevKey = vertical ? 'ArrowUp' : 'ArrowLeft';
    const nextKey = vertical ? 'ArrowDown' : 'ArrowRight';
    if (e.key === nextKey) { e.preventDefault(); focusTab(nextEnabled(focusIndex, 1)); }
    else if (e.key === prevKey) { e.preventDefault(); focusTab(nextEnabled(focusIndex, -1)); }
    else if (e.key === 'Home') { e.preventDefault(); focusTab(nextEnabled(-1, 1)); }
    else if (e.key === 'End') { e.preventDefault(); focusTab(nextEnabled(0, -1)); }
    else if ((e.key === 'Enter' || e.key === ' ') && activation === 'manual') {
      e.preventDefault();
      if (!tabs[focusIndex].disabled) select(tabs[focusIndex].value);
    }
  };

  const list = (
    <div
      className="ilp-tabs__list" role="tablist" ref={listRef}
      aria-orientation={orientation} onKeyDown={onKeyDown}
      onScroll={measure}
    >
      {tabs.map((t, i) => (
        <button
          key={t.value}
          ref={(el) => { btnRefs.current[i] = el; }}
          type="button" role="tab" className="ilp-tab"
          id={`${prefix}-tab-${t.value}`}
          aria-controls={`${prefix}-panel-${t.value}`}
          aria-selected={active === t.value}
          tabIndex={focusIndex === i ? 0 : -1}
          disabled={t.disabled}
          onClick={() => !t.disabled && select(t.value)}
          onFocus={() => setFocusIndex(i)}
        >
          {t.icon}
          {t.label}
          {t.dot && <span className={'ilp-tab__dot' + (t.dot !== true ? ' ilp-tab__dot--' + t.dot : '')} />}
          {t.count != null && <span className="ilp-tab__count">{t.count}</span>}
        </button>
      ))}
      {(variant === 'line' || vertical) && ink && <span className="ilp-tabs__ink" style={ink} />}
    </div>
  );

  const canScroll = scrollable && !vertical;

  return (
    <div
      className={['ilp-tabs', `ilp-tabs--${variant}`, `ilp-tabs--${size}`,
        vertical ? 'ilp-tabs--vertical' : '', canScroll ? 'ilp-tabs--scroll' : '', className]
        .filter(Boolean).join(' ')}
      {...rest}
    >
      <div className="ilp-tabs__wrap">
        {canScroll && (overflow.left || overflow.right) && (
          <button type="button" className="ilp-tabs__nav ilp-tabs__nav--l" aria-label="Scroll tabs left" disabled={!overflow.left} onClick={() => step(-1)}><IcLeft /></button>
        )}
        {canScroll && overflow.left && <span className="ilp-tabs__fade ilp-tabs__fade--l" />}
        {list}
        {canScroll && overflow.right && <span className="ilp-tabs__fade ilp-tabs__fade--r" style={{ right: overflow.right ? 36 : 0 }} />}
        {canScroll && (overflow.left || overflow.right) && (
          <button type="button" className="ilp-tabs__nav ilp-tabs__nav--r" aria-label="Scroll tabs right" disabled={!overflow.right} onClick={() => step(1)}><IcRight /></button>
        )}
      </div>
    </div>
  );
}

/** Panel paired with a tab. Give it the same `idPrefix` as its Tabs. */
export function TabPanel({ value, active, idPrefix, className = '', children, ...rest }) {
  useCSS();
  if (value !== active) return null;
  return (
    <div
      role="tabpanel" tabIndex={0}
      id={`${idPrefix}-panel-${value}`}
      aria-labelledby={`${idPrefix}-tab-${value}`}
      className={className}
      {...rest}
    >
      {children}
    </div>
  );
}
