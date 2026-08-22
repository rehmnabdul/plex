# MiniTable

See `Widget.prompt.md` for the widget system. This file covers the API.

Read-only, five to ten rows, no toolbar. **The moment a user needs to sort, filter, page or export, it becomes a `DataGrid`.**

```jsx
<Widget title="Vendor scorecard" flush rule footer={<a href="#all">View all vendors</a>}>
  <MiniTable
    rows={vendors}
    columns={[
      { key: 'name', header: 'Vendor', render: (v, r) => <TableIdentity name={v} meta={r.city} /> },
      { key: 'lots', header: 'Lots', numeric: true },
      { key: 'score', header: 'Score', numeric: true, render: (v) => <TableBar value={v} /> },
      { key: 'status', header: 'Status', render: (v) => <TableStatus tone={TONE[v]}>{v}</TableStatus> },
    ]}
    totals={{ name: 'All vendors', lots: '4,820' }}
  />
</Widget>
```

- Pair with `Widget flush` — the table draws its own edge padding.
- `numeric` right-aligns and applies tabular figures. Use it on every number column.
- Cell helpers: `TableStatus` (pill), `TableIdentity` (avatar + name + meta), `TableBar` (inline progress).
- `totals` renders a footer row keyed by column key; leave a key out to blank that cell.
- `zebra` only when rows are dense and unavatared; hairlines are usually enough.
