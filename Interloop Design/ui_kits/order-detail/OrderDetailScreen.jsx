// Order detail (T&A) — main column: PO information, product grid, stakeholders, production matrix.
const { Tabs: ODTabs, Button: ODButton, Badge: ODBadge, Avatar: ODAvatar, Select: ODSelect, DataGrid: ODGrid } = window.ILPDesignSystem_7d03df;

const ODIc = (paths) => (p) => (
  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true" {...p}>
    {paths.map((d, i) => <path key={i} d={d} />)}
  </svg>
);
const ODChevL = ODIc(['m15 5-7 7 7 7']);
const ODChevR = ODIc(['m9 5 7 7-7 7']);
const ODSheet = ODIc(['M4 3h16v18H4z', 'M4 9h16', 'M10 9v12']);
const ODExpand = ODIc(['M4 9V4h5', 'M20 15v5h-5', 'M4 4l6 6', 'M20 20l-6-6']);

const PO = {
  number: '8757222', opo: null, type: 'Other', commit: '310016',
  line: 'Apparel', category: 'Socks & hosiery',
  inStore: '08 Jan 2027', shipBegin: '20 Oct 2026', shipEnd: '25 Oct 2026',
};

function ODSection({ title, tail, defaultOpen = true, children }) {
  const [open, setOpen] = React.useState(defaultOpen);
  return (
    <section className="od-card od-sec">
      <button type="button" className="od-sec__hd" aria-expanded={open} onClick={() => setOpen(!open)}>
        <ODChevR />{title}{tail && <span className="tail">{tail}</span>}
      </button>
      {open && <div className="od-sec__bd">{children}</div>}
    </section>
  );
}

function ODOrderInfo({ items }) {
  const cols = [
    { key: 'id', header: 'Item ID', width: 120, pinned: 'left' },
    { key: 'department', header: 'Department', width: 180, groupable: true, filter: 'select' },
    { key: 'klass', header: 'Class', width: 180, groupable: true, filter: 'select' },
    { key: 'line', header: 'Product line', width: 120, groupable: true, filter: 'select' },
    { key: 'category', header: 'Product category', width: 160, groupable: true, filter: 'select' },
    { key: 'brand', header: 'Brand', width: 130, groupable: true, filter: 'select' },
    { key: 'style', header: 'Style ID', width: 120 },
    { key: 'color', header: 'Color', width: 150, filter: 'select' },
    { key: 'size', header: 'Size', width: 90, align: 'center', filter: 'select' },
    { key: 'casePack', header: 'Case pack', type: 'number', width: 110 },
    { key: 'qty', header: 'Order quantity', type: 'number', width: 140, aggregate: 'sum', format: (v) => v.toLocaleString('en-US') },
    { key: 'cartons', header: 'Order cartons', type: 'number', width: 130, aggregate: 'sum' },
  ];
  const totalQty = items.reduce((s, i) => s + i.qty, 0);

  return (
    <>
      <ODSection title="Purchase order information" tail={<>PO <b style={{ color: 'var(--text-primary)' }}>{PO.number}</b></>}>
        <dl className="od-facts">
          <div><dt>PO number</dt><dd>{PO.number}</dd></div>
          <div><dt>OPO number</dt><dd className="empty">—</dd></div>
          <div><dt>PO type</dt><dd>{PO.type}</dd></div>
          <div><dt>Commit ID</dt><dd>{PO.commit}</dd></div>
          <div><dt>Product line</dt><dd>{PO.line}</dd></div>
          <div><dt>Product category</dt><dd>{PO.category}</dd></div>
          <div><dt>In-store date</dt><dd>{PO.inStore}</dd></div>
          <div><dt>Ship begin</dt><dd>{PO.shipBegin}</dd></div>
          <div><dt>Ship end</dt><dd>{PO.shipEnd}</dd></div>
        </dl>
      </ODSection>

      <ODSection title="Product information" tail={<>{items.length} item IDs · {totalQty.toLocaleString('en-US')} pcs</>}>
        <div className="od-tools">
          <span className="od-lbl">View by</span>
          <ODSelect options={['Packing', 'Style', 'Colour', 'Size']} defaultValue="Packing" style={{ width: 150 }} />
          <span className="od-lbl">Filter by</span>
          <ODSelect placeholder="Select…" options={['Department', 'Class', 'Brand', 'Colour']} style={{ width: 170 }} />
        </div>
        <ODGrid
          columns={cols}
          rows={items}
          rowKey="id"
          defaultGroupBy={['pack']}
          height={470}
          pageSize={25}
          pageSizeOptions={[10, 25, 50]}
          density="compact"
          showExport
        />
      </ODSection>
    </>
  );
}

function ODStakeholders({ people }) {
  return (
    <ODSection title="Stakeholders" tail={<>{people.length} people</>}>
      <div className="od-people">
        {people.map((p) => (
          <div className="od-person" key={p.email}>
            <ODAvatar name={p.name} size={40} />
            <div className="m">
              <div className="role">{p.role}</div>
              <div className="nm">{p.name}</div>
              <div className="org">{p.org}</div>
              <a className="em" href={'mailto:' + p.email}>{p.email}</a>
            </div>
          </div>
        ))}
      </div>
    </ODSection>
  );
}

function ODPct({ pct }) {
  const cls = 'od-pct' + (pct === 100 ? ' od-pct--done' : pct === 0 ? ' od-pct--zero' : '');
  return <span className={cls}><i><b style={{ width: pct + '%' }} /></i><span>{pct}%</span></span>;
}

