import * as React from 'react';
import {
  flexRender, getCoreRowModel, getExpandedRowModel, getFilteredRowModel,
  getGroupedRowModel, getPaginationRowModel, getSortedRowModel, useReactTable,
  type ColumnDef, type ColumnFiltersState, type ColumnPinningState,
  type ExpandedState, type GroupingState, type RowData, type RowSelectionState,
  type SortingState, type VisibilityState,
} from '@tanstack/react-table';
import { useVirtualizer } from '@tanstack/react-virtual';
import { ArrowDown, ArrowUp, ChevronRight, Inbox, MoreVertical } from 'lucide-react';
import { useTranslation } from 'react-i18next';
import { cn } from '@/lib/utils';
import { Checkbox } from '@/components/ui/checkbox';
import {
  DropdownMenu, DropdownMenuContent, DropdownMenuItem,
  DropdownMenuSeparator, DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu';
import { DataGridToolbar, columnLabel } from './data-grid-toolbar';
import { DataGridPagination } from './data-grid-pagination';

declare module '@tanstack/react-table' {
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  interface ColumnMeta<TData extends RowData, TValue> {
    align?: 'left' | 'center' | 'right';
    /** Right-aligns and applies tabular figures. */
    numeric?: boolean;
    /** Offer the column in the Group menu. */
    groupable?: boolean;
    /** Control rendered in the filter row. @default "text" */
    filterVariant?: 'text' | 'number' | 'select' | 'none';
    filterOptions?: string[];
  }
}

/** Everything the grid knows when it asks the server for a page. */
export interface DataGridQuery {
  page: number;
  pageSize: number;
  sorting: string | null;
  filter: string;
  columnFilters: Record<string, string>;
  grouping: string[];
}

export interface DataGridProps<TData> {
  columns: ColumnDef<TData, any>[];
  data: TData[];
  getRowId?: (row: TData) => string;
  /** Where filtering, sorting and paging happen. @default "client" */
  mode?: 'client' | 'server';
  /** Total rows across all pages. Required in server mode. */
  rowCount?: number;
  loading?: boolean;
  /** Server mode: fires (debounced for text input) whenever the query changes. */
  onQueryChange?: (query: DataGridQuery) => void;
  onRowClick?: (row: TData) => void;
  onSelectionChange?: (ids: string[]) => void;
  title?: string;
  subtitle?: string;
  actions?: React.ReactNode;
  selectable?: boolean;
  initialGrouping?: string[];
  initialSorting?: SortingState;
  initialPinning?: ColumnPinningState;
  initialVisibility?: VisibilityState;
  defaultDensity?: 'comfortable' | 'compact';
  showFilterRow?: boolean;
  showToolbar?: boolean;
  showSearch?: boolean;
  showGroup?: boolean;
  showColumns?: boolean;
  showDensity?: boolean;
  showExport?: boolean;
  showFooter?: boolean;
  pageSize?: number;
  pageSizeOptions?: number[];
  height?: number | string;
  emptyTitle?: string;
  emptyMessage?: string;
  className?: string;
}

const cellAlign = (meta?: { align?: string; numeric?: boolean }) =>
  meta?.align === 'center' ? 'justify-center text-center'
    : meta?.align === 'right' || meta?.numeric ? 'justify-end text-right tabular-nums'
      : '';

export function DataGrid<TData extends object>({
  columns, data, getRowId, mode = 'client', rowCount, loading = false,
  onQueryChange, onRowClick, onSelectionChange,
  title, subtitle, actions, selectable = false,
  initialGrouping = [], initialSorting = [], initialPinning = { left: [] }, initialVisibility = {},
  defaultDensity = 'comfortable', showFilterRow = false, showToolbar = true,
  showSearch = true, showGroup = true, showColumns = true, showDensity = true,
  showExport = false, showFooter = true,
  pageSize = 25, pageSizeOptions = [10, 25, 50, 100], height = 520,
  emptyTitle, emptyMessage, className,
}: DataGridProps<TData>) {
  const { t } = useTranslation();
  const server = mode === 'server';

  const [sorting, setSorting] = React.useState<SortingState>(initialSorting);
  const [columnFilters, setColumnFilters] = React.useState<ColumnFiltersState>([]);
  const [globalFilter, setGlobalFilter] = React.useState('');
  const [grouping, setGrouping] = React.useState<GroupingState>(initialGrouping);
  const [expanded, setExpanded] = React.useState<ExpandedState>(true);
  const [columnVisibility, setColumnVisibility] = React.useState<VisibilityState>(initialVisibility);
  const [columnPinning, setColumnPinning] = React.useState<ColumnPinningState>(initialPinning);
  const [rowSelection, setRowSelection] = React.useState<RowSelectionState>({});
  const [pagination, setPagination] = React.useState({ pageIndex: 0, pageSize });
  const [density, setDensity] = React.useState(defaultDensity);
  const [filterRow, setFilterRow] = React.useState(showFilterRow);

  const rowH = density === 'compact' ? 34 : 44;
  const headH = (density === 'compact' ? 38 : 44) + (filterRow ? 38 : 0);

  const allColumns = React.useMemo<ColumnDef<TData, any>[]>(() => {
    if (!selectable) return columns;
    const selectCol: ColumnDef<TData, any> = {
      id: '__select',
      size: 44,
      enableSorting: false, enableHiding: false, enableResizing: false, enableGrouping: false,
      meta: { align: 'center', filterVariant: 'none' },
      header: ({ table }) => (
        <Checkbox
          aria-label="Select all rows on page"
          checked={table.getIsAllPageRowsSelected() || (table.getIsSomePageRowsSelected() && 'indeterminate')}
          onCheckedChange={(v) => table.toggleAllPageRowsSelected(!!v)}
        />
      ),
      cell: ({ row }) => (
        <Checkbox
          aria-label="Select row"
          checked={row.getIsSelected()}
          onCheckedChange={(v) => row.toggleSelected(!!v)}
          onClick={(e) => e.stopPropagation()}
        />
      ),
    };
    return [selectCol, ...columns];
  }, [columns, selectable]);

  const table = useReactTable({
    data,
    columns: allColumns,
    state: { sorting, columnFilters, globalFilter, grouping, expanded, columnVisibility, columnPinning, rowSelection, pagination },
    getRowId: getRowId as ((row: TData, index: number) => string) | undefined,
    columnResizeMode: 'onChange',
    enableColumnResizing: true,
    enableRowSelection: selectable,
    manualPagination: server,
    manualSorting: server,
    manualFiltering: server,
    rowCount: server ? rowCount : undefined,
    onSortingChange: setSorting,
    onColumnFiltersChange: setColumnFilters,
    onGlobalFilterChange: setGlobalFilter,
    onGroupingChange: setGrouping,
    onExpandedChange: setExpanded,
    onColumnVisibilityChange: setColumnVisibility,
    onColumnPinningChange: setColumnPinning,
    onRowSelectionChange: setRowSelection,
    onPaginationChange: setPagination,
    getCoreRowModel: getCoreRowModel(),
    getFilteredRowModel: server ? undefined : getFilteredRowModel(),
    getSortedRowModel: server ? undefined : getSortedRowModel(),
    getPaginationRowModel: server ? undefined : getPaginationRowModel(),
    getGroupedRowModel: getGroupedRowModel(),
    getExpandedRowModel: getExpandedRowModel(),
  });

  /* ---- selection callback ---- */
  React.useEffect(() => {
    onSelectionChange?.(Object.keys(rowSelection).filter((k) => rowSelection[k]));
  }, [rowSelection, onSelectionChange]);

  /* ---- server query signal (text input debounced) ---- */
  const filtersKey = JSON.stringify({ columnFilters, globalFilter });
  const [debouncedFilters, setDebouncedFilters] = React.useState(filtersKey);
  React.useEffect(() => {
    const id = setTimeout(() => setDebouncedFilters(filtersKey), 280);
    return () => clearTimeout(id);
  }, [filtersKey]);

  const queryRef = React.useRef(onQueryChange);
  queryRef.current = onQueryChange;
  React.useEffect(() => {
    if (!server || !queryRef.current) return;
    const parsed = JSON.parse(debouncedFilters) as { columnFilters: ColumnFiltersState; globalFilter: string };
    queryRef.current({
      page: pagination.pageIndex + 1,
      pageSize: pagination.pageSize,
      sorting: sorting[0] ? `${sorting[0].id} ${sorting[0].desc ? 'desc' : 'asc'}` : null,
      filter: parsed.globalFilter ?? '',
      columnFilters: Object.fromEntries(parsed.columnFilters.map((f) => [f.id, String(f.value ?? '')])),
      grouping,
    });
  }, [server, pagination.pageIndex, pagination.pageSize, sorting, grouping, debouncedFilters]);

  React.useEffect(() => { table.setPageIndex(0); }, [debouncedFilters, table]);

  /* ---- layout ---- */
  const leafColumns = table.getVisibleLeafColumns();
  const template = `${leafColumns.map((c) => `${c.getSize()}px`).join(' ')} minmax(24px,1fr)`;
  const minWidth = leafColumns.reduce((s, c) => s + c.getSize(), 0) + 24;
  const pinnedLeft = leafColumns.filter((c) => c.getIsPinned() === 'left');
  const lastPinned = pinnedLeft.at(-1)?.id;

  const scrollRef = React.useRef<HTMLDivElement>(null);
  const rows = table.getRowModel().rows;
  const virtualizer = useVirtualizer({
    count: rows.length,
    getScrollElement: () => scrollRef.current,
    estimateSize: () => rowH,
    overscan: 10,
    scrollMargin: headH,
  });

  React.useEffect(() => {
    if (scrollRef.current) scrollRef.current.scrollTop = 0;
  }, [pagination.pageIndex, pagination.pageSize, sorting, debouncedFilters]);

  const total = server ? (rowCount ?? data.length) : table.getFilteredRowModel().rows.length;
  const activeFilters = columnFilters.filter((f) => f.value !== '' && f.value != null).length + (globalFilter ? 1 : 0);

  const exportCsv = () => {
    const cols = leafColumns.filter((c) => c.id !== '__select');
    const head = cols.map((c) => `"${columnLabel(c.id, c.columnDef.header)}"`).join(',');
    const body = rows.filter((r) => !r.getIsGrouped()).map((r) =>
      cols.map((c) => `"${String(r.getValue(c.id) ?? '').replace(/"/g, '""')}"`).join(',')).join('\n');
    const url = URL.createObjectURL(new Blob([`${head}\n${body}`], { type: 'text/csv' }));
    const a = document.createElement('a');
    a.href = url;
    a.download = `${(title ?? 'data-grid').toLowerCase().replace(/\s+/g, '-')}.csv`;
    a.click();
    URL.revokeObjectURL(url);
  };

  const pinStyle = (columnId: string, isHeader = false): React.CSSProperties | undefined => {
    const col = table.getColumn(columnId);
    if (col?.getIsPinned() !== 'left') return undefined;
    return { position: 'sticky', left: col.getStart('left'), zIndex: isHeader ? 4 : 2 };
  };

  return (
    <div
      role="grid"
      aria-rowcount={total}
      className={cn('relative flex min-h-0 flex-col overflow-hidden rounded-lg border border-border bg-card shadow-[var(--shadow-sm)]', className)}
      style={{ height }}
    >
      {loading && (
        <div className="absolute inset-x-0 top-0 z-10 h-0.5 overflow-hidden bg-info-soft">
          <div className="h-full w-[36%] bg-primary animate-[var(--animate-shimmer)]" />
        </div>
      )}

      {showToolbar && (
        <DataGridToolbar
          table={table} title={title} subtitle={subtitle}
          search={globalFilter} onSearchChange={setGlobalFilter}
          filterRow={filterRow} onFilterRowChange={setFilterRow}
          activeFilters={activeFilters}
          onClearFilters={() => { setColumnFilters([]); setGlobalFilter(''); }}
          density={density} onDensityChange={setDensity}
          selectedCount={Object.keys(rowSelection).length}
          onClearSelection={() => setRowSelection({})}
          showSearch={showSearch} showGroup={showGroup} showColumns={showColumns} showDensity={showDensity}
          onExport={showExport ? exportCsv : undefined}
          actions={actions}
        />
      )}

      <div ref={scrollRef} className="relative min-h-0 flex-1 overflow-auto overscroll-contain">
        <div className="relative" style={{ minWidth }}>
          {/* header */}
          <div className="sticky top-0 z-30 bg-card">
            {table.getHeaderGroups().map((hg) => (
              <div
                key={hg.id} role="row"
                className="grid items-stretch border-b border-border bg-[var(--il-grayblue-50)]"
                style={{ gridTemplateColumns: template, height: density === 'compact' ? 38 : 44 }}
              >
                {hg.headers.map((header) => {
                  const col = header.column;
                  const sorted = col.getIsSorted();
                  return (
                    <div
                      key={header.id}
                      role="columnheader"
                      aria-sort={sorted ? (sorted === 'asc' ? 'ascending' : 'descending') : 'none'}
                      onClick={col.getCanSort() ? col.getToggleSortingHandler() : undefined}
                      className={cn(
                        'group relative flex items-center gap-1.5 overflow-hidden bg-[var(--il-grayblue-50)] px-2.5 text-[11px] font-bold uppercase tracking-[0.05em] text-muted-foreground select-none',
                        cellAlign(col.columnDef.meta),
                        col.getCanSort() && 'cursor-pointer hover:text-foreground',
                        sorted && 'text-[var(--il-blue-700)]',
                        lastPinned === col.id && 'after:absolute after:inset-y-0 after:right-0 after:w-px after:bg-border',
                      )}
                      style={pinStyle(col.id, true)}
                    >
                      <span className="truncate">
                        {header.isPlaceholder ? null : flexRender(col.columnDef.header, header.getContext())}
                      </span>
                      {col.getCanSort() && (
                        <span className={cn('shrink-0 opacity-0 transition-opacity group-hover:opacity-100', sorted && 'opacity-100')}>
                          {sorted === 'desc' ? <ArrowDown className="size-3" /> : <ArrowUp className="size-3" />}
                        </span>
                      )}
                      {col.id !== '__select' && (
                        <DropdownMenu>
                          <DropdownMenuTrigger asChild>
                            <button
                              type="button"
                              aria-label={`Column options for ${columnLabel(col.id, col.columnDef.header)}`}
                              onClick={(e) => e.stopPropagation()}
                              className="ml-auto grid size-5 shrink-0 place-items-center rounded-xs text-muted-foreground opacity-0 hover:bg-[var(--il-grayblue-200)] hover:text-foreground group-hover:opacity-100 data-[state=open]:opacity-100"
                            >
                              <MoreVertical className="size-3.5" />
                            </button>
                          </DropdownMenuTrigger>
                          <DropdownMenuContent align="end" onClick={(e) => e.stopPropagation()}>
                            <DropdownMenuItem disabled={!col.getCanSort()} active={sorted === 'asc'} onSelect={() => col.toggleSorting(false)}>
                              <ArrowUp />Sort ascending
                            </DropdownMenuItem>
                            <DropdownMenuItem disabled={!col.getCanSort()} active={sorted === 'desc'} onSelect={() => col.toggleSorting(true)}>
                              <ArrowDown />Sort descending
                            </DropdownMenuItem>
                            <DropdownMenuSeparator />
                            {col.columnDef.meta?.groupable && (
                              <DropdownMenuItem active={col.getIsGrouped()} onSelect={() => col.toggleGrouping()}>
                                {col.getIsGrouped() ? 'Remove grouping' : 'Group by this column'}
                              </DropdownMenuItem>
                            )}
                            <DropdownMenuItem active={col.getIsPinned() === 'left'} onSelect={() => col.pin(col.getIsPinned() === 'left' ? false : 'left')}>
                              {col.getIsPinned() === 'left' ? 'Unpin column' : 'Pin left'}
                            </DropdownMenuItem>
                            <DropdownMenuItem disabled={!col.getCanHide()} onSelect={() => col.toggleVisibility(false)}>
                              Hide column
                            </DropdownMenuItem>
                          </DropdownMenuContent>
                        </DropdownMenu>
                      )}
                      {col.getCanResize() && (
                        <span
                          role="separator"
                          aria-label={`Resize ${col.id}`}
                          onClick={(e) => e.stopPropagation()}
                          onMouseDown={header.getResizeHandler()}
                          onTouchStart={header.getResizeHandler()}
                          className="absolute right-0 top-0 z-10 h-full w-1.5 cursor-col-resize touch-none select-none after:absolute after:inset-y-[20%] after:right-0.5 after:w-px after:bg-[var(--il-grayblue-300)] after:opacity-0 hover:after:opacity-100"
                        />
                      )}
                    </div>
                  );
                })}
                <div className="bg-[var(--il-grayblue-50)]" />
              </div>
            ))}

            {filterRow && (
              <div
                role="row"
                className="grid items-center border-b border-border bg-card"
                style={{ gridTemplateColumns: template, height: 38 }}
              >
                {leafColumns.map((col) => {
                  const variant = col.columnDef.meta?.filterVariant ?? 'text';
                  const value = (col.getFilterValue() as string) ?? '';
                  if (variant === 'none') return <div key={col.id} style={pinStyle(col.id, true)} className="bg-card" />;
                  return (
                    <div key={col.id} className="flex items-center overflow-hidden bg-card px-1.5" style={pinStyle(col.id, true)}>
                      {variant === 'select' ? (
                        <select
                          value={value}
                          aria-label={`Filter ${columnLabel(col.id, col.columnDef.header)}`}
                          onChange={(e) => col.setFilterValue(e.target.value || undefined)}
                          className={cn(
                            'h-6.5 w-full rounded-sm border bg-card px-1.5 text-xs text-foreground outline-none',
                            value ? 'border-[var(--il-blue-300)] bg-[var(--il-blue-50)]' : 'border-[var(--il-grayblue-100)]',
                          )}
                        >
                          <option value="">All</option>
                          {(col.columnDef.meta?.filterOptions ?? []).map((o) => <option key={o} value={o}>{o}</option>)}
                        </select>
                      ) : (
                        <input
                          value={value}
                          aria-label={`Filter ${columnLabel(col.id, col.columnDef.header)}`}
                          placeholder={variant === 'number' ? '> 100' : 'Filter…'}
                          onChange={(e) => col.setFilterValue(e.target.value || undefined)}
                          className={cn(
                            'h-6.5 w-full rounded-sm border bg-card px-1.5 text-xs text-foreground outline-none placeholder:text-muted-foreground/60',
                            value ? 'border-[var(--il-blue-300)] bg-[var(--il-blue-50)]' : 'border-[var(--il-grayblue-100)]',
                          )}
                        />
                      )}
                    </div>
                  );
                })}
                <div className="bg-card" />
              </div>
            )}
          </div>

          {/* body */}
          {rows.length === 0 ? (
            <div className="sticky left-0 flex flex-col items-center gap-2 px-5 py-14 text-center text-muted-foreground">
              <Inbox className="size-6 opacity-50" />
              <b className="text-base text-foreground/70">{emptyTitle ?? t('LoopConsole::Common:NoData')}</b>
              <span className="max-w-[34ch] text-sm">{emptyMessage ?? t('LoopConsole::Common:NoDataHint')}</span>
            </div>
          ) : (
            <div className="relative" style={{ height: virtualizer.getTotalSize() }}>
              {virtualizer.getVirtualItems().map((v) => {
                const row = rows[v.index];
                const top = v.start - headH;

                if (row.getIsGrouped()) {
                  const aggregates = row.getVisibleCells().filter((c) => c.getIsAggregated() && c.column.columnDef.aggregationFn);
                  return (
                    <div
                      key={row.id} role="row"
                      onClick={row.getToggleExpandedHandler()}
                      className="absolute inset-x-0 flex cursor-pointer items-center border-b border-border bg-[var(--il-grayblue-50)] hover:bg-[var(--il-grayblue-100)]"
                      style={{ top, height: rowH, minWidth }}
                    >
                      <div className="sticky left-0 flex items-center gap-2" style={{ paddingLeft: 12 + row.depth * 20 }}>
                        <ChevronRight className={cn('size-3.5 text-muted-foreground transition-transform', row.getIsExpanded() && 'rotate-90')} />
                        <span className="text-[11px] font-bold uppercase tracking-[0.05em] text-muted-foreground">
                          {columnLabel(row.groupingColumnId!, table.getColumn(row.groupingColumnId!)?.columnDef.header)}
                        </span>
                        <span className="text-sm font-bold">{String(row.getGroupingValue(row.groupingColumnId!) ?? '—')}</span>
                        <span className="rounded-full border border-border bg-card px-2 py-px text-xs font-semibold text-muted-foreground">
                          {row.subRows.length}
                        </span>
                        {aggregates.map((c) => (
                          <span key={c.id} className="flex items-center gap-1 whitespace-nowrap text-xs text-muted-foreground">
                            {columnLabel(c.column.id, c.column.columnDef.header)}
                            <b className="font-bold tabular-nums text-foreground">
                              {flexRender(c.column.columnDef.aggregatedCell ?? c.column.columnDef.cell, c.getContext())}
                            </b>
                          </span>
                        ))}
                      </div>
                    </div>
                  );
                }

                return (
                  <div
                    key={row.id} role="row"
                    onClick={onRowClick ? () => onRowClick(row.original) : undefined}
                    className={cn(
                      'group absolute inset-x-0 grid items-stretch border-b border-[var(--il-grayblue-100)] bg-card',
                      onRowClick && 'cursor-pointer',
                      row.getIsSelected() ? 'bg-[var(--il-blue-50)]' : 'hover:bg-[var(--il-grayblue-50)]',
                    )}
                    style={{ top, height: rowH, gridTemplateColumns: template }}
                  >
                    {row.getVisibleCells().map((cell) => (
                      <div
                        key={cell.id}
                        role="gridcell"
                        className={cn(
                          'flex items-center gap-1.5 overflow-hidden truncate whitespace-nowrap px-2.5 text-sm',
                          'bg-card group-hover:bg-[var(--il-grayblue-50)]',
                          row.getIsSelected() && 'bg-[var(--il-blue-50)] group-hover:bg-[var(--il-blue-50)]',
                          cellAlign(cell.column.columnDef.meta),
                          lastPinned === cell.column.id && 'after:absolute after:inset-y-0 after:right-0 after:w-px after:bg-border',
                        )}
                        style={pinStyle(cell.column.id)}
                      >
                        {flexRender(cell.column.columnDef.cell, cell.getContext())}
                      </div>
                    ))}
                    <div className="bg-card group-hover:bg-[var(--il-grayblue-50)]" />
                  </div>
                );
              })}
            </div>
          )}
        </div>
        {loading && rows.length > 0 && <div className="pointer-events-none absolute inset-0 z-20 bg-card/55" />}
      </div>

      {showFooter && (
        <DataGridPagination table={table} totalRows={total} pageSizeOptions={pageSizeOptions} server={server} />
      )}
    </div>
  );
}
