import React from 'react';

const CSS = `
.ilp-avatar { position: relative; display: inline-flex; align-items: center; justify-content: center;
  border-radius: var(--radius-pill); overflow: visible; flex: none; font-family: var(--font-sans);
  font-weight: var(--weight-bold); color: #fff; background: var(--il-blue-500); user-select: none; }
.ilp-avatar img { width: 100%; height: 100%; object-fit: cover; border-radius: inherit; }
.ilp-avatar--square { border-radius: var(--radius-md); }
.ilp-avatar__ring { position:absolute; inset:0; border-radius: inherit; box-shadow: 0 0 0 2px var(--surface-card); pointer-events:none; }
.ilp-avatar__status { position: absolute; right: 0; bottom: 0; border-radius: 50%;
  border: 2px solid var(--surface-card); width: 30%; height: 30%; min-width: 8px; min-height: 8px; }
.ilp-avatar__status--online { background: var(--status-success); }
.ilp-avatar__status--busy { background: var(--status-danger); }
.ilp-avatar__status--away { background: var(--status-warning); }
.ilp-avatar__status--offline { background: var(--il-grayblue-300); }
`;

const TONES = ['#30a8e0', '#6db7b7', '#aed250', '#f9a571', '#5a6577'];
function toneFor(s = '') { let h = 0; for (let i = 0; i < s.length; i++) h = (h * 31 + s.charCodeAt(i)) >>> 0; return TONES[h % TONES.length]; }
function initials(name = '') {
  const p = name.trim().split(/\s+/);
  return ((p[0]?.[0] || '') + (p.length > 1 ? p[p.length - 1][0] : '')).toUpperCase();
}

function useCSS() {
  React.useEffect(() => {
    if (document.getElementById('ilp-avatar-css')) return;
    const s = document.createElement('style');
    s.id = 'ilp-avatar-css'; s.textContent = CSS; document.head.appendChild(s);
  }, []);
}

/** User avatar — image or auto-colored initials, with optional presence dot. */
export function Avatar({
  src,
  name = '',
  size = 40,
  square = false,
  status,            // 'online' | 'busy' | 'away' | 'offline'
  ring = false,
  className = '',
  style = {},
  ...rest
}) {
  useCSS();
  const cls = ['ilp-avatar', square ? 'ilp-avatar--square' : '', className].filter(Boolean).join(' ');
  return (
    <span
      className={cls}
      style={{ width: size, height: size, fontSize: size * 0.4, background: src ? undefined : toneFor(name), ...style }}
      {...rest}
    >
      {src ? <img src={src} alt={name} /> : initials(name)}
      {ring && <span className="ilp-avatar__ring" />}
      {status && <span className={`ilp-avatar__status ilp-avatar__status--${status}`} />}
    </span>
  );
}
