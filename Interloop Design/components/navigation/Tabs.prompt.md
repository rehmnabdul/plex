# Tabs

Tab strip implementing the **WAI-ARIA tabs pattern** — the keyboard behaviour is the component, not a nice-to-have. Arrow keys move between tabs (roving tabindex, so Tab enters and leaves the strip in one press), Home / End jump to the ends, and disabled tabs are skipped.

```jsx
const [tab, setTab] = React.useState('info');

<Tabs
  tabs={[
    { value: 'info', label: 'Order information' },
    { value: 'people', label: 'Stakeholders', count: 6 },
    { value: 'prod', label: 'Production status', dot: 'warning' },
    { value: 'audit', label: 'Audit trail', disabled: true },
  ]}
  value={tab} onChange={setTab} idPrefix="order"
/>
<TabPanel value="info" active={tab} idPrefix="order">…</TabPanel>
```

## Activation

`activation="automatic"` (default) selects as the user arrows through — right when panels are already loaded. Switch to `"manual"` when changing tabs costs a fetch: focus moves, Enter commits, and nobody triggers four requests crossing the strip.

## Variants

- **`line`** — the default. A measured indicator slides between tabs and re-measures on resize and font load, so it can't drift.
- **`pill`** — segmented control on a tinted track. For switching a view of the same data (Item level / PO level), not for navigating sections.
- **`enclosed`** — folder tabs. Use when the panel below has its own card edge to meet.
- **`orientation="vertical"`** — settings-style navigation down the left of a panel.

## Overflow

Tabs never wrap. Past the container width the strip scrolls, with edge fades and step buttons, and the active tab is scrolled into view when it changes. If you have more than about eight tabs, that's a navigation problem, not a tab problem.

## Rules

- **Label tabs as nouns** — "Stakeholders", not "View stakeholders".
- **Pass `idPrefix`** and use `TabPanel`, so `aria-controls` / `aria-labelledby` wire up. A tab strip without panels wired is a row of buttons pretending.
- `count` for a quantity the user is deciding by; `dot` for "something in here needs you". Never both on one tab.
- Don't disable a tab without an adjacent explanation — a dead tab with no reason reads as a bug.
- Don't nest tab strips. The second level is a `SidebarNav`, a segmented control, or a different page.
