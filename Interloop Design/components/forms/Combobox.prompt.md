# Advanced form controls

`Combobox` · `MultiSelect` · `TagInput` · `DateField` · `DateRangeField` · `LookupField` · `RangeSlider` · `SplitButton`

The controls an enterprise form needs beyond a text box and a select. All share one field grammar: label with a required asterisk, 40px control, hint underneath that the error message replaces.

## Choosing a picker

| Choices | Control |
|---|---|
| 2–7, all visible | `Select` |
| 8–200, one answer | **`Combobox`** — type to filter |
| 8–200, several answers | **`MultiSelect`** — chips in the field |
| Thousands, one record | **`LookupField`** — a grid you can search |
| Open set, user invents them | **`TagInput`** |

That table is the whole decision. A `Select` with 300 options and a `Combobox` over five are both failures.

```jsx
<Combobox label="Vendor" options={vendors} value={v} onChange={setV} groupBy="city" />
<MultiSelect label="Divisions" options={divisions} value={sel} onChange={setSel} maxChips={2} />
<TagInput label="Defect tags" value={tags} onChange={setTags} suggestions={known} max={8}
  validate={(t) => t.length <= 24 || 'Keep tags under 24 characters'} />
```

- `Combobox` highlights the matched run, so a filtered list is explainable rather than mysterious. Pass `onSearch` to filter server-side.
- `MultiSelect` collapses past `maxChips` to "+n more" — a field that grows to four lines pushes the rest of the form around.
- `TagInput` splits a pasted delimited list. People paste from Excel; accept it.

## Dates

```jsx
<DateField label="Ship date" value={d} onChange={setD} min="2026-08-01" />
<DateField label="Checked at" mode="datetime" value={t} onChange={setT} />
<DateRangeField label="Reporting period" value={range} onChange={setRange} />
```

- **Weekends are dimmed and today is ringed** — a plant plan is read against the working week.
- `DateRangeField` shows two months and previews the range as you hover the end date. Presets cover the four questions people actually ask; drop them with `presets={[]}` only when they genuinely don't apply.
- Never build a range from two independent `DateField`s. Users pick an end before a start, and nothing stops them.

## LookupField

For picking one record out of thousands — an order, a vendor, a style. The field shows the chosen record with a second line of context; the button opens a searchable grid.

```jsx
<LookupField
  label="Order" value={order} onChange={setOrder}
  displayKey="id" metaKey="client" title="Select an order"
  columns={[{ key: 'id', header: 'Order' }, { key: 'client', header: 'Client' },
            { key: 'units', header: 'Units', numeric: true }]}
  rows={orders}
/>
```

Click selects, double-click or Enter confirms, Select commits — nothing is written to the form until the user confirms, so cancelling really cancels.

## RangeSlider & SplitButton

`RangeSlider` for a bounded numeric filter (lot size, defect %, score). Two thumbs on one track that cannot cross. Show the readout — a slider without numbers is a guess.

`SplitButton` for one obvious action with real alternates: **Save** / *Save and new* / *Save and close*. The main button must be the one people want 80% of the time; if you can't name that one, use separate buttons.

## Rules

- **The error replaces the hint** — never both, and never a hint that contradicts the error.
- **Every control takes `label`.** A placeholder is not a label; it disappears exactly when the user needs it.
- **Popovers close on outside click and Escape**, and never trap focus. Only `LookupField` is modal, because choosing a record is a task, not a tweak.
- **Disabled must be explainable.** If a field is disabled, the hint says why.

## Don't

- Don't use `LookupField` for fewer than ~50 records; the modal costs more than it saves.
- Don't put a `DateRangeField` and its presets in a form — presets are a reporting affordance, not a data-entry one.
- Don't validate a `TagInput` by refusing input. Accept the tag, mark it red, explain in the hint.
