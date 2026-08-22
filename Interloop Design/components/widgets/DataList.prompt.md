# DataList

See `Widget.prompt.md` for the widget system and when a list is the right panel. This file covers the API.

```jsx
<DataList
  variant="ranked"
  items={[
    { title: 'Nordstrom', subtitle: '18 open orders', value: '$482,900', delta: '+4.2%' },
    { title: 'Uniqlo', subtitle: '12 open orders', value: '$318,400', delta: '-1.8%' },
  ]}
/>
```

Variants: `plain`, `ranked`, `people`, `icon`, `swatch`, `check`.

```jsx
// legend for a chart in the same widget — colours must match the series
<DataList variant="swatch" compact items={divisions.map((d, i) => ({
  title: d.name, value: d.pct + '%', color: CHART_COLORS[i],
}))} />

// checklist
<DataList variant="check" items={tasks} onToggle={(item) => toggle(item.id)} />
```

- `delta` infers its direction from the sign; pass `direction` to override.
- `progress` (0–100) renders a bar under the subtitle.
- Pair `inset` with `Widget flush` so rows run edge to edge and hover highlights the full width.
- `onItemClick` turns rows into buttons — keyboard and focus states come with it.
