# Widgets

Five parts that compose every dashboard panel in the system: `Widget` (the shell), `Chart`, `DataList`, `StatTile` / `StatGrid` / `ProgressRing`, and `MiniTable`.

The rule that holds them together: **`Widget` owns the frame, the content component owns the inside.** Never let a chart or list draw its own card — panels would drift apart within a week.

```jsx
<Widget title="Throughput" subtitle="Units shipped per week" actions={<RangeSwitch />}>
  <Chart type="area" series={[{ name: 'Units', data }]} categories={weeks} smooth />
</Widget>
```

## Widget

Header (eyebrow / title / subtitle / actions / ⋮), body, footer. `flush` removes body padding for tables and edge-to-edge lists; `scroll` + `height` fixes the panel and scrolls the body; `loading` and `empty` cover the two states people forget.

Tones: `default` white, `brand` Gray Blue, `accent` Just Blue gradient. **One toned widget per dashboard, maximum** — it's for the single number that matters most.

## Chart

Eight types, no charting library, resizes with its container:

| Type | Use for |
|---|---|
| `line`, `area` | Trends over time. `smooth` for a softer read; area only when the volume matters. |
| `bar` | Comparison across categories. Add `stacked` for composition. |
| `hbar` | Ranked comparison with long labels (vendors, defect types). |
| `donut` | Parts of a whole, 2–6 slices, with a `centerValue` readout. |
| `pie` | Same, when the centre would be wasted. Prefer donut. |
| `radial` | One value against a target. |
| `spark` | Micro-trend inside a tile or table cell. |

Rules: never more than **four series** on a cartesian chart, or six slices on a donut. Pass `valueFormat` so the axis, tooltip and labels agree. Don't set `showAxis={false}` on a chart people will read numbers off. Series colours come from `CHART_COLORS` — override only for semantics (pass/fail), never for decoration.

## DataList

One row model, six leading treatments: `plain`, `ranked` (top-three chips), `people` (avatar or initials), `icon` (tinted tile), `swatch` (chart-legend colour), `check` (checklist).

Rows carry `title` / `subtitle` on the left, `value` / `delta` / `meta` on the right, and an optional `progress` bar. Use `swatch` when the list is the legend for a chart in the same widget — the colours must match.

Keep lists to 5–8 rows in a dashboard panel and put the rest behind "View all" in the footer.

## StatTile · StatGrid · ProgressRing

`StatGrid` is the hairline-divided KPI strip; `StatTile` is one cell. A tile takes a `spark` series or a `progress` bar, not both. Set `invert` on metrics where up is bad — defect rate, downtime, returns — so the delta colours correctly.

`ProgressRing` is for completion against a target. If there's no target, it's a number, not a ring.

## MiniTable

Read-only, five to ten rows, no toolbar. Cell helpers: `TableStatus` (pill), `TableIdentity` (avatar + name + meta), `TableBar` (inline progress).

**The moment a user needs to sort, filter, page or export, it stops being a MiniTable and becomes a `DataGrid`.** Don't grow one into the other.

## Don't

- Don't stack more than two chart types in one panel; a "mixed" widget is a chart plus a list, not three charts.
- Don't use a donut for anything that changes over time.
- Don't put a `DataGrid` inside a `Widget` — the grid brings its own shell.
- Don't repeat the same figure as a tile and a chart label on the same screen.
