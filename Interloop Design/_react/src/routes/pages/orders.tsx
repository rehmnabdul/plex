import * as React from 'react';
import { useQuery } from '@tanstack/react-query';
import { useNavigate } from '@tanstack/react-router';
import { createColumnHelper } from '@tanstack/react-table';
import { Plus } from 'lucide-react';
import { useTranslation } from 'react-i18next';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
import { UserAvatar } from '@/components/ui/avatar';
import { DataGrid, type DataGridQuery } from '@/components/data/data-grid';
import { orderKeys, ordersApi } from '@/lib/api/orders';
import { divisions, orderStatuses, plants, type Order } from '@/lib/api/types';
import { formatMoney, formatNumber } from '@/lib/utils';

const tone: Record<string, 'success' | 'warning' | 'destructive' | 'default' | 'secondary'> = {
  Shipped: 'success', 'QC hold': 'warning', Delayed: 'destructive',
  'In production': 'default', Planned: 'secondary',
};

const col = createColumnHelper<Order>();

export const orderColumns = [
  col.accessor('id', { header: 'Order', size: 120, enableHiding: false }),
  col.accessor('client', {
    header: 'Client', size: 190,
    meta: { groupable: true },
    cell: (c) => (
      <span className="flex min-w-0 items-center gap-2">
        <UserAvatar name={c.getValue()} size={22} />
        <span className="truncate">{c.getValue()}</span>
      </span>
    ),
  }),
  col.accessor('division', { header: 'Division', size: 130, meta: { groupable: true, filterVariant: 'select', filterOptions: [...divisions] } }),
  col.accessor('plant', { header: 'Plant', size: 140, meta: { groupable: true, filterVariant: 'select', filterOptions: [...plants] } }),
  col.accessor('status', {
    header: 'Status', size: 150,
    meta: { groupable: true, filterVariant: 'select', filterOptions: [...orderStatuses] },
    cell: (c) => <Badge variant={tone[c.getValue()] ?? 'secondary'} dot>{c.getValue()}</Badge>,
  }),
  col.accessor('units', {
    header: 'Units', size: 110, meta: { numeric: true, filterVariant: 'number' },
    aggregationFn: 'sum', cell: (c) => formatNumber(c.getValue()),
    aggregatedCell: (c) => formatNumber(Number(c.getValue() ?? 0)),
  }),
  col.accessor('value', {
    header: 'Order value', size: 145, meta: { numeric: true, filterVariant: 'number' },
    aggregationFn: 'sum', cell: (c) => formatMoney(c.getValue()),
    aggregatedCell: (c) => formatMoney(Number(c.getValue() ?? 0)),
  }),
  col.accessor('defects', {
    header: 'Defect %', size: 110, meta: { numeric: true, filterVariant: 'number' },
    aggregationFn: 'mean',
    cell: (c) => (
      <span className={c.getValue() > 2.5 ? 'font-bold text-danger-ink' : undefined}>{c.getValue().toFixed(2)}%</span>
    ),
    aggregatedCell: (c) => `${Number(c.getValue() ?? 0).toFixed(2)}%`,
  }),
  col.accessor('owner', { header: 'Merchandiser', size: 170, meta: { groupable: true } }),
  col.accessor('ship', { header: 'Ship date', size: 130 }),
];

export function OrdersPage() {
  const { t } = useTranslation();
  const navigate = useNavigate();
  const [query, setQuery] = React.useState<DataGridQuery>({
    page: 1, pageSize: 50, sorting: 'value desc', filter: '', columnFilters: {}, grouping: [],
  });

  const { data, isFetching } = useQuery({
    queryKey: orderKeys.list(query),
    queryFn: () => ordersApi.list(query),
  });

  return (
    <div className="mx-auto max-w-[1560px] p-6">
      <DataGrid
        mode="server"
        columns={orderColumns}
        data={data?.items ?? []}
        rowCount={data?.totalCount ?? 0}
        loading={isFetching}
        onQueryChange={setQuery}
        getRowId={(row) => row.id}
        onRowClick={(row) => navigate({ to: '/orders/$orderId', params: { orderId: row.id } })}
        title={t('LoopConsole::Orders:Title')}
        subtitle={t('LoopConsole::Orders:Subtitle')}
        selectable
        showExport
        showFilterRow
        initialSorting={[{ id: 'value', desc: true }]}
        initialPinning={{ left: ['__select', 'id'] }}
        initialVisibility={{ ship: false }}
        pageSize={50}
        height="calc(100vh - 8rem)"
        actions={<Button size="sm"><Plus />{t('LoopConsole::Orders:New')}</Button>}
      />
    </div>
  );
}
