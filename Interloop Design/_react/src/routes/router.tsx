import { createRootRoute, createRoute, createRouter, Outlet } from '@tanstack/react-router';
import { RootLayout } from '@/components/layout/root-layout';
import { DashboardPage } from './pages/dashboard';
import { OrdersPage } from './pages/orders';
import { OrderDetailPage } from './pages/order-detail';
import { DesignSystemPage } from './pages/design-system';
import { DocumentPage } from './pages/document';
import { Button } from '@/components/ui/button';

const rootRoute = createRootRoute({
  component: () => <RootLayout />,
  notFoundComponent: () => (
    <div className="flex flex-col items-center gap-3 p-20 text-center">
      <p className="text-6xl font-extrabold tracking-tight text-[var(--il-grayblue-300)]">404</p>
      <h1 className="text-xl font-bold">That page does not exist</h1>
      <p className="text-sm text-muted-foreground">Check the link, or head back to the dashboard.</p>
      <Button asChild className="mt-2"><a href="/">Go to dashboard</a></Button>
    </div>
  ),
});

/**
 * AUTH SEAM: add `beforeLoad: authGuard` here — and
 * `createPermissionGuard('LoopConsole.Orders')` on the protected routes —
 * once `@volo/abp-react-oidc-auth` is wired.
 */
const indexRoute = createRoute({ getParentRoute: () => rootRoute, path: '/', component: DashboardPage });

const ordersRoute = createRoute({ getParentRoute: () => rootRoute, path: '/orders', component: () => <Outlet /> });
const ordersIndexRoute = createRoute({ getParentRoute: () => ordersRoute, path: '/', component: OrdersPage });
const orderDetailRoute = createRoute({ getParentRoute: () => ordersRoute, path: '$orderId', component: OrderDetailPage });

const designSystemRoute = createRoute({ getParentRoute: () => rootRoute, path: '/design-system', component: () => <Outlet /> });
const designSystemIndexRoute = createRoute({ getParentRoute: () => designSystemRoute, path: '/', component: DesignSystemPage });
const documentRoute = createRoute({ getParentRoute: () => designSystemRoute, path: 'document', component: DocumentPage });

const routeTree = rootRoute.addChildren([
  indexRoute,
  ordersRoute.addChildren([ordersIndexRoute, orderDetailRoute]),
  designSystemRoute.addChildren([designSystemIndexRoute, documentRoute]),
]);

export const router = createRouter({ routeTree, defaultPreload: 'intent' });

declare module '@tanstack/react-router' {
  interface Register {
    router: typeof router;
  }
}
