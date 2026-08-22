import { useQuery } from '@tanstack/react-query';
import { Link } from '@tanstack/react-router';
import { AlertTriangle, Boxes, Package, TrendingUp } from 'lucide-react';
import { StatCard } from '@/components/ui/stat-card';
import { Card, CardHeader, CardTitle, CardContent } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
import { ActivityFeed } from '@/components/data/activity-feed';
import { ordersApi, orderKeys } from '@/lib/api/orders';
import { ACTIVITIES } from '@/lib/api/mock-data';
import { formatMoney, formatNumber } from '@/lib/utils';

const TONE: Record<string, 'success' | 'warning' | 'destructive' | 'default' | 'secondary'> = {
  Shipped: 'success', 'QC hold': 'warning', Delayed: 'destructive',
  'In production': 'default', Planned: 'secondary',
};

export function DashboardPage() {
  const query = { page: 1, pageSize: 6, sorting: 'value desc', filter: '', columnFilters: {}, grouping: [] };
  const { data } = useQuery({ queryKey: orderKeys.list(query), queryFn: () => ordersApi.list(query) });

  return (
    <div className="mx-auto max-w-[1560px] space-y-5 p-6">
      <div className="grid gap-5 sm:grid-cols-2 xl:grid-cols-4">
        <StatCard label="Open orders" value="1,284" delta="+4.2%" direction="up" hint="vs. last month" icon={<Package />} tone="brand" />
        <StatCard label="Units in production" value="4.82M" delta="+11.8%" direction="up" hint="across 4 plants" icon={<Boxes />} />
        <StatCard label="Quality index" value="97.4" delta="+0.6" direction="up" hint="target 96.0" icon={<TrendingUp />} tone="success" />
        <StatCard label="Defect rate" value="1.94%" delta="+0.21" direction="up" invert hint="control limit 2.5%" icon={<AlertTriangle />} tone="warning" />
      </div>

      <div className="grid gap-5 xl:grid-cols-[minmax(0,1fr)_400px]">
        <Card>
          <CardHeader>
            <CardTitle>Highest-value orders</CardTitle>
            <Button asChild variant="ghost" size="sm" className="ml-auto">
              <Link to="/orders">View all</Link>
            </Button>
          </CardHeader>
          <CardContent className="px-0 pb-0">
            <table className="w-full border-collapse">
              <thead>
                <tr>
                  {['Order', 'Client', 'Division', 'Status', 'Units', 'Value'].map((h, i) => (
                    <th key={h} className={`border-y border-[var(--il-grayblue-100)] bg-[var(--il-grayblue-50)] px-5 py-2 text-[10px] font-bold uppercase tracking-[0.06em] text-muted-foreground ${i > 3 ? 'text-right' : 'text-left'}`}>
                      {h}
                    </th>
                  ))}
                </tr>
              </thead>
              <tbody>
                {(data?.items ?? []).map((o) => (
                  <tr key={o.id} className="hover:bg-[var(--il-grayblue-50)]">
                    <td className="border-b border-[var(--il-grayblue-100)] px-5 py-3 text-sm font-semibold">
                      <Link to="/orders/$orderId" params={{ orderId: o.id }}>{o.id}</Link>
                    </td>
                    <td className="border-b border-[var(--il-grayblue-100)] px-5 py-3 text-sm">{o.client}</td>
                    <td className="border-b border-[var(--il-grayblue-100)] px-5 py-3 text-sm text-muted-foreground">{o.division}</td>
                    <td className="border-b border-[var(--il-grayblue-100)] px-5 py-3"><Badge variant={TONE[o.status]} dot>{o.status}</Badge></td>
                    <td className="border-b border-[var(--il-grayblue-100)] px-5 py-3 text-right text-sm tabular-nums">{formatNumber(o.units)}</td>
                    <td className="border-b border-[var(--il-grayblue-100)] px-5 py-3 text-right text-sm font-bold tabular-nums">{formatMoney(o.value)}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </CardContent>
        </Card>

        <Card className="p-5">
          <ActivityFeed title="Recent activity" items={ACTIVITIES} now={new Date('2026-08-02T14:20:00')} maxHeight={430} endMessage="" />
        </Card>
      </div>
    </div>
  );
}
