import type { Table } from '@tanstack/react-table';
import { ChevronLeft, ChevronRight, ChevronsLeft, ChevronsRight } from 'lucide-react';
import { useTranslation } from 'react-i18next';
import { IconButton } from '@/components/ui/icon-button';
import {
  Select, SelectContent, SelectItem, SelectTrigger, SelectValue,
} from '@/components/ui/select';

interface Props<TData> {
  table: Table<TData>;
  totalRows: number;
  pageSizeOptions: number[];
  server: boolean;
}

export function DataGridPagination<TData>({ table, totalRows, pageSizeOptions, server }: Props<TData>) {
  const { t } = useTranslation();
  const { pageIndex, pageSize } = table.getState().pagination;
  const pageCount = Math.max(1, Math.ceil(totalRows / pageSize));
  const from = totalRows === 0 ? 0 : pageIndex * pageSize + 1;
  const to = Math.min((pageIndex + 1) * pageSize, totalRows);

  return (
    <div className="flex shrink-0 flex-wrap items-center gap-4 border-t border-border bg-card px-3 py-2 text-sm text-muted-foreground">
      <label className="flex items-center gap-2">
        {t('LoopConsole::Common:Rows')}
        <Select value={String(pageSize)} onValueChange={(v) => table.setPageSize(Number(v))}>
          <SelectTrigger className="h-7 w-[72px] text-sm" aria-label="Rows per page">
            <SelectValue />
          </SelectTrigger>
          <SelectContent>
            {pageSizeOptions.map((n) => <SelectItem key={n} value={String(n)}>{n}</SelectItem>)}
          </SelectContent>
        </Select>
      </label>

      <span className="tabular-nums">
        <b className="font-bold text-foreground">{from.toLocaleString()}–{to.toLocaleString()}</b> of{' '}
        <b className="font-bold text-foreground">{totalRows.toLocaleString()}</b>
        {server && ' · server-side'}
      </span>

      <div className="ml-auto flex items-center gap-1">
        <IconButton variant="outline" size="sm" aria-label="First page" disabled={pageIndex === 0} onClick={() => table.setPageIndex(0)}><ChevronsLeft /></IconButton>
        <IconButton variant="outline" size="sm" aria-label={t('AbpUi::PagerPrevious')} disabled={pageIndex === 0} onClick={() => table.previousPage()}><ChevronLeft /></IconButton>
        <span className="px-2 tabular-nums">
          Page <b className="font-bold text-foreground">{pageIndex + 1}</b> of <b className="font-bold text-foreground">{pageCount}</b>
        </span>
        <IconButton variant="outline" size="sm" aria-label={t('AbpUi::PagerNext')} disabled={pageIndex + 1 >= pageCount} onClick={() => table.nextPage()}><ChevronRight /></IconButton>
        <IconButton variant="outline" size="sm" aria-label="Last page" disabled={pageIndex + 1 >= pageCount} onClick={() => table.setPageIndex(pageCount - 1)}><ChevronsRight /></IconButton>
      </div>
    </div>
  );
}
