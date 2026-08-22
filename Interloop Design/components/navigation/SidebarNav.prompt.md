# SidebarNav

The app's primary navigation. Grouped sections, two levels deep, with a collapsible icon rail.

```jsx
<SidebarNav
  activeKey={route}
  onSelect={go}
  collapsed={collapsed}
  onToggleCollapse={() => setCollapsed((c) => !c)}
  filterable
  footer={<UserBlock />}
  sections={[
    { title: 'Operations', items: [
      { key: 'dashboard', label: 'Dashboard', icon: <Home /> },
      { key: 'orders', label: 'Orders', icon: <Package />, badge: 12,
        children: [
          { key: 'orders.open', label: 'Open' },
          { key: 'orders.hold', label: 'On hold', badge: 3, badgeTone: 'danger' },
        ] },
    ] },
    { title: 'Quality', rule: true, items: [
      { key: 'inspections', label: 'Inspections', icon: <Check /> },
      { key: 'capa', label: 'CAPA', icon: <Alert />, badge: 9 },
    ] },
  ]}
/>
```

## Two levels, and no more

A parent with `children` **discloses** — clicking it opens the group, it never navigates. That's the rule that keeps the menu predictable: anything clickable that changes the page is a leaf.

The group containing `activeKey` opens automatically and stays open. A user's current location is never hidden inside a collapsed parent.

## Collapsed rail

`collapsed` takes the sidebar to a 76px icon rail. Parents open their children as a **flyout** on hover — collapsing navigation must not cost access to it. Badges shrink to a dot, since a number is unreadable at that size and its job there is only "something changed".

Every item needs an `icon` if the app supports collapsing. An icon rail of blanks is not navigation.

## Filtering

`filterable` adds a find field. Worth it past about twelve destinations; below that it is furniture. Matching a parent keeps its children, and matches auto-expand.

## Rules

- **Group by what the user is doing**, not by which service owns the screen. "Quality" and "Planning", not "QMS" and "MES".
- **3–7 items per section.** More than that and the section is a page with its own navigation.
- `badge` for counts that change behaviour — items awaiting you. Not for decoration, and never a total that never moves.
- **Mark the trail.** A parent of the active route is highlighted but not selected; only one item in the sidebar is ever `aria-current="page"`.
- `tone="light"` for a white sidebar when the app already has a dark topbar. One dark surface per shell.
- Pass `header` to replace the Logo lockup, or `header={null}` when the shell puts the brand in the topbar.

## Don't

- Don't put actions in the sidebar. It is a map, not a toolbar — "New order" belongs on the page it creates.
- Don't reorder items by recency or frequency. Muscle memory beats cleverness.
- Don't nest a third level. If you need one, the second level is a page with its own `Tabs`.
