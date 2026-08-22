// Loop Console — Orders screen (data table view).
function OrdersScreen() {
  const { Card, Badge, Button, IconButton, Avatar, Tabs, Input, Checkbox } = window.ILPDesignSystem_7d03df;
  const D = window.LC_DATA;
  const [tab, setTab] = React.useState('all');
  const [q, setQ] = React.useState('');

  const counts = {
    all: D.orders.length,
    production: D.orders.filter(o => o.status === 'In production').length,
    overdue: D.orders.filter(o => o.status === 'Overdue').length,
    shipped: D.orders.filter(o => o.status === 'Shipped').length,
  };

  let rows = D.orders;
  if (tab === 'production') rows = rows.filter(o => o.status === 'In production');
  if (tab === 'overdue') rows = rows.filter(o => o.status === 'Overdue');
  if (tab === 'shipped') rows = rows.filter(o => o.status === 'Shipped');
  if (q.trim()) {
    const s = q.toLowerCase();
    rows = rows.filter(o => o.id.toLowerCase().includes(s) || o.client.toLowerCase().includes(s) || o.owner.toLowerCase().includes(s));
  }

  return (
    <div className="lc-page">
      <div className="lc-orders-head">
        <Tabs value={tab} onChange={setTab} tabs={[
          { value: 'all', label: 'All orders', count: counts.all },
          { value: 'production', label: 'In production', count: counts.production },
          { value: 'overdue', label: 'Overdue', count: counts.overdue },
          { value: 'shipped', label: 'Shipped', count: counts.shipped },
        ]} />
        <div className="lc-orders-actions">
          <Button variant="primary" leadingIcon={<i data-lucide="plus"></i>}>New order</Button>
        </div>
      </div>

      <Card flush>
        <div className="lc-table-toolbar">
          <div style={{ width: 280 }}>
            <Input value={q} onChange={(e) => setQ(e.target.value)} placeholder="Search orders…"
                   leadingIcon={<i data-lucide="search"></i>} />
          </div>
          <div className="lc-toolbar-right">
            <Button variant="secondary" leadingIcon={<i data-lucide="sliders-horizontal"></i>}>Filters</Button>
            <Button variant="secondary" leadingIcon={<i data-lucide="download"></i>}>Export</Button>
          </div>
        </div>

        <table className="lc-table lc-table--full">
          <thead>
            <tr>
              <th className="lc-th-check"><Checkbox /></th>
              <th>Order</th><th>Client</th><th>Division</th><th>Quantity</th><th>Due date</th><th>Owner</th><th>Status</th><th></th>
            </tr>
          </thead>
          <tbody>
            {rows.map((o) => (
              <tr key={o.id}>
                <td className="lc-th-check"><Checkbox /></td>
                <td><span className="lc-mono">{o.id}</span></td>
                <td className="lc-strong">{o.client}</td>
                <td>{o.division}</td>
                <td className="lc-num">{o.qty}</td>
                <td>{o.due}</td>
                <td>
                  <span className="lc-owner"><Avatar name={o.owner} size={26} /> {o.owner}</span>
                </td>
                <td><Badge color={D.statusColor[o.status]} dot>{o.status}</Badge></td>
                <td><IconButton size="sm" label="Row actions"><i data-lucide="more-horizontal"></i></IconButton></td>
              </tr>
            ))}
            {rows.length === 0 && (
              <tr><td colSpan="9" className="lc-empty">No orders match “{q}”.</td></tr>
            )}
          </tbody>
        </table>

        <div className="lc-pagination">
          <span className="lc-sub">Showing {rows.length} of {D.orders.length} orders</span>
          <div className="lc-pages">
            <IconButton size="sm" label="Previous"><i data-lucide="chevron-left"></i></IconButton>
            <button className="lc-page lc-page--active">1</button>
            <button className="lc-page">2</button>
            <button className="lc-page">3</button>
            <IconButton size="sm" label="Next"><i data-lucide="chevron-right"></i></IconButton>
          </div>
        </div>
      </Card>
    </div>
  );
}

window.OrdersScreen = OrdersScreen;