function ODProduction({ rows, stages }) {
  const [level, setLevel] = React.useState('item');
  const lead = [
    { key: 'id', label: 'Item ID', w: 132 },
    { key: 'style', label: 'Style ID', w: 118 },
    { key: 'qty', label: 'Order qty', w: 104 },
  ];
  const offsets = [0, 132, 250];
  const totals = stages.map((s) => rows.reduce((sum, r) => sum + r[s.key].qty, 0));
  const totalQty = rows.reduce((s, r) => s + r.qty, 0);

  return (
    <ODSection title="Production status" tail={<>Updated 2 h ago from HMS Oracle</>}>
      <div className="od-tools">
        <div className="od-seg">
          <button type="button" aria-pressed={level === 'item'} onClick={() => setLevel('item')}>Item level</button>
          <button type="button" aria-pressed={level === 'po'} onClick={() => setLevel('po')}>PO level</button>
        </div>
        <span className="sp" />
        <ODButton size="sm" variant="secondary" leadingIcon={<ODExpand />}>View full table</ODButton>
        <ODButton size="sm" variant="secondary" leadingIcon={<ODSheet />}>Excel</ODButton>
        <ODButton size="sm" variant="primary">Update</ODButton>
      </div>

      <div className="od-mx">
        <table>
          <thead>
            <tr>
              {lead.map((c, i) => (
                <th key={c.key} rowSpan={2} className={'lead stick' + (i === lead.length - 1 ? ' stick--edge' : '')} style={{ left: offsets[i], minWidth: c.w }}>{c.label}</th>
              ))}
              {stages.map((s) => <th key={s.key} colSpan={2} className="grp">{s.label}</th>)}
            </tr>
            <tr>
              {stages.map((s) => <React.Fragment key={s.key}><th className="grp">%</th><th>Qty</th></React.Fragment>)}
            </tr>
          </thead>
          <tbody>
            {(level === 'item' ? rows : [{ id: 'PO 8757222', style: '—', qty: totalQty, ...Object.fromEntries(stages.map((s, i) => [s.key, { pct: Math.round(totals[i] / totalQty * 100), qty: totals[i] }])) }]).map((r) => (
              <tr key={r.id}>
                <td className="lead stick" style={{ left: 0 }}>{r.id}</td>
                <td className="lead stick" style={{ left: 132, fontWeight: 'var(--weight-regular)', color: 'var(--text-secondary)' }}>{r.style}</td>
                <td className="stick stick--edge" style={{ left: 250 }}>{r.qty.toLocaleString('en-US')}</td>
                {stages.map((s) => (
                  <React.Fragment key={s.key}>
                    <td className="grp"><ODPct pct={r[s.key].pct} /></td>
                    <td style={{ color: r[s.key].qty ? 'var(--text-primary)' : 'var(--text-disabled)' }}>{r[s.key].qty.toLocaleString('en-US')}</td>
                  </React.Fragment>
                ))}
              </tr>
            ))}
          </tbody>
          <tfoot>
            <tr>
              <td className="lead stick" style={{ left: 0 }}>Total</td>
              <td className="lead stick" style={{ left: 132 }} />
              <td className="stick stick--edge" style={{ left: 250 }}>{totalQty.toLocaleString('en-US')}</td>
              {stages.map((s, i) => (
                <React.Fragment key={s.key}>
                  <td className="grp">{Math.round(totals[i] / totalQty * 100)}%</td>
                  <td>{totals[i].toLocaleString('en-US')}</td>
                </React.Fragment>
              ))}
            </tr>
          </tfoot>
        </table>
      </div>
      <p className="od-mxfoot">Total {level === 'item' ? rows.length + ' items' : '1 purchase order'} · horizontal scroll for later stages</p>
    </ODSection>
  );
}

function OrderDetailScreen() {
  const D = window.OD_DATA;
  const [tab, setTab] = React.useState('info');
  return (
    <>
      <header className="od-head">
        <div className="od-head__in">
          <div className="od-titles">
            <a className="od-back" href="#back"><ODChevL />Back to T&amp;A management</a>
            <h1>34557APPAREL_InterloopLimited</h1>
            <div className="sub">
              <ODBadge color="info" appearance="soft">Apparel</ODBadge>
              <span className="od-dot" /><span>PO <b>8757222</b></span>
              <span className="od-dot" /><span>Target Corporation</span>
              <span className="od-dot" /><span>Ship <b>20–25 Oct 2026</b></span>
              <span className="od-dot" /><span><b>5,184</b> pcs · 10 item IDs</span>
            </div>
          </div>
          <ODButton variant="secondary">Split T&amp;A</ODButton>
          <ODButton variant="primary">Update status</ODButton>
        </div>
      </header>

      <div className="od-body">
        <main>
          <div className="od-card" style={{ padding: '4px 16px 0', marginBottom: 20 }}>
            <ODTabs
              value={tab}
              onChange={setTab}
              tabs={[
                { value: 'info', label: 'Order information' },
                { value: 'people', label: 'Stakeholders', count: D.stakeholders.length },
                { value: 'prod', label: 'Production status' },
              ]}
            />
          </div>
          {tab === 'info' && <ODOrderInfo items={D.items} />}
          {tab === 'people' && <ODStakeholders people={D.stakeholders} />}
          {tab === 'prod' && <ODProduction rows={D.production} stages={D.STAGES} />}
        </main>

        <aside className="od-rail">
          <window.TAPanel
            order={{ form: 'Accessories T&A form', contact: 'Zia Mohyuddin', plannedShip: '20 Oct 2026' }}
            milestones={D.milestones}
            activities={D.activities}
          />
        </aside>
      </div>
    </>
  );
}

window.OrderDetailScreen = OrderDetailScreen;
