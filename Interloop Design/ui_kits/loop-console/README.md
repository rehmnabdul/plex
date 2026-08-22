# Loop Console — UI Kit

An Interloop-branded **operations / admin console**: a plausible internal tool for tracking orders, production capacity, traceability, people and sustainability across Interloop's divisions. It uses the conventional admin shell (sidebar + topbar + dashboard cards + data tables), built entirely from this design system's component primitives. The engineering target is the ABP Modern template's React UI — see `_react/` for the same product on that stack.

> This is an **interpreted** product, not a recreation of a real Interloop app. If you have the real product (code or screenshots), share it and the kit can be made faithful.

## Run it
Open `index.html`. It boots on the **login** screen → **Sign in** → the app shell. Switch screens from the sidebar: **Dashboard**, **Orders**, **People** are fully built; other nav items are decorative.

## Screens
- **LoginScreen** — split brand/form layout with the loop pattern, SSO, remember-me.
- **DashboardScreen** — KPI `StatCard`s, a throughput bar chart, capacity `ProgressBar`s, an active-orders table, a goal ring and an activity feed.
- **OrdersScreen** — full data table: status tabs with counts, search, filter/export toolbar, owner avatars, status badges, row actions and pagination.
- **PeopleScreen** — team roster with presence, notification `Switch`es, an `Alert`, and sustainability progress.
- **Topbar** — title, command search, notifications, settings, user avatar.

## Composition
Screens import primitives from the compiled bundle: `const { Button, Card, StatCard, Badge, Avatar, Tabs, Input, Select, Checkbox, Switch, Alert, ProgressBar, IconButton, SidebarNav } = window.ILPDesignSystem_7d03df`. Layout-only styles live in `lc.css`; mock data in `data.js`. Icons are **Lucide** (CDN). No backend — interactions are local React state.

## Files
`index.html` · `lc.css` · `data.js` · `Topbar.jsx` · `LoginScreen.jsx` · `DashboardScreen.jsx` · `OrdersScreen.jsx` · `PeopleScreen.jsx`
