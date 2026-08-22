import React from 'react';

const CSS = `
.ilp-btn {
  --_bg: var(--brand-primary);
  --_fg: #fff;
  --_bd: transparent;
  display: inline-flex; align-items: center; justify-content: center; gap: 8px;
  font-family: var(--font-sans); font-weight: var(--weight-bold);
  border: 1px solid var(--_bd); background: var(--_bg); color: var(--_fg);
  border-radius: var(--radius-md); cursor: pointer; white-space: nowrap;
  text-decoration: none; line-height: 1; letter-spacing: -0.005em;
  transition: background var(--dur-fast) var(--ease-standard),
              border-color var(--dur-fast) var(--ease-standard),
              transform var(--dur-fast) var(--ease-standard),
              box-shadow var(--dur-fast) var(--ease-standard);
}
.ilp-btn:focus-visible { outline: none; box-shadow: var(--ring); }
.ilp-btn:active { transform: scale(0.975); }
.ilp-btn[disabled], .ilp-btn[aria-disabled="true"] { opacity: .5; cursor: not-allowed; transform: none; }

/* sizes */
.ilp-btn--sm { height: 32px; padding: 0 12px; font-size: var(--fs-sm); }
.ilp-btn--md { height: 40px; padding: 0 18px; font-size: var(--fs-base); }
.ilp-btn--lg { height: 48px; padding: 0 24px; font-size: var(--fs-lg); }

/* variants */
.ilp-btn--primary { --_bg: var(--brand-primary); --_fg: #fff; }
.ilp-btn--primary:hover:not([disabled]) { --_bg: var(--brand-primary-hover); box-shadow: var(--shadow-brand); }
.ilp-btn--primary:active:not([disabled]) { --_bg: var(--brand-primary-active); }

.ilp-btn--ink { --_bg: var(--brand-ink); --_fg: #fff; }
.ilp-btn--ink:hover:not([disabled]) { --_bg: var(--brand-ink-hover); }

.ilp-btn--secondary { --_bg: var(--surface-card); --_fg: var(--text-primary); --_bd: var(--border-default); }
.ilp-btn--secondary:hover:not([disabled]) { --_bg: var(--surface-hover); --_bd: var(--border-strong); }

.ilp-btn--ghost { --_bg: transparent; --_fg: var(--text-secondary); --_bd: transparent; }
.ilp-btn--ghost:hover:not([disabled]) { --_bg: var(--surface-hover); --_fg: var(--text-primary); }

.ilp-btn--danger { --_bg: var(--status-danger); --_fg: #fff; }
.ilp-btn--danger:hover:not([disabled]) { --_bg: var(--il-red-600); }

.ilp-btn--block { width: 100%; }
.ilp-btn__spin { width: 15px; height: 15px; border-radius: 50%; border: 2px solid currentColor; border-right-color: transparent; animation: ilp-spin .6s linear infinite; }
@keyframes ilp-spin { to { transform: rotate(360deg); } }
`;

function useCSS() {
  React.useEffect(() => {
    if (document.getElementById('ilp-btn-css')) return;
    const s = document.createElement('style');
    s.id = 'ilp-btn-css';
    s.textContent = CSS;
    document.head.appendChild(s);
  }, []);
}

/** Primary action button with brand variants, sizes, icons and loading state. */
export function Button({
  variant = 'primary',
  size = 'md',
  block = false,
  loading = false,
  leadingIcon = null,
  trailingIcon = null,
  as = 'button',
  className = '',
  children,
  disabled,
  ...rest
}) {
  useCSS();
  const Tag = as;
  const cls = ['ilp-btn', `ilp-btn--${variant}`, `ilp-btn--${size}`, block ? 'ilp-btn--block' : '', className]
    .filter(Boolean).join(' ');
  const isDisabled = disabled || loading;
  return (
    <Tag
      className={cls}
      disabled={Tag === 'button' ? isDisabled : undefined}
      aria-disabled={isDisabled || undefined}
      {...rest}
    >
      {loading && <span className="ilp-btn__spin" aria-hidden="true" />}
      {!loading && leadingIcon}
      {children}
      {!loading && trailingIcon}
    </Tag>
  );
}
