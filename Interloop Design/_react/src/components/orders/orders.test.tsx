import { describe, expect, it } from 'vitest';
import { renderWithProviders, screen, userEvent } from '@/test/utils';
import { CollapsibleSection, FactGrid } from '@/components/orders/collapsible-section';
import { ProductionMatrix } from '@/components/orders/production-matrix';
import { TAPanel } from '@/components/orders/ta-panel';
import { NewOrderForm } from '@/components/orders/new-order-form';
import { Logo } from '@/components/brand/logo';
import { MILESTONES, PRODUCTION, STAGES, ACTIVITIES } from '@/lib/api/mock-data';

describe('Logo', () => {
  it('uses the official colour master by default', () => {
    renderWithProviders(<Logo />);
    expect(screen.getByAltText('Interloop')).toHaveAttribute('src', '/brand/interloop-logo.svg');
  });

  it('switches to the white mark on dark surfaces', () => {
    renderWithProviders(<Logo variant="mark" tone="white" />);
    expect(screen.getByAltText('Interloop')).toHaveAttribute('src', '/brand/interloop-mark-white.svg');
  });
});

describe('CollapsibleSection', () => {
  it('collapses and expands', async () => {
    renderWithProviders(<CollapsibleSection title="Product information">Body</CollapsibleSection>);
    expect(screen.getByText('Body')).toBeInTheDocument();
    await userEvent.click(screen.getByRole('button', { name: /Product information/ }));
    expect(screen.queryByText('Body')).not.toBeInTheDocument();
  });

  it('renders an em dash for empty facts', () => {
    renderWithProviders(<FactGrid facts={[{ label: 'OPO number' }, { label: 'PO type', value: 'Other' }]} />);
    expect(screen.getByText('—')).toBeInTheDocument();
    expect(screen.getByText('Other')).toBeInTheDocument();
  });
});

describe('ProductionMatrix', () => {
  it('renders a stage header pair per stage plus the lead columns', () => {
    renderWithProviders(<ProductionMatrix rows={PRODUCTION} stages={STAGES} />);
    expect(screen.getByText('Raw material arrival')).toBeInTheDocument();
    expect(screen.getAllByText('%')).toHaveLength(STAGES.length);
    expect(screen.getByText('Item ID')).toBeInTheDocument();
  });

  it('totals the order quantity', () => {
    renderWithProviders(<ProductionMatrix rows={PRODUCTION} stages={STAGES} />);
    const total = PRODUCTION.reduce((s, r) => s + r.qty, 0);
    expect(screen.getAllByText(total.toLocaleString('en-US')).length).toBeGreaterThan(0);
  });

  it('rolls up to a single row at PO level', async () => {
    renderWithProviders(<ProductionMatrix rows={PRODUCTION} stages={STAGES} />);
    await userEvent.click(screen.getByRole('button', { name: 'PO level' }));
    expect(screen.getByText('PO 8757222')).toBeInTheDocument();
    expect(screen.getByText(/1 purchase order/)).toBeInTheDocument();
  });
});

describe('TAPanel', () => {
  const order = { form: 'Accessories T&A form', contact: 'Zia Mohyuddin', plannedShip: '2026-10-20' };

  it('renders the form facts and milestone table', () => {
    renderWithProviders(<TAPanel order={order} milestones={MILESTONES} activities={ACTIVITIES} now={new Date('2026-08-02T14:20:00')} />);
    expect(screen.getByText('Accessories T&A form')).toBeInTheDocument();
    expect(screen.getByText('20 Oct 2026')).toBeInTheDocument();
    expect(screen.getByText('Milestone')).toBeInTheDocument();
    expect(screen.getByText('Cargo ready date')).toBeInTheDocument();
  });

  it('counts completed milestones and updates when one is toggled', async () => {
    renderWithProviders(<TAPanel order={order} milestones={MILESTONES} activities={ACTIVITIES} now={new Date('2026-08-02T14:20:00')} />);
    const completed = MILESTONES.filter((m) => m.state === 'done' || m.state === 'late').length;
    expect(screen.getByText(`${completed} of ${MILESTONES.length} complete`)).toBeInTheDocument();
    await userEvent.click(screen.getByRole('button', { name: 'Toggle Packing' }));
    expect(screen.getByText(`${completed + 1} of ${MILESTONES.length} complete`)).toBeInTheDocument();
  });
});

describe('NewOrderForm', () => {
  it('blocks submission and surfaces Zod messages', async () => {
    renderWithProviders(<NewOrderForm />);
    await userEvent.clear(screen.getByLabelText(/Client/));
    await userEvent.click(screen.getByRole('button', { name: 'Create order' }));
    expect(await screen.findByText('Client name is required')).toBeInTheDocument();
    expect(await screen.findByText('Pick a division')).toBeInTheDocument();
  });

  it('rejects non-positive unit counts', async () => {
    renderWithProviders(<NewOrderForm />);
    const units = screen.getByLabelText(/Units/);
    await userEvent.clear(units);
    await userEvent.type(units, '0');
    await userEvent.click(screen.getByRole('button', { name: 'Create order' }));
    expect(await screen.findByText('Units must be greater than zero')).toBeInTheDocument();
  });

  it('resets the form', async () => {
    renderWithProviders(<NewOrderForm />);
    const client = screen.getByLabelText(/Client/);
    await userEvent.type(client, 'Nordstrom');
    await userEvent.click(screen.getByRole('button', { name: 'Reset' }));
    expect(client).toHaveValue('');
  });
});
