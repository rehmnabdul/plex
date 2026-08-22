import * as React from 'react';
import { createColumnHelper } from '@tanstack/react-table';
import { Bell, Check, Download, Package, Plus, Trash2 } from 'lucide-react';
import { Logo } from '@/components/brand/logo';
import { Alert, AlertDescription, AlertTitle } from '@/components/ui/alert';
import { UserAvatar } from '@/components/ui/avatar';
import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { CheckboxField } from '@/components/ui/checkbox';
import { IconButton } from '@/components/ui/icon-button';
import { Field } from '@/components/ui/label';
import { Input } from '@/components/ui/input';
import { Progress } from '@/components/ui/progress';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';
import { SidebarNav } from '@/components/ui/sidebar-nav';
import { StatCard } from '@/components/ui/stat-card';
import { SwitchField } from '@/components/ui/switch';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { DataGrid } from '@/components/data/data-grid';
import { ActivityFeed } from '@/components/data/activity-feed';
import { NewOrderForm } from '@/components/orders/new-order-form';
import { ACTIVITIES, ORDERS } from '@/lib/api/mock-data';
import type { Order } from '@/lib/api/types';

function Section({ id, title, hint, children }: { id: string; title: string; hint?: string; children: React.ReactNode }) {
  return (
    <section id={id} className="scroll-mt-24">
      <header className="mb-3 flex items-baseline gap-3">
        <h2 className="text-xl font-extrabold tracking-tight">{title}</h2>
        {hint && <p className="text-sm text-muted-foreground">{hint}</p>}
      </header>
      <Card className="p-6">{children}</Card>
    </section>
  );
}

const SWATCHES: Array<[string, string]> = [
  ['Gray Blue', 'var(--il-grayblue-700)'],
  ['Just Blue', 'var(--il-blue-500)'],
  ['Earth', 'var(--il-earth)'],
  ['Water', 'var(--il-water)'],
  ['Air', 'var(--il-air)'],
  ['Sun', 'var(--il-sun)'],
  ['Danger', 'var(--il-red)'],
  ['Page', 'var(--il-grayblue-50)'],
];

const col = createColumnHelper<Order>();
const miniColumns = [
  col.accessor('id', { header: 'Order', size: 120 }),
  col.accessor('client', { header: 'Client', size: 160, meta: { groupable: true } }),
  col.accessor('division', { header: 'Division', size: 130, meta: { groupable: true, filterVariant: 'select', filterOptions: ['Hosiery', 'Denim', 'Apparel', 'Activewear', 'Yarns'] } }),
  col.accessor('units', { header: 'Units', size: 110, meta: { numeric: true }, aggregationFn: 'sum' }),
];

