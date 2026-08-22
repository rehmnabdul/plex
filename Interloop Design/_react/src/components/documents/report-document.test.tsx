import { describe, expect, it, vi } from 'vitest';
import { renderWithProviders, screen, userEvent } from '@/test/utils';
import { ReportDocument } from '@/components/documents/report-document';

interface Line { id: number; section: string; desc: string; qty: number; amount: string }

const items: Line[] = [
  { id: 1, section: 'Hosiery', desc: 'Crew sock 200N', qty: 84000, amount: '$180,600.00' },
  { id: 2, section: 'Denim', desc: 'Selvedge denim', qty: 18200, amount: '$115,570.00' },
];

const base = {
  kind: 'Commercial Invoice',
  number: 'ILP-INV-24817',
  status: { label: 'Approved', tone: 'success' as const },
  issuer: { name: 'Interloop Limited', lines: ['Faisalabad, Pakistan'] },
  parties: [{ label: 'Issued to', name: 'Nordstrom Inc.', address: '1617 Sixth Avenue\nSeattle', rows: [{ label: 'PO', value: 'NRD-88' }] }],
  meta: [{ label: 'Issue date', value: '02 Aug 2026' }, { label: 'Due date', value: '01 Sep 2026', hint: 'Net 30' }],
  columns: [
    { key: 'desc', header: 'Description' },
    { key: 'qty', header: 'Quantity', numeric: true, format: (v: number) => v.toLocaleString('en-US') },
    { key: 'amount', header: 'Amount', numeric: true },
  ],
  items,
  summary: [{ label: 'Subtotal', value: '$296,170.00' }],
  total: { label: 'Total due', value: '$296,170.00', note: 'Payable in USD' },
  blocks: [{ title: 'Payment details', rows: [{ label: 'SWIFT', value: 'HABBPKKA' }] }],
  signatures: [{ role: 'Prepared by', name: 'Bilal Raza', date: '02 Aug 2026', mark: 'B. Raza' }],
  footerNote: 'Interloop Limited',
  footerRight: 'Page 1 of 1',
};

describe('ReportDocument', () => {
  it('renders the masthead: kind, number and status stamp', () => {
    renderWithProviders(<ReportDocument<Line> {...base} />);
    expect(screen.getByText('Commercial Invoice')).toBeInTheDocument();
    expect(screen.getByText('ILP-INV-24817')).toBeInTheDocument();
    expect(screen.getByText('Approved')).toBeInTheDocument();
  });

  it('renders meta, parties and their hints', () => {
    renderWithProviders(<ReportDocument<Line> {...base} />);
    expect(screen.getByText('Issue date')).toBeInTheDocument();
    expect(screen.getByText('Net 30')).toBeInTheDocument();
    expect(screen.getByText('Nordstrom Inc.')).toBeInTheDocument();
    expect(screen.getByText('NRD-88')).toBeInTheDocument();
  });

  it('renders line items with formatted values', () => {
    renderWithProviders(<ReportDocument<Line> {...base} />);
    expect(screen.getByText('Crew sock 200N')).toBeInTheDocument();
    expect(screen.getByText('84,000')).toBeInTheDocument();
  });

  it('bands the table when groupBy is set', () => {
    renderWithProviders(<ReportDocument<Line> {...base} groupBy="section" />);
    expect(screen.getByText('Hosiery')).toBeInTheDocument();
    expect(screen.getByText('Denim')).toBeInTheDocument();
  });

  it('renders summary, total, blocks and signatures', () => {
    renderWithProviders(<ReportDocument<Line> {...base} />);
    expect(screen.getByText('Subtotal')).toBeInTheDocument();
    expect(screen.getByText('Total due')).toBeInTheDocument();
    expect(screen.getByText('Payable in USD')).toBeInTheDocument();
    expect(screen.getByText('HABBPKKA')).toBeInTheDocument();
    expect(screen.getByText('B. Raza')).toBeInTheDocument();
    expect(screen.getByText('Prepared by · 02 Aug 2026')).toBeInTheDocument();
  });

  it('calls window.print from the action bar', async () => {
    const print = vi.fn();
    vi.stubGlobal('print', print);
    renderWithProviders(<ReportDocument<Line> {...base} />);
    await userEvent.click(screen.getByRole('button', { name: /Print/ }));
    expect(print).toHaveBeenCalledOnce();
    vi.unstubAllGlobals();
  });

  it('can hide the action bar', () => {
    renderWithProviders(<ReportDocument<Line> {...base} showPrint={false} />);
    expect(screen.queryByRole('button', { name: /Print/ })).not.toBeInTheDocument();
  });
});
