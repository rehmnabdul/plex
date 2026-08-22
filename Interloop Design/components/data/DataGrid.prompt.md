# DataGrid

The workhorse table for Loop Console and any Interloop back-office screen. One component covers the whole "list of records" job: grouping, filtering, column management, selection and paging.

## When to use

- Any list of **records** the user needs to slice: orders, shipments, lots, people, audit rows.
- Reach for `Card` + a plain `<table>` instead when there are fewer than ~10 static rows and no interaction.

## Anatomy

Toolbar (title, group chips, selection pill, search, Filters, Group, Columns, density, export) → sticky header row → optional filter row → virtualised body → footer (page size, range, pager).

## Data modes

**Client** — hand it every row; the grid filters, sorts, pages and groups in memory. Good to ~20k rows with `virtualize` on.

```jsx
<DataGrid columns={cols} rows={orders} rowKey="id" selectable showExport />
```

**Server** — the grid becomes a pure view. It emits the whole query on every change (filters and search debounced ~280ms) and renders exactly what you hand back.

```jsx
const [state, setState] = React.useState({ rows: [], total: 0, loading: true });

<DataGrid
  mode="server"
  columns={cols}
  rows={state.rows}
  totalRows={state.total}
  loading={state.loading}
  onRequest={async (q) => {          // { page, pageSize, sort, filters, search, groupBy }
    setState((s) => ({ ...s, loading: true }));
    const res = await api.orders(q);
    setState({ rows: res.items, total: res.totalCount, loading: false });
  }}
/>
```

`onRequest` fires once on mount — no separate initial fetch. Grouping in server mode groups the rows of the page you returned; for a grouped total across the dataset, group on the server and return pre-aggregated rows.

## Columns

```js
const cols = [
  { key: 'order', header: 'Order', width: 130, pinned: 'left' },
  { key: 'client', header: 'Client', width: 200, groupable: true },
  { key: 'division', header: 'Division', width: 130, filter: 'select', groupable: true },
  { key: 'units', header: 'Units', type: 'number', width: 110, aggregate: 'sum' },
  { key: 'status', header: 'Status', width: 130, filter: 'select',
    render: (v) => <Badge tone={v === 'Shipped' ? 'success' : 'info'}>{v}</Badge> },
];
```

- `type: 'number'` right-aligns, uses tabular figures, and enables operator filters: `>100`, `<=50`, `10-40`, `=7`.
- `aggregate` values roll up onto group header rows.
- `render` for badges/avatars/links; `format` for a plain string (also used by CSV export).

## Rules

- Give the grid a **fixed `height`** — it is a flex column and the body scrolls inside it. Don't let it grow to content.
- Pin identity columns (`order`, `sku`, `name`) left so they survive horizontal scroll.
- Keep 6–9 columns visible by default and let users add the rest from the Columns panel — don't ship 20 visible columns.
- `rowKey` must be stable; selection and virtualisation both key off it.
- Set `groupable: true` only on low-cardinality columns (division, status, vendor). Grouping on a unique key produces one group per row.
- `compact` density is for dense operational screens (shop floor, audit); default `comfortable` everywhere else.

## Don't

- Don't nest a DataGrid inside a DataGrid.
- Don't disable virtualisation on lists over a few hundred rows.
- Don't put destructive actions in a cell without a confirm step.
