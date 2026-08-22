# Chart

Analytics charts in the enterprise-BI idiom. See `Widget.prompt.md` for how charts sit in a widget shell.

## The grammar

Every default here is a deliberate position on how business data should be drawn:

- **Data-ink first.** Horizontal gridlines only, hairline weight. No vertical grid, no borders, no shadows on marks. Bars are near-square (`barRadius: 2`) — rounded bars are a consumer-app affectation that costs you the exact bar top.
- **Round scales.** Axes land on 0 / 25 / 50 / 75, never on 37.4. Negative data gets a real zero line.
- **Straight lines by default.** `smooth` invents values between points; opt in only when the underlying measure is genuinely continuous.
- **Light tooltip card**, bordered, with the mark's colour swatch — readable over a dark or light panel.
- **The legend is a control.** Click to filter a series, hover to focus it. `legendPosition="right"` with a `legendTitle` reads as a colour card.

## Pick the mark by the question

| Question | Mark |
|---|---|
| How has this moved? | `line`, `area` |
| How do these compare? | `bar` — `stacked` for composition, `percentStack` for share |
| Which are the biggest? | `hbar` + `sort="desc"` |
| Do two measures move together? | `combo` (dual axis) |
| Are two measures related? | `scatter` |
| Did we hit the target? | `bullet`, or `radial` for one number |
| Where are the hot spots? | `heatmap` |
| How does this differ across many groups? | `trellis` |
| What is the composition? | `donut` (≤6 slices) |

## Reference lines are the point

An operational chart without a target is a picture. `reference` draws dashed lines, and bands when you give it a `to`:

```jsx
<Chart
  type="line" categories={weeks} valueFormat={(v) => v.toFixed(1) + '%'}
  series={[{ name: 'Defect rate', data: defects }]}
  reference={[
    { value: 2.5, label: 'Control limit', color: 'var(--il-red)' },
    { value: 1.2, to: 2.0, label: 'Target band', color: 'var(--il-earth)' },
  ]}
  yTitle="Defect rate" xTitle="Week"
/>
```

## Dual axis

Each series declares its own mark and axis — bars for volume, a line for a rate:

```jsx
<Chart
  type="combo" categories={months}
  series={[
    { name: 'Units shipped', data: units, mark: 'bar' },
    { name: 'Defect rate', data: rate, mark: 'line', axis: 'right', color: 'var(--il-red)' },
  ]}
  yTitle="Units" y2Title="Defect %" rightFormat={(v) => v + '%'} showLegend
/>
```

Two axes invite false correlation. Use it when both measures describe the same process, never to fit two unrelated charts into one panel.

## Rules

- **Four series maximum** on a cartesian chart; six slices on a donut. Past that, use `trellis` or a ranked `hbar`.
- **Always pass `valueFormat`** — it drives ticks, tooltips, labels and the legend together, so they can't disagree.
- **Name the axes** when the unit isn't obvious from the number. "1.9" is not a defect rate until you say so.
- **Sort ranked bars.** `sort="desc"` — an unsorted ranking is a puzzle.
- `showLabels` only when there are few enough marks to read; a labelled 40-bar chart is a table with extra steps.
- Colour encodes a dimension, not decoration. Reuse `CHART_COLORS` in the same order across a dashboard so "blue" means the same thing on every panel; `CHART_RAMP` for continuous values.

## Don't

- Don't use a donut for anything over time.
- Don't stack a percentage.
- Don't truncate a bar chart's baseline — bars are read by area. (Lines may start above zero; say so with `min`.)
- Don't put more than two marks in one panel; a "mixed" widget is a chart plus a list.
