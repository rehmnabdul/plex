import React from 'react';
import { Logo } from '../brand/Logo.jsx';

const CSS = `
.ilp-sb{position:relative;display:flex;flex-direction:column;height:100%;flex:none;width:var(--sidebar-width);background:var(--il-grayblue-700);color:#fff;font-family:var(--font-sans);transition:width var(--dur-normal) var(--ease-standard)}
.ilp-sb *{box-sizing:border-box}
.ilp-sb--collapsed{width:var(--sidebar-width-collapsed)}
.ilp-sb--light{background:var(--surface-card);color:var(--text-primary);border-right:1px solid var(--border-subtle)}

.ilp-sb__brand{display:flex;align-items:center;gap:10px;height:var(--topbar-height);padding:0 20px;flex:none}
.ilp-sb--collapsed .ilp-sb__brand{padding:0;justify-content:center}
.ilp-sb__toggle{display:grid;place-items:center;width:30px;height:30px;margin-left:auto;padding:0;color:inherit;background:transparent;border:0;border-radius:var(--radius-sm);cursor:pointer;opacity:.6}
.ilp-sb__toggle:hover{opacity:1;background:rgba(255,255,255,.1)}
.ilp-sb--light .ilp-sb__toggle:hover{background:var(--surface-hover)}
.ilp-sb__toggle svg{width:17px;height:17px}
.ilp-sb--collapsed .ilp-sb__toggle{display:none}

.ilp-sb__find{flex:none;padding:4px 12px 8px;position:relative}
.ilp-sb--collapsed .ilp-sb__find{display:none}
.ilp-sb__find input{width:100%;height:36px;padding:0 12px 0 34px;font:inherit;font-size:var(--fs-sm);color:#fff;background:rgba(255,255,255,.08);border:1px solid rgba(255,255,255,.12);border-radius:var(--radius-md);outline:none}
.ilp-sb__find input::placeholder{color:rgba(255,255,255,.45)}
.ilp-sb__find input:focus{border-color:var(--il-blue-400);background:rgba(255,255,255,.12)}
.ilp-sb--light .ilp-sb__find input{color:var(--text-primary);background:var(--il-grayblue-50);border-color:var(--border-default)}
.ilp-sb--light .ilp-sb__find input::placeholder{color:var(--text-muted)}
.ilp-sb__find svg{position:absolute;left:24px;top:50%;transform:translateY(-42%);width:15px;height:15px;opacity:.5;pointer-events:none}

.ilp-sb__scroll{flex:1 1 auto;min-height:0;overflow-y:auto;overflow-x:hidden;padding:8px 12px 20px}
.ilp-sb--collapsed .ilp-sb__scroll{padding:8px 10px 20px;overflow:visible}
.ilp-sb__sec{padding:16px 12px 7px;font-size:var(--fs-2xs);font-weight:var(--weight-bold);text-transform:uppercase;letter-spacing:var(--tracking-wider);color:rgba(255,255,255,.4)}
.ilp-sb--light .ilp-sb__sec{color:var(--text-muted)}
.ilp-sb--collapsed .ilp-sb__sec{margin:10px 8px 6px;padding:0;height:1px;background:rgba(255,255,255,.14);overflow:hidden;text-indent:-999px}
.ilp-sb__rule{height:1px;margin:10px 12px;background:rgba(255,255,255,.1)}
.ilp-sb--light .ilp-sb__rule{background:var(--border-subtle)}

.ilp-nv{position:relative;display:flex;align-items:center;gap:12px;width:100%;margin-bottom:2px;padding:10px 12px;text-align:left;font-family:inherit;font-size:var(--fs-base);font-weight:var(--weight-semibold);color:rgba(255,255,255,.78);background:none;border:0;border-radius:var(--radius-md);cursor:pointer;transition:background var(--dur-fast) var(--ease-standard),color var(--dur-fast) var(--ease-standard)}
.ilp-sb--light .ilp-nv{color:var(--text-secondary)}
.ilp-nv:hover{background:rgba(255,255,255,.07);color:#fff}
.ilp-sb--light .ilp-nv:hover{background:var(--surface-hover);color:var(--text-primary)}
.ilp-nv:focus-visible{outline:none;box-shadow:var(--ring)}
.ilp-nv[disabled]{opacity:.4;cursor:not-allowed}
.ilp-nv__ic{display:flex;flex:none;width:20px;height:20px;opacity:.9}
.ilp-nv__ic svg{width:20px;height:20px}
.ilp-nv__lb{flex:1;min-width:0;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.ilp-nv__bd{flex:none;padding:2px 7px;font-size:var(--fs-2xs);font-weight:var(--weight-bold);font-variant-numeric:tabular-nums;color:#fff;background:var(--il-blue-500);border-radius:var(--radius-pill)}
.ilp-nv__bd--danger{background:var(--status-danger)}
.ilp-nv__bd--soft{background:rgba(255,255,255,.16)}
.ilp-sb--light .ilp-nv__bd--soft{background:var(--il-grayblue-100);color:var(--text-secondary)}
.ilp-nv__cx{flex:none;width:15px;height:15px;opacity:.55;transition:transform var(--dur-fast) var(--ease-standard)}
.ilp-nv__cx--open{transform:rotate(90deg)}

.ilp-nv--on{color:#fff;background:var(--il-blue-500);box-shadow:var(--shadow-brand)}
.ilp-nv--on:hover{background:var(--il-blue-500)}
.ilp-nv--on .ilp-nv__ic{opacity:1}
.ilp-nv--on .ilp-nv__bd{background:rgba(255,255,255,.25)}
.ilp-sb--light .ilp-nv--on{color:#fff}
/* parent of the active route — marked, not selected */
.ilp-nv--trail{color:#fff}
.ilp-nv--trail .ilp-nv__ic{opacity:1}

/* nested */
.ilp-sb__kids{overflow:hidden;margin:1px 0 4px}
.ilp-sb__kids .ilp-nv{padding-left:44px;font-size:var(--fs-sm);font-weight:var(--weight-semibold);color:rgba(255,255,255,.62)}
.ilp-sb--light .ilp-sb__kids .ilp-nv{color:var(--text-muted)}
.ilp-sb__kids .ilp-nv::before{content:"";position:absolute;left:21px;top:0;bottom:0;width:1.5px;background:rgba(255,255,255,.14)}
.ilp-sb--light .ilp-sb__kids .ilp-nv::before{background:var(--border-default)}
.ilp-sb__kids .ilp-nv--on{color:#fff;background:rgba(255,255,255,.1);box-shadow:none}
.ilp-sb__kids .ilp-nv--on::before{background:var(--il-blue-400);width:2px}
.ilp-sb--light .ilp-sb__kids .ilp-nv--on{background:var(--il-blue-50);color:var(--text-brand)}

/* collapsed rail + flyout */
.ilp-sb--collapsed .ilp-nv{justify-content:center;padding:11px 0;gap:0}
.ilp-sb--collapsed .ilp-nv__lb,.ilp-sb--collapsed .ilp-nv__cx{display:none}
.ilp-sb--collapsed .ilp-nv__bd{position:absolute;top:4px;right:6px;min-width:8px;padding:0;width:8px;height:8px;font-size:0;line-height:0}
.ilp-sb__fly{position:absolute;left:calc(100% + 8px);top:0;z-index:900;min-width:206px;padding:6px;background:var(--surface-card);border:1px solid var(--border-default);border-radius:var(--radius-md);box-shadow:var(--shadow-lg);animation:ilp-sb-in var(--dur-fast) var(--ease-out)}
@keyframes ilp-sb-in{from{opacity:0;transform:translateX(-4px)}}
.ilp-sb__fly b{display:block;padding:6px 10px 7px;font-size:var(--fs-xs);font-weight:var(--weight-bold);letter-spacing:.06em;text-transform:uppercase;color:var(--text-muted)}
.ilp-sb__fly button{display:flex;align-items:center;gap:9px;width:100%;padding:8px 10px;font:inherit;font-size:var(--fs-sm);font-weight:var(--weight-semibold);color:var(--text-primary);background:none;border:0;border-radius:var(--radius-sm);cursor:pointer;text-align:left}
.ilp-sb__fly button:hover{background:var(--surface-hover)}
.ilp-sb__fly button[aria-current="page"]{color:var(--text-brand);background:var(--il-blue-50)}

.ilp-sb__empty{padding:20px 12px;font-size:var(--fs-sm);color:rgba(255,255,255,.5);text-align:center}
.ilp-sb--light .ilp-sb__empty{color:var(--text-muted)}
.ilp-sb__foot{flex:none;padding:12px;border-top:1px solid rgba(255,255,255,.1)}
.ilp-sb--light .ilp-sb__foot{border-top-color:var(--border-subtle)}
.ilp-sb--collapsed .ilp-sb__foot{padding:10px 8px}
`;

