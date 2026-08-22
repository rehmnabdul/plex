// Loop Console — mock data (no backend). Attaches to window for the Babel scripts.
window.LC_DATA = {
  user: { name: 'Ayesha Khan', email: 'ayesha.khan@interloop.com.pk', role: 'Operations Lead' },

  stats: [
    { label: 'On-time delivery', value: '96.4%', delta: '+1.8 pts', trend: 'up', note: 'vs last month', icon: 'truck', tone: 'blue' },
    { label: 'Units shipped', value: '2.41 M', delta: '+184 K', trend: 'up', note: 'this month', icon: 'package', tone: 'earth' },
    { label: 'Open orders', value: '328', delta: '-22', trend: 'down', note: 'vs last week', icon: 'clipboard-list', tone: 'air' },
    { label: 'Water recycled', value: '74%', delta: '+3 pts', trend: 'up', note: 'of total use', icon: 'droplets', tone: 'sun' },
  ],

  divisions: [
    { name: 'Hosiery', load: 88, tone: 'blue' },
    { name: 'Denim', load: 72, tone: 'earth' },
    { name: 'Apparel', load: 64, tone: 'air' },
    { name: 'Activewear', load: 49, tone: 'sun' },
  ],

  orders: [
    { id: 'ILP-22481', client: 'Nordström Retail', division: 'Hosiery',    qty: '120,000', due: 'Jun 18', status: 'In production', owner: 'Bilal Aslam' },
    { id: 'ILP-22479', client: 'Aurora Apparel',   division: 'Denim',      qty: '48,500',  due: 'Jun 21', status: 'Cutting',       owner: 'Hina Raza' },
    { id: 'ILP-22476', client: 'Northwind Sports',  division: 'Activewear', qty: '64,200',  due: 'Jun 12', status: 'Overdue',       owner: 'Usman Tariq' },
    { id: 'ILP-22470', client: 'Maple & Co.',       division: 'Apparel',    qty: '31,000',  due: 'Jun 27', status: 'Planned',       owner: 'Sana Javed' },
    { id: 'ILP-22468', client: 'Coastline Brands',  division: 'Hosiery',    qty: '95,400',  due: 'Jun 15', status: 'In production', owner: 'Bilal Aslam' },
    { id: 'ILP-22463', client: 'Vertex Outfitters', division: 'Denim',      qty: '52,800',  due: 'Jul 02', status: 'Shipped',       owner: 'Hina Raza' },
    { id: 'ILP-22459', client: 'Lumen Activewear',  division: 'Activewear', qty: '40,100',  due: 'Jun 30', status: 'Quality check',  owner: 'Usman Tariq' },
  ],

  statusColor: {
    'In production': 'info',
    'Cutting':       'neutral',
    'Overdue':       'danger',
    'Planned':       'neutral',
    'Shipped':       'success',
    'Quality check': 'warning',
  },

  team: [
    { name: 'Bilal Aslam', role: 'Production Supervisor · Hosiery', status: 'online', orders: 4 },
    { name: 'Hina Raza',   role: 'Planner · Denim',                  status: 'busy',   orders: 3 },
    { name: 'Usman Tariq', role: 'Quality Lead · Activewear',        status: 'online', orders: 5 },
    { name: 'Sana Javed',  role: 'Planner · Apparel',                status: 'away',   orders: 2 },
  ],

  activity: [
    { who: 'Hina Raza',   text: 'moved order ILP-22479 to Cutting',           when: '8m ago',  tone: 'info' },
    { who: 'Usman Tariq', text: 'flagged ILP-22476 as Overdue',               when: '40m ago', tone: 'danger' },
    { who: 'System',      text: 'Weekly sustainability report is ready',      when: '2h ago',  tone: 'success' },
    { who: 'Bilal Aslam', text: 'shipped 95,400 units for Coastline Brands',  when: '5h ago',  tone: 'success' },
  ],
};
