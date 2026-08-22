# DateField · DateRangeField

See `Combobox.prompt.md` for the shared field grammar and the picker decision table. This file covers the API.

```jsx
<DateField label="Ship date" value={d} onChange={setD} min="2026-08-01" />
<DateField label="Checked at" mode="datetime" value={t} onChange={setT} />
<DateField label="Shift start" mode="time" value={t} onChange={setT} />
<DateRangeField label="Reporting period" value={range} onChange={setRange} align="right" />
```

- `mode="date"` returns an ISO date string; `datetime` returns an ISO datetime; `time` returns `HH:mm` and skips the calendar.
- Weekends are dimmed and today is ringed — a plant plan is read against the working week.
- `min` / `max` disable out-of-range days rather than letting the user pick and then fail validation.
- `DateRangeField` shows two months, previews the range as you hover the end date, and swaps the dates if the user picks backwards. **Never build a range from two independent `DateField`s.**
- Presets cover the four questions people actually ask. Drop them with `presets={[]}` only when they genuinely don't apply.
