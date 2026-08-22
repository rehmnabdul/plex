import { Logo } from '@/components/brand/logo';
import { ReportDocument } from '@/components/documents/report-document';
import { formatMoney, formatNumber } from '@/lib/utils';

interface Line {
  id: number;
  section: string;
  desc: string;
  note?: string;
  qty: number;
  rate: number;
  amount: number;
}

const lines: Line[] = ([
  { id: 1, section: 'Hosiery — Autumn programme', desc: 'Combed cotton crew sock, 200N', note: 'Style NDS-4471 · Charcoal / Ecru · Pack of 3', qty: 84000, rate: 2.15 },
  { id: 2, section: 'Hosiery — Autumn programme', desc: 'Merino blend hiking sock, cushioned', note: 'Style NDS-4512 · Slate', qty: 26500, rate: 4.8 },
  { id: 3, section: 'Denim — Core replenishment', desc: '12.5 oz selvedge denim, rigid', note: 'Article DN-2208 · 58" · Indigo rope-dyed', qty: 18200, rate: 6.35 },
  { id: 4, section: 'Denim — Core replenishment', desc: 'Garment wash & finishing service', note: 'Stone + enzyme, 3 cycles', qty: 18200, rate: 1.1 },
] as Omit<Line, 'amount'>[]).map((l) => ({ ...l, amount: l.qty * l.rate }));

const subtotal = lines.reduce((s, l) => s + l.amount, 0);
const freight = 6400;
const insurance = 1850;

export function DocumentPage() {
  return (
    <ReportDocument<Line>
      kind="Commercial Invoice"
      number="ILP-INV-24817"
      status={{ label: 'Approved', tone: 'success' }}
      logo={<Logo height={32} />}
      issuer={{
        name: 'Interloop Limited',
        lines: ['7-KM Khurrianwala–Jaranwala Road', 'Faisalabad 37610, Pakistan', 'NTN 1234567-8 · sales@interloop.com.pk'],
      }}
      toolbarTitle="Invoice ILP-INV-24817"
      meta={[
        { label: 'Issue date', value: '02 Aug 2026' },
        { label: 'Due date', value: '01 Sep 2026', hint: 'Net 30 · due in 30 days' },
        { label: 'Sales order', value: 'SO-10482' },
        { label: 'Incoterm', value: 'FOB Karachi' },
        { label: 'Currency', value: 'USD' },
      ]}
      parties={[
        {
          label: 'Issued to', name: 'Nordstrom Inc.',
          address: '1617 Sixth Avenue\nSeattle, WA 98101\nUnited States',
          rows: [{ label: 'Buyer', value: 'K. Whitfield' }, { label: 'PO', value: 'NRD-88-2261' }],
        },
        {
          label: 'Ship to', name: 'Nordstrom DC — Ontario',
          address: '3400 E Airport Drive\nOntario, CA 91761\nUnited States',
          rows: [{ label: 'Vessel', value: 'MSC Kalina / 632W' }, { label: 'ETD', value: '11 Aug 2026' }],
        },
        {
          label: 'Issued by', name: 'Interloop Limited — Export',
          address: 'Plant 4, Faisalabad\nPakistan',
          rows: [{ label: 'Contact', value: 'B. Raza' }, { label: 'STRN', value: '17-00-8801-004-55' }],
        },
      ]}
      columns={[
        { key: 'desc', header: 'Description', width: '46%' },
        { key: 'qty', header: 'Quantity', numeric: true, format: (v) => `${formatNumber(v)} pcs` },
        { key: 'rate', header: 'Unit rate', numeric: true, format: (v) => formatMoney(v) },
        { key: 'amount', header: 'Amount', numeric: true, format: (v) => formatMoney(v) },
      ]}
      items={lines}
      groupBy="section"
      summary={[
        { label: 'Subtotal', value: formatMoney(subtotal) },
        { label: 'Freight (FOB Karachi)', value: formatMoney(freight) },
        { label: 'Marine insurance', value: formatMoney(insurance) },
        { label: 'Sales tax (0% — export)', value: formatMoney(0), rule: true },
      ]}
      total={{ label: 'Total due', value: formatMoney(subtotal + freight + insurance), note: 'Payable in USD by 01 Sep 2026' }}
      notes={[
        { title: 'Terms', body: 'Payment by irrevocable L/C at sight, confirmed through Habib Bank Limited. Title passes on loading. Claims must be raised within 15 days of receipt at the destination DC.' },
        { title: 'Declaration', body: 'We certify this invoice to be true and correct, and that the goods are of Pakistani origin, manufactured under Interloop’s audited social and environmental compliance programme.' },
      ]}
      blocks={[
        { title: 'Payment details', rows: [
          { label: 'Bank', value: 'Habib Bank Limited' }, { label: 'IBAN', value: 'PK36HABB0000123456789012' },
          { label: 'SWIFT', value: 'HABBPKKA' }, { label: 'Terms', value: 'L/C at sight' }] },
        { title: 'Shipment', rows: [
          { label: 'Cartons', value: '1,284' }, { label: 'Gross weight', value: '18,940 kg' },
          { label: 'Container', value: '2 × 40′ HC' }, { label: 'Port of loading', value: 'Karachi (PKKHI)' }] },
        { title: 'Compliance', rows: [
          { label: 'Origin', value: 'Pakistan' }, { label: 'HS code', value: '6115.9500' },
          { label: 'GOTS', value: 'CU-8841-2026' }, { label: 'Audit', value: 'Sedex 4-Pillar, Mar 2026' }] },
      ]}
      signatures={[
        { role: 'Prepared by · Export Finance', name: 'Bilal Raza', date: '02 Aug 2026', mark: 'B. Raza' },
        { role: 'Approved by · Head of Commercial', name: 'Imran Sheikh', date: '02 Aug 2026', mark: 'I. Sheikh' },
        { role: 'Received by · Buyer' },
      ]}
      footerNote={<>Interloop Limited · Registered in Pakistan · <b>interloop.com.pk</b></>}
      footerRight="Page 1 of 1 · ILP-INV-24817"
    />
  );
}
