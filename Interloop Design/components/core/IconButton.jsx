import React from 'react';

const CSS = `
.ilp-iconbtn {
  display: inline-flex; align-items: center; justify-content: center;
  border: 1px solid transparent; background: transparent; color: var(--text-secondary);
  border-radius: var(--radius-md); cursor: pointer; flex: none;
  transition: background var(--dur-fast) var(--ease-standard), color var(--dur-fast) var(--ease-standard), transform var(--dur-fast) var(--ease-standard);
}
.ilp-iconbtn:hover:not([disabled]) { background: var(--surface-hover); color: var(--text-primary); }
.ilp-iconbtn:active:not([disabled]) { transform: scale(0.94); }
.ilp-iconbtn:focus-visible { outline: none; box-shadow: var(--ring); }
.ilp-iconbtn[disabled] { opacity: .45; cursor: not-allowed; }
.ilp-iconbtn--sm { width: 32px; height: 32px; }
.ilp-iconbtn--md { width: 40px; height: 40px; }
.ilp-iconbtn--lg { width: 48px; height: 48px; }
.ilp-iconbtn--solid { background: var(--brand-primary); color: #fff; }
.ilp-iconbtn--solid:hover:not([disabled]) { background: var(--brand-primary-hover); color: #fff; }
.ilp-iconbtn--outline { border-color: var(--border-default); }
.ilp-iconbtn--outline:hover:not([disabled]) { border-color: var(--border-strong); background: var(--surface-hover); }
.ilp-iconbtn svg, .ilp-iconbtn i { width: 1.15em; height: 1.15em; }
.ilp-iconbtn--sm { font-size: 15px; }
.ilp-iconbtn--md { font-size: 18px; }
.ilp-iconbtn--lg { font-size: 20px; }
`;

function useCSS() {
  React.useEffect(() => {
    if (document.getElementById('ilp-iconbtn-css')) return;
    const s = document.createElement('style');
    s.id = 'ilp-iconbtn-css'; s.textContent = CSS; document.head.appendChild(s);
  }, []);
}

/** Square icon-only button — toolbar actions, table row actions, topbar controls. */
export function IconButton({
  variant = 'ghost',  // 'ghost' | 'solid' | 'outline'
  size = 'md',
  label,
  className = '',
  children,
  ...rest
}) {
  useCSS();
  const cls = ['ilp-iconbtn', `ilp-iconbtn--${variant}`, `ilp-iconbtn--${size}`, className].filter(Boolean).join(' ');
  return (
    <button type="button" className={cls} aria-label={label} title={label} {...rest}>
      {children}
    </button>
  );
}
