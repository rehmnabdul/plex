import * as React from 'react';
import type { Table } from '@tanstack/react-table';
import { Columns3, Download, Filter, FilterX, Group, Rows3, Search, X } from 'lucide-react';
import { useTranslation } from 'react-i18next';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import {
  DropdownMenu, DropdownMenuCheckboxItem, DropdownMenuContent,
  DropdownMenuLabel, DropdownMenuSeparator, DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu';
import { cn } from '@/lib/utils';

export const columnLabel = (id: string, header: unknown) =>
  typeof header === 'string' ? header : id;

interface ToolbarProps<TData> {
  table: Table<TData>;
  title?: string;
  subtitle?: string;
  search: string;
  onSearchChange: (v: string) => void;
  filterRow: boolean;
  onFilterRowChange: (v: boolean) => void;
  activeFilters: number;
  onClearFilters: () => void;
  density: 'comfortable' | 'compact';
  onDensityChange: (d: 'comfortable' | 'compact') => void;
  selectedCount: number;
  onClearSelection: () => void;
  showSearch?: boolean;
  showGroup?: boolean;
  showColumns?: boolean;
  showDensity?: boolean;
  onExport?: () => void;
  actions?: React.ReactNode;
}

export function DataGridToolbar<TData>({
  table, title, subtitle, search, onSearchChange, filterRow, onFilterRowChange,
  activeFilters, onClearFilters, density, onDensityChange, selectedCount, onClearSelection,
  showSearch = true, showGroup = true, showColumns = true, showDensity = true, onExport, actions,
}: ToolbarProps<TData>) {
  const { t } = useTranslation();
  const grouping = table.getState().grouping;
  const groupable = table.getAllLeafColumns().filter((c) => c.getCanGroup() && c.columnDef.meta?.groupable);

  return (
    <div className="flex min-h-14 shrink-0 flex-wrap items-center gap-2 border-b border-[var(--il-grayblue-100)] px-3 py-2.5">
      {(title || subtitle) && (
        <div className="mr-auto flex min-w-0 flex-col pr-2">
          {title && <span className="truncate text-base font-bold leading-tight">{title}</span>}
          {subtitle && <span className="truncate text-xs text-muted-foreground">{subtitle}</span>}
        </div>
      )}
      {!title && !subtitle && <span className="mr-auto" />}

      {grouping.length > 0 && (
        <div className="flex flex-wrap items-center gap-1.5">
          <span className="text-[11px] font-bold uppercase tracking-[0.06em] text-muted-foreground">Grouped by</span>
          {grouping.map((id) => {
            const col = table.getColumn(id);
            return (
              <span key={id} className="inline-flex h-6.5 items-center gap-1 rounded-full border border-[var(--il-blue-200)] bg-info-soft py-0.5 pl-2.5 pr-1 text-xs font-semibold text-info-ink">
                {columnLabel(id, col?.columnDef.header)}
                <button type="button" aria-label={`Remove grouping ${id}`} onClick={() => col?.toggleGrouping()} className="grid size-4 place-items-center rounded-full hover:bg-[var(--il-blue-200)]">
                  <X className="size-3" />
                </button>
              </span>
            );
          })}
        </div>
      )}

      {selectedCount > 0 && (
        <span className="inline-flex items-center gap-2 rounded-full bg-info-soft py-1 pl-3 pr-1 text-xs font-semibold text-info-ink">
          {selectedCount} selected
          <button type="button" onClick={onClearSelection} className="rounded-full px-2 py-0.5 hover:bg-[var(--il-blue-200)]">Clear</button>
        </span>
      )}

      {showSearch && (
        <Input
          value={search}
          onChange={(e) => onSearchChange(e.target.value)}
          placeholder={t('LoopConsole::Common:Search')}
          aria-label="Search rows"
          startAdornment={<Search />}
          className="h-8 w-[200px] text-sm"
        />
      )}

      <Button
        variant="outline" size="sm"
        aria-pressed={filterRow}
        onClick={() => onFilterRowChange(!filterRow)}
        className={cn(filterRow && 'border-[var(--il-blue-300)] bg-info-soft text-info-ink')}
      >
        <Filter />{t('LoopConsole::Common:Filters')}
        {activeFilters > 0 && (
          <span className="ml-0.5 inline-flex h-4 min-w-4 items-center justify-center rounded-full bg-primary px-1 text-[10px] font-bold text-white">{activeFilters}</span>
        )}
      </Button>

      {activeFilters > 0 && (
        <Button variant="outline" size="sm" onClick={onClearFilters} aria-label="Clear all filters"><FilterX /></Button>
      )}

      {showGroup && groupable.length > 0 && (
        <DropdownMenu>
          <DropdownMenuTrigger asChild>
            <Button variant="outline" size="sm"><Group />{t('LoopConsole::Common:Group')}</Button>
          </DropdownMenuTrigger>
          <DropdownMenuContent align="end">
            <DropdownMenuLabel>Group rows by</DropdownMenuLabel>
            {groupable.map((c) => (
              <DropdownMenuCheckboxItem key={c.id} checked={c.getIsGrouped()} onCheckedChange={() => c.toggleGrouping()}>
                {columnLabel(c.id, c.columnDef.header)}
              </DropdownMenuCheckboxItem>
            ))}
            {grouping.length > 0 && (
              <>
                <DropdownMenuSeparator />
                <DropdownMenuCheckboxItem checked={false} onCheckedChange={() => table.setGrouping([])}>Clear grouping</DropdownMenuCheckboxItem>
              </>
            )}
          </DropdownMenuContent>
        </DropdownMenu>
      )}

      {showColumns && (
        <DropdownMenu>
          <DropdownMenuTrigger asChild>
            <Button variant="outline" size="sm"><Columns3 />{t('LoopConsole::Common:Columns')}</Button>
          </DropdownMenuTrigger>
          <DropdownMenuContent align="end" className="max-h-80">
            <DropdownMenuLabel>Columns</DropdownMenuLabel>
            {table.getAllLeafColumns().filter((c) => c.getCanHide()).map((c) => (
              <DropdownMenuCheckboxItem
                key={c.id}
                checked={c.getIsVisible()}
                onCheckedChange={(v) => c.toggleVisibility(!!v)}
                onSelect={(e) => e.preventDefault()}
              >
                {columnLabel(c.id, c.columnDef.header)}
              </DropdownMenuCheckboxItem>
            ))}
          </DropdownMenuContent>
        </DropdownMenu>
      )}

      {showDensity && (
        <Button
          variant="outline" size="sm" aria-label="Toggle row density"
          onClick={() => onDensityChange(density === 'compact' ? 'comfortable' : 'compact')}
        >
          <Rows3 />
        </Button>
      )}

      {onExport && (
        <Button variant="outline" size="sm" aria-label="Export page as CSV" onClick={onExport}><Download /></Button>
      )}

      {actions}
    </div>
  );
}
