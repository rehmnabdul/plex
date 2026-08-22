// Loop Console — People & settings screen.
function PeopleScreen() {
  const { Card, Badge, Button, IconButton, Avatar, Switch, Alert, ProgressBar } = window.ILPDesignSystem_7d03df;
  const D = window.LC_DATA;
  return (
    <div className="lc-page">
      <Alert variant="info" title="ICARE in practice" onClose={() => {}}>
        Review pending performance check-ins before the end of the quarter. 2 are due this week.
      </Alert>

      <div className="lc-grid-people">
        <div className="lc-stack">
          <Card title="Floor team" subtitle="On shift today"
                actions={<Button variant="secondary" size="sm" leadingIcon={<i data-lucide="user-plus"></i>}>Invite</Button>}>
            <div className="lc-people">
              {D.team.map((m) => (
                <div className="lc-person" key={m.name}>
                  <Avatar name={m.name} size={44} status={m.status} />
                  <div className="lc-person__meta">
                    <span className="lc-person__name">{m.name}</span>
                    <span className="lc-sub">{m.role}</span>
                  </div>
                  <Badge color="neutral" appearance="outline">{m.orders} orders</Badge>
                  <IconButton size="sm" label="Message"><i data-lucide="message-square"></i></IconButton>
                </div>
              ))}
            </div>
          </Card>
        </div>

        <div className="lc-stack">
          <Card title="Notifications">
            <div className="lc-settings">
              <div className="lc-setting"><div><div className="lc-strong">Overdue order alerts</div><span className="lc-sub">Notify owners when an order slips</span></div><Switch defaultChecked /></div>
              <div className="lc-setting"><div><div className="lc-strong">Daily shipment digest</div><span className="lc-sub">7:00 AM summary email</span></div><Switch defaultChecked /></div>
              <div className="lc-setting"><div><div className="lc-strong">Sustainability milestones</div><span className="lc-sub">Water & energy targets</span></div><Switch /></div>
            </div>
          </Card>

          <Card title="Sustainability — this quarter">
            <div className="lc-divisions">
              <ProgressBar label="Water recycled" value={74} showValue tone="air" />
              <ProgressBar label="Renewable energy" value={58} showValue tone="earth" />
              <ProgressBar label="Waste diverted" value={81} showValue tone="sun" />
            </div>
          </Card>
        </div>
      </div>
    </div>
  );
}

window.PeopleScreen = PeopleScreen;
