import React from 'react';

/** Aggregate shown on a group header row. */
export type DataGridAggregate = 'sum' | 'avg' | 'min' | 'max' | 'count' | ((rows: any[]) => number);

export interface DataGridColumn {
  /** Field path on the row. Dotted paths supported ("client.name"). */
  key: string;
  /** Header label. Falls back to `key`. */
  header?: string;
  /** Start width in px. @default 160 */
  width?: number;
  /** Floor for drag-resize. @default 72 */
  minWidth?: number;
  /** Cell + header alignment. Numbers right-align automatically when `type` is "number". */
  align?: 'left' | 'center' | 'right';
  /** "number" enables tabular figures, right alignment and numeric filter operators. */
  type?: 'text' | 'number' | 'date';
  /** Set false to disable click-to-sort on the header. @default true */
  sortable?: boolean;
  /** Set false to disable drag-resize. @default true */
  resizable?: boolean;
  /** Filter control in the filter row. false removes it. @default "text" */
  filter?: 'text' | 'number' | 'select' | 'boolean' | false;
  /** Options for a select filter. Derived from the data when omitted. */
  filterOptions?: Array<string | { value: string; label: string }>;
  /** Offer this column in the Group menu. @default false */
  groupable?: boolean;
  /** Start hidden (user can re-enable it in the Columns panel). @default false */
  hidden?: boolean;
  /** Freeze to the left edge on horizontal scroll. */
  pinned?: 'left';
  /** Exclude from the toolbar quick search. @default true */
  searchable?: boolean;
  /** Aggregate rolled up onto group header rows. */
  aggregate?: DataGridAggregate;
  /** Custom cell renderer. Return a node — badges, avatars, links. */
  render?: (value: any, row: any) => React.ReactNode;
  /** Format the raw value to a string (used by cells, aggregates and CSV export). */
  format?: (value: any, row?: any) => string;
  /** Value used for sorting instead of the raw cell value. */
  sortValue?: (value: any, row: any) => any;
  /** Value used for filtering instead of the raw cell value. */
  filterValue?: (value: any, row: any) => any;
  /** Value used as the group bucket key instead of the raw cell value. */
  groupValue?: (value: any, row: any) => any;
  /** Render the cell in secondary text colour. */
  muted?: boolean;
}

/** Everything the grid knows when it asks the server for a page. */
export interface DataGridQuery {
  page: number;
  pageSize: number;
  sort: { key: string; dir: 'asc' | 'desc' } | null;
  filters: Record<string, string>;
  search: string;
  groupBy: string[];
}

/**
 * Enterprise data grid — row grouping with aggregates, per-column filtering,
 * column show/hide, drag-resize, left-pinning, row virtualisation and
 * server-side paging.
 *
 * Client mode does the whole filter → sort → page pipeline in memory.
 * Server mode (`mode="server"`) renders exactly the `rows` it is handed and
 * calls `onRequest` whenever the query changes (filters and search debounced
 * ~280ms); supply `totalRows` so the pager can size itself.
 */
export interface DataGridProps extends Omit<React.HTMLAttributes<HTMLDivElement>, 'title'> {
  /** Column model. */
  columns: DataGridColumn[];
  /** Rows for the current page (server mode) or the whole dataset (client mode). */
  rows: any[];
  /** Row identity — field name or getter. @default "id" */
  rowKey?: string | ((row: any) => string);
  /** Where filtering, sorting and paging happen. @default "client" */
  mode?: 'client' | 'server';
  /** Total row count across all pages. Required in server mode. */
  totalRows?: number;
  /** Show the loading bar and dim the body. @default false */
  loading?: boolean;
  /** Server mode: called with the full query whenever it changes. */
  onRequest?: (query: DataGridQuery) => void;
  /** Fired when a body row is clicked. */
  onRowClick?: (row: any, event: React.MouseEvent) => void;
  /** Fired with the selected row keys. */
  onSelectionChange?: (keys: string[]) => void;
  /** Toolbar heading. */
  title?: string;
  /** Toolbar sub-heading. */
  subtitle?: string;
  /** Extra toolbar nodes, rendered after the built-in tools. */
  actions?: React.ReactNode;
  /** Checkbox column + select-all. @default false */
  selectable?: boolean;
  /** @default true */
  showToolbar?: boolean;
  /** @default true */
  showSearch?: boolean;
  /** @default true */
  showColumnPicker?: boolean;
  /** @default true */
  showGroupControl?: boolean;
  /** @default true */
  showDensityToggle?: boolean;
  /** CSV export of the current page. @default false */
  showExport?: boolean;
  /** @default true */
  showFooter?: boolean;
  /** Open the per-column filter row on mount. @default false */
  showFilterRow?: boolean;
  /** Columns grouped on mount, outermost first. */
  defaultGroupBy?: string[];
  /** Sort applied on mount. */
  defaultSort?: { key: string; dir: 'asc' | 'desc' } | null;
  /** Row height preset. @default "comfortable" */
  density?: 'comfortable' | 'compact';
  /** Overall grid height (the body scrolls inside it). @default 520 */
  height?: number | string;
  /** @default 25 */
  pageSize?: number;
  /** @default [10, 25, 50, 100] */
  pageSizeOptions?: number[];
  /** Windowed row rendering. @default true */
  virtualize?: boolean;
  /** Row count above which virtualisation kicks in. @default 60 */
  virtualizeThreshold?: number;
  /** @default "No rows to show" */
  emptyTitle?: string;
  /** @default "Try clearing a filter or widening your search." */
  emptyMessage?: string;
}

export function DataGrid(props: DataGridProps): JSX.Element;
