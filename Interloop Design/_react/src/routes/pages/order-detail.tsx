import * as React from 'react';
import { useQuery } from '@tanstack/react-query';
import { Link, useParams } from '@tanstack/react-router';
import { createColumnHelper } from '@tanstack/react-table';
import { ChevronLeft } from 'lucide-react';
import { useTranslation } from 'react-i18next';
import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import { UserAvatar } from '@/components/ui/avatar';
import { Card } from '@/components/ui/card';
import { Skeleton } from '@/components/ui/skeleton';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { DataGrid } from '@/components/data/data-grid';
import { CollapsibleSection, FactGrid } from '@/components/orders/collapsible-section';
import { ProductionMatrix } from '@/components/orders/production-matrix';
import { TAPanel } from '@/components/orders/ta-panel';
import { orderKeys, ordersApi } from '@/lib/api/orders';
import type { OrderItem } from '@/lib/api/types';
import { formatDate, formatNumber } from '@/lib/utils';

const col = createColumnHelper<OrderItem>();
const itemColumns = [
  col.accessor('id', { header: 'Item ID', size: 120, enableHiding: false }),
  col.accessor('pack', { header: 'Pack', size: 120, meta: { groupable: true, filterVariant: 'select', filterOptions: ['SOLID', 'ASSORTED'] } }),
  col.accessor('department', { header: 'Department', size: 180, meta: { groupable: true } }),
  col.accessor('klass', { header: 'Class', size: 180, meta: { groupable: true } }),
  col.accessor('line', { header: 'Product line', size: 120, meta: { groupable: true } }),
  col.accessor('category', { header: 'Product category', size: 160, meta: { groupable: true } }),
  col.accessor('brand', { header: 'Brand', size: 130, meta: { groupable: true } }),
  col.accessor('style', { header: 'Style ID', size: 120 }),
  col.accessor('color', { header: 'Color', size: 150 }),
  col.accessor('size', { header: 'Size', size: 90, meta: { align: 'center' } }),
  col.accessor('casePack', { header: 'Case pack', size: 110, meta: { numeric: true } }),
  col.accessor('qty', {
    header: 'Order quantity', size: 140, meta: { numeric: true, filterVariant: 'number' },
    aggregationFn: 'sum', cell: (c) => formatNumber(c.getValue()),
    aggregatedCell: (c) => formatNumber(Number(c.getValue() ?? 0)),
  }),
  col.accessor('cartons', {
    header: 'Order cartons', size: 130, meta: { numeric: true },
    aggregationFn: 'sum', cell: (c) => formatNumber(c.getValue()),
    aggregatedCell: (c) => formatNumber(Number(c.getValue() ?? 0)),
  }),
];

