import * as React from 'react';
import { Outlet, useRouterState } from '@tanstack/react-router';
import { useTranslation } from 'react-i18next';
import { AppSidebar } from './app-sidebar';
import { AppHeader } from './app-header';
import { mainMenu } from '@/lib/routing/route-config';

export function RootLayout() {
  const { t } = useTranslation();
  const [collapsed, setCollapsed] = React.useState(false);
  const pathname = useRouterState({ select: (s) => s.location.pathname });

  const entry = mainMenu.find((m) => !m.section && (m.to === pathname || (m.to !== '/' && pathname.startsWith(m.to))));
  const title = entry ? t(entry.labelKey) : 'Loop Console';

  return (
    <div className="flex h-screen overflow-hidden bg-background">
      <AppSidebar collapsed={collapsed} />
      <div className="flex min-w-0 flex-1 flex-col">
        <AppHeader title={title} onToggleSidebar={() => setCollapsed((c) => !c)} />
        <main className="min-h-0 flex-1 overflow-y-auto">
          <Outlet />
        </main>
      </div>
    </div>
  );
}
