# StatTile · StatGrid · ProgressRing

See `Widget.prompt.md` for the widget system. This file covers the API.

```jsx
<StatGrid>
  <StatTile label="Open orders" value="1,284" delta="+4.2%" direction="up" hint="vs. last month" stripe="brand" />
  <StatTile label="Quality index" value="97.4" delta="+0.6" direction="up" spark={weekly} />
  <StatTile label="Defect rate" value="1.94" unit="%" delta="+0.21" direction="up" invert hint="limit 2.5%" />
  <StatTile label="On-time delivery" value="94.1" unit="%" progress={94.1} />
</StatGrid>
```

- **`invert` is not optional** on metrics where up is bad. A red-is-good tile is a reporting bug.
- A tile takes a `spark` **or** a `progress`, never both.
- `unit` keeps "1.94" and "%" at different sizes so the number stays the loudest thing.
- `stripe` is the only decoration a tile gets — use it on the one or two tiles that carry a status.
- `tone="brand" | "accent"` inverts the tile. One per screen.

`ProgressRing` is for a value against a target:

```jsx
<ProgressRing value={78} label="Capacity" caption="Faisalabad II · week 32" />
<ProgressRing value={4.2} max={5} display="4.2" label="Vendor score" color="var(--il-earth)" />
```

No target means no ring — show the number instead.
