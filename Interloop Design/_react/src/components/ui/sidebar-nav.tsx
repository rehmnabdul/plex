import * as React from 'react';
import { cn } from '@/lib/utils';

export interface SidebarNavItem {
  key: string;
  label: string;
  icon?: React.ReactNode;
  badge?: number | string;
  /** Section heading rather than a link. */
  section?: boolean;
  disabled?: boolean;
}

export interface SidebarNavProps extends Omit<React.HTMLAttributes<HTMLElement>, 'onSelect'> {
  items: SidebarNavItem[];
  activeKey?: string;
  onSelect?: (key: string) => void;
  /** Icon rail only. @default false */
  collapsed?: boolean;
  /** Rendered above the list — usually the Logo. */
  header?: React.ReactNode;
  footer?: React.ReactNode;
}

export function SidebarNav({
  items, activeKey, onSelect, collapsed = false, header, footer, className, ...props
}: SidebarNavProps) {
  return (
    <nav
      className={cn(
        'flex h-full flex-col bg-sidebar text-sidebar-foreground transition-[width] duration-200',
        collapsed ? 'w-[76px]' : 'w-[264px]',
        className,
      )}
      {...props}
    >
      {header && <div className={cn('flex h-16 items-center border-b border-sidebar-border', collapsed ? 'justify-center px-2' : 'px-5')}>{header}</div>}

      <ul className="flex-1 space-y-0.5 overflow-y-auto p-3">
        {items.map((item) =>
          item.section ? (
            <li key={item.key} className={cn('px-3 pb-1.5 pt-5 text-[10px] font-bold uppercase tracking-[0.09em] text-white/40', collapsed && 'text-center')}>
              {collapsed ? '·' : item.label}
            </li>
          ) : (
            <li key={item.key}>
              <button
                type="button"
                disabled={item.disabled}
                aria-current={activeKey === item.key ? 'page' : undefined}
                title={collapsed ? item.label : undefined}
                onClick={() => onSelect?.(item.key)}
                className={cn(
                  'group flex w-full items-center gap-3 rounded-md px-3 py-2.5 text-sm font-semibold transition-colors duration-[120ms]',
                  'text-white/70 hover:bg-sidebar-accent hover:text-white disabled:opacity-40 disabled:hover:bg-transparent',
                  activeKey === item.key && 'bg-primary text-white hover:bg-primary',
                  collapsed && 'justify-center px-0',
                  '[&_svg]:size-[18px] [&_svg]:shrink-0',
                )}
              >
                {item.icon}
                {!collapsed && <span className="truncate">{item.label}</span>}
                {!collapsed && item.badge != null && (
                  <span className="ml-auto rounded-full bg-white/15 px-2 py-0.5 text-[11px] font-bold tabular-nums">{item.badge}</span>
                )}
              </button>
            </li>
          ),
        )}
      </ul>

      {footer && <div className="border-t border-sidebar-border p-3">{footer}</div>}
    </nav>
  );
}