export function OrderDetailPage() {
  const { t } = useTranslation();
  const { orderId } = useParams({ from: '/orders/$orderId' });
  const [tab, setTab] = React.useState('info');

  const { data, isPending } = useQuery({
    queryKey: orderKeys.detail(orderId),
    queryFn: () => ordersApi.detail(orderId),
  });

  if (isPending || !data) {
    return (
      <div className="mx-auto grid max-w-[1560px] grid-cols-[minmax(0,1fr)_392px] gap-5 p-7">
        <Skeleton className="h-[520px]" />
        <Skeleton className="h-[520px]" />
      </div>
    );
  }

  const totalQty = data.items.reduce((s: number, i: OrderItem) => s + i.qty, 0);

  return (
    <>
      <header className="sticky top-0 z-30 border-b border-border bg-card">
        <div className="mx-auto flex max-w-[1560px] items-center gap-4 px-7 pb-4 pt-3.5">
          <div className="mr-auto min-w-0">
            <Link to="/orders" className="inline-flex items-center gap-1.5 text-sm font-semibold">
              <ChevronLeft className="size-3.5" />{t('LoopConsole::Order:BackToList')}
            </Link>
            <h1 className="truncate text-2xl font-extrabold tracking-tight">34557APPAREL_InterloopLimited</h1>
            <div className="mt-1.5 flex flex-wrap items-center gap-2.5 text-xs text-muted-foreground">
              <Badge>Apparel</Badge>
              <Dot /><span>PO <b className="font-semibold text-muted-foreground">{data.po.number}</b></span>
              <Dot /><span>Target Corporation</span>
              <Dot /><span>Ship <b className="font-semibold text-muted-foreground">{formatDate(data.po.shipBegin)} – {formatDate(data.po.shipEnd)}</b></span>
              <Dot /><span><b className="font-semibold text-muted-foreground">{formatNumber(totalQty)}</b> pcs · {data.items.length} item IDs</span>
            </div>
          </div>
          <Button variant="outline">{t('LoopConsole::Order:Split')}</Button>
          <Button>{t('LoopConsole::Order:UpdateStatus')}</Button>
        </div>
      </header>

      <div className="mx-auto grid max-w-[1560px] grid-cols-1 items-start gap-5 px-7 pb-10 pt-5 xl:grid-cols-[minmax(0,1fr)_392px]">
        <main>
          <Tabs value={tab} onValueChange={setTab}>
            <Card className="mb-5 px-4 pt-1">
              <TabsList className="w-full">
                <TabsTrigger value="info">{t('LoopConsole::Order:Tab:Information')}</TabsTrigger>
                <TabsTrigger value="people" count={data.stakeholders.length}>{t('LoopConsole::Order:Tab:Stakeholders')}</TabsTrigger>
                <TabsTrigger value="prod">{t('LoopConsole::Order:Tab:Production')}</TabsTrigger>
              </TabsList>
            </Card>

            <TabsContent value="info" className="space-y-5">
              <CollapsibleSection
                title={t('LoopConsole::Order:PurchaseOrderInformation')}
                tail={<>PO <b className="text-foreground">{data.po.number}</b></>}
              >
                <FactGrid
                  facts={[
                    { label: 'PO number', value: data.po.number },
                    { label: 'OPO number', value: data.po.opo },
                    { label: 'PO type', value: data.po.type },
                    { label: 'Commit ID', value: data.po.commit },
                    { label: 'Product line', value: data.po.line },
                    { label: 'Product category', value: data.po.category },
                    { label: 'In-store date', value: formatDate(data.po.inStore) },
                    { label: 'Ship begin', value: formatDate(data.po.shipBegin) },
                    { label: 'Ship end', value: formatDate(data.po.shipEnd) },
                  ]}
                />
              </CollapsibleSection>

              <CollapsibleSection
                title={t('LoopConsole::Order:ProductInformation')}
                tail={<>{data.items.length} item IDs · {formatNumber(totalQty)} pcs</>}
              >
                <DataGrid
                  columns={itemColumns}
                  data={data.items}
                  getRowId={(row) => row.id}
                  initialGrouping={['pack']}
                  initialPinning={{ left: ['id'] }}
                  defaultDensity="compact"
                  height={470}
                  pageSize={25}
                  pageSizeOptions={[10, 25, 50]}
                  showExport
                  showToolbar
                />
              </CollapsibleSection>
            </TabsContent>

            <TabsContent value="people">
              <CollapsibleSection title={t('LoopConsole::Order:Tab:Stakeholders')} tail={<>{data.stakeholders.length} people</>}>
                <div className="grid grid-cols-[repeat(auto-fill,minmax(280px,1fr))] gap-3.5">
                  {data.stakeholders.map((p: { role: string; name: string; org: string; email: string }) => (
                    <div key={p.email} className="flex items-center gap-3.5 rounded-md border border-[var(--il-grayblue-100)] p-3.5 transition-colors hover:border-[var(--il-blue-300)]">
                      <UserAvatar name={p.name} size={40} />
                      <div className="min-w-0">
                        <div className="text-[10px] font-bold uppercase tracking-[0.07em] text-muted-foreground">{p.role}</div>
                        <div className="mt-0.5 text-sm font-bold">{p.name}</div>
                        <div className="truncate text-xs text-muted-foreground">{p.org}</div>
                        <a href={`mailto:${p.email}`} className="block truncate text-xs">{p.email}</a>
                      </div>
                    </div>
                  ))}
                </div>
              </CollapsibleSection>
            </TabsContent>

            <TabsContent value="prod">
              <CollapsibleSection title={t('LoopConsole::Order:Tab:Production')} tail={<>Updated 2 h ago from HMS Oracle</>}>
                <ProductionMatrix rows={data.production} stages={data.stages} />
              </CollapsibleSection>
            </TabsContent>
          </Tabs>
        </main>

        <aside className="top-24 flex flex-col gap-5 xl:sticky">
          <TAPanel
            order={{ form: 'Accessories T&A form', contact: 'Zia Mohyuddin', plannedShip: data.po.shipBegin }}
            milestones={data.milestones}
            activities={data.activities}
            now={new Date('2026-08-02T14:20:00')}
          />
        </aside>
      </div>
    </>
  );
}

const Dot = () => <span className="size-[3px] rounded-full bg-[var(--il-grayblue-300)]" />;