function useCSS() {
  React.useEffect(() => {
    if (document.getElementById('ilp-sidebar-css')) return;
    const s = document.createElement('style');
    s.id = 'ilp-sidebar-css';
    s.textContent = CSS;
    document.head.appendChild(s);
  }, []);
}

const IcChev = (p) => <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.4" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true" {...p}><path d="M9 5l7 7-7 7" /></svg>;
const IcPanel = (p) => <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true" {...p}><path d="M3 4h18v16H3z" /><path d="M9 4v16" /></svg>;
const IcSearch = (p) => <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" aria-hidden="true" {...p}><path d="M11 19a8 8 0 1 0 0-16 8 8 0 0 0 0 16Z" /><path d="m21 21-4.3-4.3" /></svg>;

const hasKey = (item, key) => item.key === key || (item.children || []).some((c) => c.key === key);
const matches = (item, q) => {
  if (!q) return true;
  const hit = (s) => String(s || '').toLowerCase().includes(q);
  return hit(item.label) || (item.children || []).some((c) => hit(c.label));
};

/**
 * App sidebar. Grouped, optionally nested navigation with a collapsible rail,
 * flyout submenus, and an optional filter for long menus.
 */
export function SidebarNav({
  sections = [],
  activeKey,
  onSelect,
  header,
  footer,
  collapsed = false,
  onToggleCollapse,
  tone = 'brand',
  filterable = false,
  filterPlaceholder = 'Find a page…',
  defaultOpenKeys,
  className = '',
  ...rest
}) {
  useCSS();
  const [query, setQuery] = React.useState('');
  const [open, setOpen] = React.useState(() => new Set(defaultOpenKeys || []));
  const [fly, setFly] = React.useState(null);

  /* the group holding the active route is always open — never hide where you are */
  React.useEffect(() => {
    if (!activeKey) return;
    setOpen((prev) => {
      const next = new Set(prev);
      for (const sec of sections) {
        for (const it of sec.items || []) {
          if ((it.children || []).some((c) => c.key === activeKey)) next.add(it.key);
        }
      }
      return next;
    });
  }, [activeKey, sections]);

  const q = query.trim().toLowerCase();
  const visible = sections
    .map((sec) => ({ ...sec, items: (sec.items || []).filter((it) => matches(it, q)) }))
    .filter((sec) => sec.items.length > 0);

  const toggle = (key) => setOpen((prev) => {
    const next = new Set(prev);
    next.has(key) ? next.delete(key) : next.add(key);
    return next;
  });

  const pick = (key) => onSelect && onSelect(key);

  const renderItem = (it) => {
    const kids = it.children || [];
    const isParent = kids.length > 0;
    const isOpen = open.has(it.key) || (!!q && isParent);
    const onTrail = isParent && hasKey(it, activeKey) && activeKey !== it.key;
    const isOn = activeKey === it.key;

    return (
      <div key={it.key} style={{ position: 'relative' }}
        onMouseEnter={collapsed && isParent ? () => setFly(it.key) : undefined}
        onMouseLeave={collapsed && isParent ? () => setFly(null) : undefined}
      >
        <button
          type="button"
          className={'ilp-nv' + (isOn ? ' ilp-nv--on' : '') + (onTrail ? ' ilp-nv--trail' : '')}
          aria-current={isOn ? 'page' : undefined}
          aria-expanded={isParent ? isOpen : undefined}
          disabled={it.disabled}
          title={collapsed ? it.label : undefined}
          onClick={() => (isParent && !collapsed ? toggle(it.key) : pick(it.key))}
        >
          {it.icon && <span className="ilp-nv__ic">{it.icon}</span>}
          <span className="ilp-nv__lb">{it.label}</span>
          {it.badge != null && (
            <span className={'ilp-nv__bd' + (it.badgeTone ? ' ilp-nv__bd--' + it.badgeTone : '')}>{it.badge}</span>
          )}
          {isParent && <IcChev className={'ilp-nv__cx' + (isOpen ? ' ilp-nv__cx--open' : '')} />}
        </button>

        {isParent && isOpen && !collapsed && (
          <div className="ilp-sb__kids">
            {kids.filter((c) => !q || String(c.label).toLowerCase().includes(q) || matches(it, q)).map((c) => (
              <button
                key={c.key} type="button"
                className={'ilp-nv' + (activeKey === c.key ? ' ilp-nv--on' : '')}
                aria-current={activeKey === c.key ? 'page' : undefined}
                disabled={c.disabled}
                onClick={() => pick(c.key)}
              >
                <span className="ilp-nv__lb">{c.label}</span>
                {c.badge != null && <span className={'ilp-nv__bd' + (c.badgeTone ? ' ilp-nv__bd--' + c.badgeTone : ' ilp-nv__bd--soft')}>{c.badge}</span>}
              </button>
            ))}
          </div>
        )}

        {isParent && collapsed && fly === it.key && (
          <div className="ilp-sb__fly">
            <b>{it.label}</b>
            {kids.map((c) => (
              <button key={c.key} type="button" aria-current={activeKey === c.key ? 'page' : undefined} onClick={() => pick(c.key)}>
                {c.label}
              </button>
            ))}
          </div>
        )}
      </div>
    );
  };

  return (
    <nav
      className={['ilp-sb', collapsed ? 'ilp-sb--collapsed' : '', tone === 'light' ? 'ilp-sb--light' : '', className].filter(Boolean).join(' ')}
      aria-label="Main"
      {...rest}
    >
      <div className="ilp-sb__brand">
        {header !== undefined ? header : <Logo size={collapsed ? 22 : 26} tone={tone === 'light' ? undefined : 'inverse'} />}
        {onToggleCollapse && (
          <button type="button" className="ilp-sb__toggle" aria-label="Collapse navigation" onClick={onToggleCollapse}><IcPanel /></button>
        )}
      </div>

      {filterable && (
        <div className="ilp-sb__find">
          <IcSearch />
          <input value={query} onChange={(e) => setQuery(e.target.value)} placeholder={filterPlaceholder} aria-label="Filter navigation" />
        </div>
      )}

      <div className="ilp-sb__scroll">
        {visible.length === 0 && <div className="ilp-sb__empty">No pages match “{query}”</div>}
        {visible.map((sec, i) => (
          <div key={sec.title || i}>
            {sec.rule && <div className="ilp-sb__rule" />}
            {sec.title && <div className="ilp-sb__sec">{sec.title}</div>}
            {sec.items.map(renderItem)}
          </div>
        ))}
      </div>

      {footer && <div className="ilp-sb__foot">{footer}</div>}
    </nav>
  );
}
