# SheetGrid

The spreadsheet. Where `DataGrid` is for **reading** a dataset — slicing, grouping, paging — `SheetGrid` is for **entering** one: bulk edits, imports, plan tables, measurement sheets. People arrive at it expecting Excel, so it behaves like Excel.

## When to use which

| Need | Component |
|---|---|
| Browse, filter, group, page 4,000 orders | `DataGrid` |
| Type 200 measurements and paste from Excel | `SheetGrid` |
| Five read-only rows in a dashboard panel | `MiniTable` |

## Interaction contract

Everything below is expected behaviour, not extras:

- **Move** — arrows, Tab / Shift+Tab. **Extend** — Shift+arrows, Shift+click.
- **Edit** — Enter, F2, double-click, or just start typing (the keystroke seeds the editor).
- **Commit** — Enter (moves down), Tab (moves right), blur. **Cancel** — Escape.
- **Clear** — Delete or Backspace clears the whole selected range.
- **Clipboard** — Ctrl+C copies the range as TSV; Ctrl+V pastes a TSV block from Excel, spilling right and down from the anchor.
- **Fill** — drag the handle at the range's bottom-right corner to copy downward.
- **Undo / redo** — Ctrl+Z, Ctrl+Shift+Z, 50 steps.

## Typed cells

The `type` decides the display format, the alignment and the editor:

```js
const columns = [
  { key: 'item', header: 'Item ID', width: 130, readOnly: true },
  { key: 'style', header: 'Style', required: true },
  { key: 'qty', header: 'Order qty', type: 'number', min: 0 },
  { key: 'rate', header: 'Unit rate', type: 'currency' },
  { key: 'defects', header: 'Defect %', type: 'percent', max: 100,
    validate: (v) => (v > 2.5 ? 'Above the 2.5% control limit' : true) },
  { key: 'ship', header: 'Ship date', type: 'date' },
  { key: 'checked', header: 'Checked at', type: 'datetime' },
  { key: 'status', header: 'Status', type: 'select',
    options: ['Planned', 'In production', 'QC hold', 'Shipped'],
    tones: { Shipped: 'success', 'QC hold': 'warning' } },
  { key: 'approved', header: 'Approved', type: 'checkbox' },
];
```

`select` renders a pill in display mode and a dropdown in edit mode. `checkbox` toggles on click or Space — it never opens an editor. `date` / `datetime` / `time` use the native pickers, so the OS locale and keyboard both work.

## Validation

`required`, `min`, `max` and a `validate` callback all flag the cell — red underline, corner triangle, tooltip — and the status bar counts them. Validation never blocks typing; people fix a sheet by seeing what's wrong, not by being stopped mid-entry.

## Frozen columns

`freeze={2}` pins the leading columns (plus the row gutter) so identity stays on screen while you scroll right. The toolbar button toggles it. Freeze the columns that say *which record this is* — item ID, style, name — never the ones being edited.

## Rules

- **Give it a fixed `height`.** It is a viewport, not a document.
- **`onChange` hands you the whole next dataset.** Persist on a debounce or on blur — not per keystroke.
- **Mark derived columns `readOnly`.** A cell someone can type into but that recalculates is a bug report waiting to happen.
- Keep sheets under ~2,000 rows. Past that, page the data or move to a real import flow.
- Use `totals` for the sums people would otherwise compute by hand.

## Don't

- Don't add sorting or filtering. Reordering rows under someone mid-entry loses their place — that's what `DataGrid` is for.
- Don't put a `SheetGrid` in a dialog under 900px wide; the toolbar and status bar need room.
- Don't hide the status bar on a sheet with validation — it's the only place the error count lives.
