import { Link, useRouterState } from '@tanstack/react-router';
import { useTranslation } from 'react-i18next';
import { cn } from '@/lib/utils';
import { Logo } from '@/components/brand/logo';
import { mainMenu } from '@/lib/routing/route-config';

export function AppSidebar({ collapsed = false }: { collapsed?: boolean }) {
  const { t } = useTranslation();
  const pathname = useRouterState({ select: (s) => s.location.pathname });

  return (
    <nav className={cn('flex h-full shrink-0 flex-col bg-sidebar text-sidebar-foreground transition-[width] duration-200', collapsed ? 'w-[76px]' : 'w-[264px]')}>
      <div className={cn('flex h-16 items-center border-b border-sidebar-border', collapsed ? 'justify-center px-2' : 'px-5')}>
        <Logo variant={collapsed ? 'mark' : 'wordmark'} tone="white" height={collapsed ? 26 : 22} />
      </div>

      <ul className="flex-1 space-y-0.5 overflow-y-auto p-3">
        {mainMenu.map((item) =>
          item.section ? (
            <li key={item.key} className={cn('px-3 pb-1.5 pt-5 text-[10px] font-bold uppercase tracking-[0.09em] text-white/40', collapsed && 'text-center')}>
              {collapsed ? '·' : item.labelKey}
            </li>
          ) : (
            <li key={item.key}>
              <Link
                to={item.to}
                title={collapsed ? t(item.labelKey) : undefined}
                className={cn(
                  'flex items-center gap-3 rounded-md px-3 py-2.5 text-sm font-semibold text-white/70 no-underline transition-colors duration-[120ms] hover:bg-sidebar-accent hover:text-white',
                  (pathname === item.to || (item.to !== '/' && pathname.startsWith(item.to))) && 'bg-primary text-white hover:bg-primary',
                  collapsed && 'justify-center px-0',
                )}
              >
                {item.icon && <item.icon className="size-[18px] shrink-0" />}
                {!collapsed && <span className="truncate">{t(item.labelKey)}</span>}
                {!collapsed && item.badge != null && (
                  <span className="ml-auto rounded-full bg-white/15 px-2 py-0.5 text-[11px] font-bold tabular-nums">{item.badge}</span>
                )}
              </Link>
            </li>
          ),
        )}
      </ul>

      {!collapsed && (
        <div className="border-t border-sidebar-border p-4 text-[11px] leading-relaxed text-white/45">
          Loop Console · v0.1.0
          <br />
          Interloop Design System
        </div>
      )}
    </nav>
  );
}
