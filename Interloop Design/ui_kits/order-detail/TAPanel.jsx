// Order detail — right rail: T&A status, milestone tracker, activities.
const { Badge: TABadge, Button: TAButton, Avatar: TAAvatar, ActivityFeed: TAFeed } = window.ILPDesignSystem_7d03df;

const TAIc = (paths) => (p) => (
  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true" {...p}>
    {paths.map((d, i) => <path key={i} d={d} />)}
  </svg>
);
const TAPencil = TAIc(['M4 20h4l10.5-10.5a2.1 2.1 0 0 0-3-3L5 17v3Z']);
const TABoxChecked = TAIc(['M4 4h16v16H4z', 'm8 12.4 2.7 2.7L16.5 9']);
const TABoxEmpty = TAIc(['M4 4h16v16H4z']);
const TAPlug = TAIc(['M9 3v6', 'M15 3v6', 'M6 9h12v3a6 6 0 0 1-12 0V9Z', 'M12 18v3']);

function TADate({ value, state, caption }) {
  const Glyph = state === 'done' || state === 'late' ? TABoxChecked : state === 'integration' ? TAPlug : TABoxEmpty;
  const cls = 'od-date od-date--' + (state === 'done' ? 'done' : state === 'late' ? 'late' : state === 'planned' || state === 'integration' ? 'planned' : 'none');
  return (
    <span className={cls}>
      <Glyph />
      <span>{value || 'Not specified'}{caption && <em>{caption}</em>}</span>
    </span>
  );
}

function TAPanel({ order, milestones, activities }) {
  const [done, setDone] = React.useState(() => new Set(milestones.filter((m) => m.state === 'done' || m.state === 'late').map((m) => m.name)));
  const complete = done.size;
  const required = milestones.filter((m) => m.required).length;

  return (
    <>
      <section className="od-card">
        <header className="od-rail__hd">
          <span className="ttl">Time &amp; action</span>
          <TABadge color="warning" appearance="solid">In progress</TABadge>
        </header>

        <dl className="od-props">
          <div className="od-prop"><dt>Form name</dt><dd>{order.form}</dd></div>
          <div className="od-prop">
            <dt>Brand contact</dt>
            <dd>
              <span className="who"><TAAvatar name={order.contact} size={20} /><span>{order.contact}</span></span>
              <button className="ed" type="button" aria-label="Edit brand contact"><TAPencil /></button>
            </dd>
          </div>
          <div className="od-prop">
            <dt>Planned ship begin</dt>
            <dd>{order.plannedShip}<button className="ed" type="button" aria-label="Edit planned ship date"><TAPencil /></button></dd>
          </div>
          <div className="od-prop">
            <dt>On-time shipment plan</dt>
            <dd><TABadge color="success" dot>On time</TABadge></dd>
          </div>
          <div className="od-prop"><dt>Late reason code</dt><dd><span className="none">Not applicable</span></dd></div>
        </dl>

        <div className="od-ms">
          <div className="od-ms__scroll">
            <table>
              <thead>
                <tr><th style={{ width: '46%' }}>Milestone</th><th>Start date</th><th>End date</th></tr>
              </thead>
              <tbody>
                {milestones.map((m) => {
                  const checked = done.has(m.name);
                  const state = checked ? (m.state === 'late' ? 'late' : 'done') : m.state === 'integration' ? 'integration' : m.state === 'planned' ? 'planned' : 'none';
                  const caption = state === 'planned' ? 'Planned' : state === 'integration' ? 'From integration' : null;
                  return (
                    <tr key={m.name}>
                      <td>
                        <div className="nm">{m.required && <span className="req">* </span>}{m.name}</div>
                      </td>
                      <td><TADate value={m.start} state={m.start ? state : 'none'} /></td>
                      <td>
                        <span
                          role="button" tabIndex={0} style={{ cursor: 'pointer' }}
                          onClick={() => setDone((s) => { const n = new Set(s); n.has(m.name) ? n.delete(m.name) : n.add(m.name); return n; })}
                          onKeyDown={(e) => e.key === 'Enter' && setDone((s) => { const n = new Set(s); n.has(m.name) ? n.delete(m.name) : n.add(m.name); return n; })}
                        >
                          <TADate value={m.end} state={state} caption={m.end && !checked ? caption : null} />
                        </span>
                      </td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
          </div>

          <div className="od-ms__foot">
            <a href="#bulk">Bulk complete on planned date</a>
            <span style={{ marginLeft: 'auto' }}>
              <TAButton size="sm" variant="primary">Complete</TAButton>
            </span>
          </div>
          <div className="od-legend">
            <span className="ok"><i /> On time</span>
            <span className="lt"><i /> Late completion</span>
            <span className="ov"><i /> Overdue</span>
            <span><b style={{ color: 'var(--il-red)' }}>*</b> is required</span>
            <span style={{ marginLeft: 'auto' }}>{complete} of {milestones.length} complete · {required} required</span>
          </div>
        </div>
      </section>

      <section className="od-card">
        <header className="od-rail__hd"><span className="ttl">Activities</span><a href="#all" style={{ fontSize: 'var(--fs-xs)' }}>View all</a></header>
        <div className="od-actbox">
          <TAFeed items={activities} now={new Date('2026-08-02T14:20:00')} dense maxHeight={300} endMessage="" />
        </div>
      </section>
    </>
  );
}

window.TAPanel = TAPanel;