export function DesignSystemPage() {
  const sample = React.useMemo(() => ORDERS.slice(0, 120), []);
  return (
    <div className="mx-auto max-w-[1240px] space-y-8 p-6 pb-20">
      <header className="flex flex-wrap items-center gap-4">
        <Logo height={30} />
        <div className="mr-auto">
          <h1 className="text-2xl font-extrabold tracking-tight">Interloop Design System</h1>
          <p className="text-sm text-muted-foreground">Every component in the library, live. shadcn/ui APIs re-skinned with Interloop tokens.</p>
        </div>
        <Badge variant="outline">v0.1.0</Badge>
      </header>

      <Section id="colour" title="Colour" hint="Brand anchors and the elements palette">
        <div className="grid grid-cols-2 gap-3 sm:grid-cols-4 lg:grid-cols-8">
          {SWATCHES.map(([name, value]) => (
            <div key={name}>
              <div className="h-16 rounded-md border border-[var(--il-grayblue-100)]" style={{ background: value }} />
              <p className="mt-1.5 text-xs font-bold">{name}</p>
              <p className="font-mono text-[10px] text-muted-foreground">{value.replace('var(', '').replace(')', '')}</p>
            </div>
          ))}
        </div>
      </Section>

      <Section id="buttons" title="Button" hint="shadcn variants + the Interloop ink action">
        <div className="flex flex-wrap items-center gap-3">
          <Button>Default</Button>
          <Button variant="ink">Ink</Button>
          <Button variant="secondary">Secondary</Button>
          <Button variant="outline">Outline</Button>
          <Button variant="ghost">Ghost</Button>
          <Button variant="link">Link</Button>
          <Button variant="destructive"><Trash2 />Destructive</Button>
          <Button loading>Saving</Button>
          <Button disabled>Disabled</Button>
        </div>
        <div className="mt-4 flex flex-wrap items-center gap-3">
          <Button size="sm"><Plus />Small</Button>
          <Button size="default">Default</Button>
          <Button size="lg"><Download />Large</Button>
          <IconButton aria-label="Notifications" variant="outline" badge={3}><Bell /></IconButton>
          <IconButton aria-label="Add" variant="default" shape="pill"><Plus /></IconButton>
        </div>
      </Section>

      <Section id="badges" title="Badge & Avatar">
        <div className="flex flex-wrap items-center gap-3">
          <Badge>Info</Badge>
          <Badge variant="success" dot>Shipped</Badge>
          <Badge variant="warning" dot>QC hold</Badge>
          <Badge variant="destructive" dot>Delayed</Badge>
          <Badge variant="secondary">Planned</Badge>
          <Badge variant="outline">Draft</Badge>
          <Badge variant="solid">Live</Badge>
        </div>
        <div className="mt-5 flex items-center gap-4">
          <UserAvatar name="Ayesha Khan" size={48} status="online" />
          <UserAvatar name="Bilal Raza" size={40} status="busy" />
          <UserAvatar name="Sana Iqbal" size={32} />
          <UserAvatar name="Usman Tariq" size={24} />
        </div>
      </Section>

      <Section id="forms" title="Forms" hint="React Hook Form + Zod, with the shared Field wrapper">
        <div className="grid gap-8 lg:grid-cols-2">
          <div className="space-y-4">
            <Field label="Full name" required hint="As printed on the ID card">
              <Input placeholder="First Last" defaultValue="Kaiya Septimus" />
            </Field>
            <Field label="Password" error="Must be at least 8 characters">
              <Input type="password" defaultValue="123" invalid />
            </Field>
            <Field label="Division">
              <Select defaultValue="Denim">
                <SelectTrigger aria-label="Division"><SelectValue /></SelectTrigger>
                <SelectContent>
                  {['Hosiery', 'Denim', 'Apparel', 'Activewear', 'Yarns'].map((d) => <SelectItem key={d} value={d}>{d}</SelectItem>)}
                </SelectContent>
              </Select>
            </Field>
            <CheckboxField label="Email me weekly reports" description="Sent every Monday at 07:00 PKT" defaultChecked />
            <CheckboxField label="Partially selected" checked="indeterminate" />
            <SwitchField label="Push notifications" defaultChecked />
            <SwitchField label="Compact rows" size="sm" />
          </div>
          <div className="rounded-lg border border-[var(--il-grayblue-100)] p-5">
            <h3 className="mb-4 text-base font-bold">New order</h3>
            <NewOrderForm />
          </div>
        </div>
      </Section>

      <Section id="feedback" title="Alert & Progress">
        <div className="space-y-3">
          <Alert><AlertTitle>Heads up</AlertTitle><AlertDescription>The nightly HMS sync finishes at 05:30 PKT.</AlertDescription></Alert>
          <Alert variant="success"><AlertTitle>Inspection passed</AlertTitle><AlertDescription>ILP-10455 cleared final inspection at 98.2.</AlertDescription></Alert>
          <Alert variant="warning" onDismiss={() => {}}><AlertTitle>Defect rate climbing</AlertTitle><AlertDescription>Denim — Faisalabad II crossed the control limit twice this week.</AlertDescription></Alert>
          <Alert variant="destructive"><AlertTitle>Shipment blocked</AlertTitle><AlertDescription>Customs paperwork for ILP-10390 is missing the GOTS certificate.</AlertDescription></Alert>
        </div>
        <div className="mt-6 grid gap-4 sm:grid-cols-3">
          <Progress value={82} label="Cutting" showValue />
          <Progress value={46} tone="warning" label="Finishing" showValue />
          <Progress value={100} tone="success" label="Packing" showValue />
        </div>
      </Section>

      <Section id="stats" title="StatCard">
        <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
          <StatCard label="Open orders" value="1,284" delta="+4.2%" direction="up" hint="vs. last month" icon={<Package />} tone="brand" />
          <StatCard label="Quality index" value="97.4" delta="+0.6" direction="up" tone="success" icon={<Check />} />
          <StatCard label="Defect rate" value="1.94%" delta="+0.21" direction="up" invert tone="warning" />
          <StatCard label="On-time delivery" value="94.1%" delta="−1.3" direction="down" />
        </div>
      </Section>

      <Section id="tabs" title="Tabs & SidebarNav">
        <div className="grid gap-6 lg:grid-cols-[minmax(0,1fr)_264px]">
          <Tabs defaultValue="one">
            <TabsList>
              <TabsTrigger value="one">Order information</TabsTrigger>
              <TabsTrigger value="two" count={6}>Stakeholders</TabsTrigger>
              <TabsTrigger value="three">Production status</TabsTrigger>
            </TabsList>
            <TabsContent value="one" className="pt-4 text-sm text-muted-foreground">Purchase order facts live here.</TabsContent>
            <TabsContent value="two" className="pt-4 text-sm text-muted-foreground">Six people are attached to this order.</TabsContent>
            <TabsContent value="three" className="pt-4 text-sm text-muted-foreground">Stage-by-stage completion.</TabsContent>
          </Tabs>
          <div className="h-[300px] overflow-hidden rounded-lg">
            <SidebarNav
              activeKey="orders"
              header={<Logo tone="white" height={20} />}
              items={[
                { key: 'ops', label: 'Operations', section: true },
                { key: 'dashboard', label: 'Dashboard', icon: <Package /> },
                { key: 'orders', label: 'Orders', icon: <Package />, badge: 12 },
                { key: 'people', label: 'People', icon: <Bell /> },
              ]}
            />
          </div>
        </div>
      </Section>

      <Section id="datagrid" title="DataGrid" hint="TanStack Table — grouping, column filters, pinning, virtualised rows">
        <DataGrid
          columns={miniColumns}
          data={sample}
          getRowId={(r) => r.id}
          title="Orders (client mode)"
          subtitle="120 rows in memory"
          selectable
          showFilterRow
          showExport
          initialPinning={{ left: ['__select', 'id'] }}
          height={420}
          pageSize={25}
        />
        <p className="mt-3 text-sm text-muted-foreground">
          The full server-side configuration — 4,820 rows, debounced filters, paged fetches — runs on the Orders screen.
        </p>
      </Section>

      <Section id="activity" title="ActivityFeed">
        <ActivityFeed
          items={ACTIVITIES}
          now={new Date('2026-08-02T14:20:00')}
          maxHeight={420}
          tabs={[
            { id: 'all', label: 'All', count: ACTIVITIES.length },
            { id: 'quality', label: 'Quality', types: ['flag', 'alert', 'approval', 'rejected'] },
            { id: 'files', label: 'Files', types: ['upload'] },
          ]}
        />
      </Section>

      <Section id="document" title="ReportDocument" hint="Printable invoice / inspection report — see /design-system/document">
        <p className="text-sm text-muted-foreground">
          The document sheet renders at paper width, so it lives on its own route.{' '}
          <a href="/design-system/document">Open the invoice example →</a>
        </p>
      </Section>
    </div>
  );
}
