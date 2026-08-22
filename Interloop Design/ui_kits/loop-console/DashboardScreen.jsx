// Loop Console — Dashboard screen.
function ThroughputChart() {
  const bars = [62, 78, 54, 90, 72, 84, 96, 68, 80, 58, 88, 76];
  const labels = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
  return (
    <div className="lc-chart">
      {bars.map((h, i) => (
        <div className="lc-chart__col" key={i}>
          <div className="lc-chart__bar" style={{ height: h + '%', background: i === 6 ? 'var(--il-blue-500)' : 'var(--il-blue-200)' }}>
            {i === 6 && <span className="lc-chart__tip">96K</span>}
          </div>
          <span className="lc-chart__lab">{labels[i]}</span>
        </div>
      ))}
    </div>
  );
}

function DashboardScreen({ onOpenOrders }) {
  const { StatCard, Card, Badge, Button, IconButton, ProgressBar, Tabs } = window.ILPDesignSystem_7d03df;
  const D = window.LC_DATA;
  const [range, setRange] = React.useState('month');
  return (
    <div className="lc-page">
      <div className="lc-stats">
        {D.stats.map((s) => (
          <StatCard key={s.label} label={s.label} value={s.value} delta={s.delta} trend={s.trend}
                    note={s.note} iconTone={s.tone} icon={<i data-lucide={s.icon}></i>} />
        ))}
      </div>

      <div className="lc-grid-2">
        <Card title="Production throughput" subtitle="Units shipped per month"
              actions={<Tabs variant="pill" value={range} onChange={setRange}
                        tabs={[{value:'day',label:'Day'},{value:'month',label:'Month'},{value:'year',label:'Year'}]} />}>
          <ThroughputChart />
        </Card>

        <Card title="Capacity by division" subtitle="Current load">
          <div className="lc-divisions">
            {D.divisions.map((d) => (
              <ProgressBar key={d.name} label={d.name} value={d.load} showValue tone={d.tone} />
            ))}
          </div>
        </Card>
      </div>

      <div className="lc-grid-2">
        <Card title="Active orders" subtitle="7 in progress" flush
              actions={<Button variant="ghost" size="sm" trailingIcon={<i data-lucide="arrow-right"></i>} onClick={onOpenOrders}>View all</Button>}>
          <table className="lc-table">
            <thead><tr><th>Order</th><th>Client</th><th>Due</th><th>Status</th></tr></thead>
            <tbody>
              {D.orders.slice(0, 5).map((o) => (
                <tr key={o.id}>
                  <td><span className="lc-mono">{o.id}</span></td>
                  <td>{o.client}<small className="lc-sub">{o.division}</small></td>
                  <td>{o.due}</td>
                  <td><Badge color={D.statusColor[o.status]} dot>{o.status}</Badge></td>
                </tr>
              ))}
            </tbody>
          </table>
        </Card>

        <div className="lc-stack">
          <Card title="Monthly goal"
                actions={<IconButton label="More"><i data-lucide="more-horizontal"></i></IconButton>}>
            <div className="lc-goal">
              <div className="lc-goal__ring" style={{ '--p': '74%' }}>
                <div className="lc-goal__inner"><b>74%</b><span>of 3.2M</span></div>
              </div>
              <div className="lc-goal__meta">
                <p className="lc-sub" style={{margin:0}}>2.41M units shipped against a 3.2M monthly target. On pace to close 6 days early.</p>
                <Badge color="success" dot>On track</Badge>
              </div>
            </div>
          </Card>

          <Card title="Recent activity" flush>
            <ul className="lc-feed">
              {D.activity.map((a, i) => (
                <li key={i} className="lc-feed__item">
                  <span className={'lc-feed__dot lc-feed__dot--' + a.tone}></span>
                  <div className="lc-feed__body">
                    <span><b>{a.who}</b> {a.text}</span>
                    <span className="lc-feed__when">{a.when}</span>
                  </div>
                </li>
              ))}
            </ul>
          </Card>
        </div>
      </div>
    </div>
  );
}

window.DashboardScreen = DashboardScreen;
