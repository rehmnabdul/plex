# Loop Console — Interloop Design System (React)

The Interloop design system as a running Vite + React SPA, built on the stack the ABP Modern
template ships with. Every component is **source-owned** — it lives in this repo and you edit it
directly.

```bash
cp .env.example .env.local
npm install
npm run dev          # http://localhost:5173
npm test             # Vitest
npm run test:coverage
npm run build
```

Open **`/design-system`** to browse every component live.

## Stack

| Concern | Technology |
|---|---|
| Build | Vite 6 |
| UI | React 18 + TypeScript (strict) |
| Routing | TanStack Router (`src/routes/router.tsx`) |
| Server state | TanStack Query |
| Components | shadcn/ui-style primitives on Radix UI + Tailwind CSS v4 |
| Tables | TanStack Table + TanStack Virtual |
| Forms | React Hook Form + Zod (`zodResolver`) |
| HTTP | Axios — one shared instance, `src/lib/api/axios.ts` |
| Localization | i18next with ABP resource keys |
| Testing | Vitest + Testing Library |
| Auth | OIDC Authorization Code + PKCE — **seam only, see below** |

## Layout

```
src/
  components/
    ui/            shadcn primitives, re-skinned  (button, input, select, tabs, …)
    brand/         logo
    data/          data-grid, activity-feed
    documents/     report-document
    layout/        app shell (sidebar, header, root layout)
    orders/        feature components (T&A panel, production matrix, new-order form)
  lib/
    api/           axios instance + typed API modules + Zod types + mock dataset
    routing/       menu config, kept out of the router
    i18n.ts        ABP localization keys
    utils.ts       cn() + formatters
  routes/
    router.tsx     route tree
    pages/         dashboard · orders · order-detail · design-system · document
  styles/
    globals.css    the whole token system
```

## Tokens

`src/styles/globals.css` is the single source of truth. Interloop's palette sits in `:root` as
`--il-*` ramps; shadcn's semantic names (`--primary`, `--muted-foreground`, `--border`, …) point
at them; `@theme inline` exposes both to Tailwind.

Because shadcn's variable names are kept verbatim, `npx shadcn@latest add dialog` drops in a
component already wearing Interloop's clothes — no manual restyling.

Interloop-only additions: `--ink` (Gray Blue action), `--success/--warning/--info` with matching
`-soft` and `-ink` pairs, `--sidebar-*`, and the elements palette (`--il-earth/water/air/sun`).

## Component API

shadcn APIs are preserved, so anything written against upstream shadcn works here:

```tsx
<Button variant="destructive" size="sm">Delete</Button>
<Badge variant="success" dot>Shipped</Badge>
```

Extensions, not replacements: `Button variant="ink"`, `Badge variant="success" | "warning" | "solid"`,
`Button loading`, `Input invalid` / `startAdornment`, `IconButton badge`, plus the composites
(`StatCard`, `SidebarNav`, `DataGrid`, `ActivityFeed`, `ReportDocument`).

## Data layer

Every backend call is a typed function in `src/lib/api/`, consumed through TanStack Query.
Endpoints omit `/api` — the base URL supplies it.

```tsx
const { data, isFetching } = useQuery({
  queryKey: orderKeys.list(query),
  queryFn: () => ordersApi.list(query),
});
```

**Mocks.** `VITE_USE_MOCKS=true` (the default) serves a deterministic 4,820-row dataset from
`src/lib/api/mock-data.ts` with realistic latency, so the SPA runs with no backend. Set it to
`false` and point `VITE_API_URL` at your ABP host to switch to real endpoints — the API module is
the only file that changes behaviour.

The mock returns ABP's `{ items, totalCount }` envelope and accepts `skipCount` / `maxResultCount`
/ `sorting` / `filter`, so the swap is a no-op for the components.

## DataGrid

`mode="server"` turns the grid into a pure view: it emits the whole query and renders exactly what
you hand back.

```tsx
<DataGrid
  mode="server"
  columns={orderColumns}
  data={data?.items ?? []}
  rowCount={data?.totalCount ?? 0}
  loading={isFetching}
  onQueryChange={setQuery}   // { page, pageSize, sorting, filter, columnFilters, grouping }
/>
```

Filters and search are debounced ~280 ms; sorting, paging and grouping fire immediately. Rows are
virtualised, so page size 100 costs the same as 25. Column behaviour comes from `meta`:

```ts
col.accessor('division', {
  header: 'Division',
  meta: { groupable: true, filterVariant: 'select', filterOptions: [...divisions] },
})
```

In server mode, grouping applies to the returned page. For dataset-wide groups, group on the
server and return pre-aggregated rows.

## Wiring ABP auth

Auth is deliberately **not** implemented — the seams are marked so you can drop it in:

1. `src/main.tsx` — call `initUserManager()` next to `loadRuntimeConfig()`, before first render.
2. `src/lib/api/axios.ts` — attach the access token in the request interceptor (the `__tenant` and
   `Accept-Language` headers are already there); 401 dispatches `auth:unauthenticated`, 403
   redirects to `/403`.
3. `src/routes/router.tsx` — add `beforeLoad: authGuard` on the root route and
   `createPermissionGuard('LoopConsole.Orders')` on protected routes.
4. `src/lib/routing/route-config.ts` — each entry already carries a `permission`; gate the menu
   with `usePermissions()`.
5. `src/env.ts` — `loadRuntimeConfig()` already reads `/getEnvConfig`; it just needs the real
   endpoint.

Packages to add: `@volo/abp-react-oidc-auth`, `@volo/abp-oidc-auth`, `@volo/abp-react-app-config`.

## Localization

`src/lib/i18n.ts` holds ABP keys (`LoopConsole::Orders:Title`, `AbpUi::Save`). `keySeparator` and
`nsSeparator` are off because ABP keys contain `::` and `:`. Replace the bundled `resources` with a
fetch of `/api/abp/application-localization` when the backend is up — the keys stay the same.

## Testing

```
src/components/ui/ui-primitives.test.tsx     button, badge, input, field, card, alert, progress,
                                             icon-button, stat-card, separator, skeleton
src/components/ui/ui-interactive.test.tsx    avatar, checkbox, switch, tabs, select, dropdown,
                                             popover, sidebar-nav
src/components/data/data-grid.test.tsx       sorting, filtering, grouping, selection, paging,
                                             column visibility, server-mode query emission
src/components/data/activity-feed.test.tsx   day grouping, relative time, payloads, tabs, actions
src/components/documents/report-document.test.tsx
src/components/orders/orders.test.tsx        logo, sections, production matrix, T&A panel, RHF+Zod
src/lib/api/orders.test.ts                   API module, Zod schemas, formatters
```

Tests are grouped by area rather than one file per component. `src/test/utils.tsx` wraps renders in
the QueryClient + i18n providers; `src/test/setup.ts` supplies the `ResizeObserver` and pointer-capture
stubs Radix and the virtualiser need under jsdom.

## Known gaps

- Auth, permissions and `dynamic-env.json` are seams, not implementations (as scoped).
- The Inspections and People routes are menu entries only.
- `ProductionMatrix` is a hand-built table: a data grid cannot express banded column groups
  (`stage → % / Qty`) with frozen lead columns.
