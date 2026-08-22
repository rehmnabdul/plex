// Order detail — mock data for the T&A order screen. Attaches to window for the Babel scripts.
(() => {
  const rnd = (s) => { let x = s * 16807 % 2147483647; return () => (x = x * 16807 % 2147483647) / 2147483647; };
  const r = rnd(23);

  const ITEM_IDS = ['040-13-0001','040-13-0007','040-13-0009','040-13-0010','040-13-0286','040-13-1986','040-13-3568','040-13-3577','040-13-4863','040-13-5120'];
  const QTY = [816, 240, 624, 288, 240, 960, 384, 240, 960, 432];
  const COLORS = ['Multicolored','Charcoal / Ecru','Black','Heather grey','Multicolored','Navy / White','Multicolored','Oatmeal','Black / Red','Multicolored'];
  const SIZES = ['6-12','6-12','6-12','6-12','10-13','6-12','6-12','10-13','6-12','6-12'];

  const items = ITEM_IDS.map((id, i) => ({
    id,
    pack: i < 7 ? 'SOLID' : 'ASSORTED',
    department: '40 — Mens essentials',
    klass: '13 — Performance socks',
    line: 'Apparel',
    category: 'Socks & hosiery',
    brand: 'All in Motion',
    style: 'PID-3G679W',
    color: COLORS[i],
    size: SIZES[i],
    casePack: 24,
    qty: QTY[i],
    cartons: Math.round(QTY[i] / 24),
  }));

  // Production stages — % complete + qty per item.
  const STAGES = [
    { key: 'rm',    label: 'Raw material arrival' },
    { key: 'trims', label: 'Production trims & accessories' },
    { key: 'cut',   label: 'Cutting' },
    { key: 'print', label: 'Cutting printing' },
    { key: 'knit',  label: 'Sewing / knitting / weaving' },
    { key: 'asm',   label: 'Assembly' },
    { key: 'fin',   label: 'Finishing' },
    { key: 'pack',  label: 'Packing' },
  ];
  const PATTERN = [100, 100, 100, 0, 100, 62, 24, 0];
  const production = items.map((it, i) => {
    const row = { id: it.id, style: it.style, qty: it.qty };
    STAGES.forEach((s, si) => {
      let pct = PATTERN[si];
      if (pct > 0 && pct < 100) pct = Math.max(0, Math.min(100, Math.round((pct + (r() * 40 - 20)) / 4) * 4));
      row[s.key] = { pct, qty: Math.round(it.qty * pct / 100) };
    });
    return row;
  });

  // Milestones — state: done | late | planned | integration | none
  const milestones = [
    { name: 'Placement meeting', required: false, start: null, end: null, state: 'none' },
    { name: 'TPR meeting pass', required: false, start: null, end: null, state: 'none' },
    { name: 'Raw material arrival', required: true, start: '2026-05-05', end: '2026-05-10', state: 'done' },
    { name: 'Production trims & accessories', required: true, start: '2026-05-17', end: '2026-05-18', state: 'done' },
    { name: 'Cutting', required: false, start: null, end: null, state: 'none' },
    { name: 'Cutting printing (placement)', required: false, start: null, end: null, state: 'none' },
    { name: 'Sewing / knitting / weaving', required: true, start: '2026-06-01', end: '2026-06-28', state: 'done' },
    { name: 'Assembly', required: true, start: '2026-07-04', end: '2026-07-19', state: 'late' },
    { name: 'Finishing (plating, painting)', required: true, start: '2026-07-24', end: '2026-08-07', state: 'planned' },
    { name: 'DUPRO pass', required: false, start: null, end: null, state: 'none' },
    { name: 'Packing', required: true, start: '2026-08-30', end: '2026-09-01', state: 'planned' },
    { name: 'Top testing pass', required: false, start: null, end: null, state: 'none' },
    { name: 'FRI pass', required: true, start: null, end: '2026-10-19', state: 'planned' },
    { name: 'Shipment booking', required: true, start: null, end: '2026-10-10', state: 'integration' },
    { name: 'Cargo ready date', required: true, start: null, end: null, state: 'integration' },
  ];

  const stakeholders = [
    { role: 'Brand / retailer contact', name: 'Zia Mohyuddin', org: 'Target Corporation', email: 'z.mohyuddin@target.com', tone: 'info' },
    { role: 'Merchandiser', name: 'Bilal Raza', org: 'Interloop — Apparel', email: 'b.raza@interloop.com.pk', tone: 'neutral' },
    { role: 'Quality manager', name: 'Ayesha Khan', org: 'Interloop — Quality', email: 'a.khan@interloop.com.pk', tone: 'neutral' },
    { role: 'Production planner', name: 'Zain Abbas', org: 'Interloop — Plant 4', email: 'z.abbas@interloop.com.pk', tone: 'neutral' },
    { role: 'Vendor QA', name: 'Hina Malik', org: 'Loop Industries (sub-contract)', email: 'h.malik@loopind.pk', tone: 'warning' },
    { role: 'Logistics', name: 'Usman Tariq', org: 'Interloop — Export', email: 'u.tariq@interloop.com.pk', tone: 'neutral' },
  ];

  const t = (d, hh, mm) => { const x = new Date('2026-08-02T14:20:00'); x.setDate(x.getDate() - d); x.setHours(hh, mm, 0, 0); return x; };
  const activities = [
    { id: 'o1', type: 'status', actor: { name: 'Zain Abbas', role: 'Planner' }, action: 'moved milestone', target: 'Assembly', time: t(0, 11, 20), from: 'In progress', to: 'Completed late', toTone: 'warning' },
    { id: 'o2', type: 'comment', actor: { name: 'Zia Mohyuddin', role: 'Target' }, action: 'commented on', target: 'PO 8757222', time: t(0, 9, 5), body: 'Please confirm the revised cargo-ready date before Friday — the DC appointment is already booked.' },
    { id: 'o3', type: 'upload', actor: { name: 'Ayesha Khan' }, action: 'attached the DUPRO worksheet to', target: 'INSP-77219', time: t(1, 16, 40), attachments: [{ name: 'dupro-040-13.pdf', size: '412 KB' }] },
    { id: 'o4', type: 'system', action: 'Production status synced from', target: 'HMS Oracle', time: t(1, 5, 30) },
  ];

  window.OD_DATA = { items, production, STAGES, milestones, stakeholders, activities };
})();
