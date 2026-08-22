import { describe, expect, it, vi } from 'vitest';
import { createColumnHelper } from '@tanstack/react-table';
import { renderWithProviders, screen, userEvent, within } from '@/test/utils';
import { DataGrid, type DataGridQuery } from '@/components/data/data-grid';

interface Row { id: string; client: string; division: string; units: number }

const rows: Row[] = [
  { id: 'ILP-1', client: 'Nordstrom', division: 'Denim', units: 300 },
  { id: 'ILP-2', client: 'Uniqlo', division: 'Hosiery', units: 100 },
  { id: 'ILP-3', client: 'Adidas', division: 'Denim', units: 200 },
];

const col = createColumnHelper<Row>();
const columns = [
  col.accessor('id', { header: 'Order', size: 120 }),
  col.accessor('client', { header: 'Client', size: 160 }),
  col.accessor('division', { header: 'Division', size: 130, meta: { groupable: true, filterVariant: 'select', filterOptions: ['Denim', 'Hosiery'] } }),
  col.accessor('units', { header: 'Units', size: 110, meta: { numeric: true, filterVariant: 'number' }, aggregationFn: 'sum' }),
];

const setup = (props: Partial<React.ComponentProps<typeof DataGrid<Row>>> = {}) =>
  renderWithProviders(<DataGrid columns={columns} data={rows} getRowId={(r) => r.id} {...props} />);

describe('DataGrid', () => {
  it('renders headers and rows', () => {
    setup();
    expect(screen.getByRole('columnheader', { name: /Order/ })).toBeInTheDocument();
    expect(screen.getByText('Nordstrom')).toBeInTheDocument();
    expect(screen.getByText('ILP-3')).toBeInTheDocument();
  });

  it('sorts when a header is clicked and reports it via aria-sort', async () => {
    setup();
    const header = screen.getByRole('columnheader', { name: /Client/ });
    expect(header).toHaveAttribute('aria-sort', 'none');
    await userEvent.click(header);
    expect(header).toHaveAttribute('aria-sort', 'ascending');
    await userEvent.click(header);
    expect(header).toHaveAttribute('aria-sort', 'descending');
  });

  it('filters through the column filter row', async () => {
    setup({ showFilterRow: true });
    await userEvent.type(screen.getByLabelText('Filter Client'), 'nord');
    expect(screen.getByText('Nordstrom')).toBeInTheDocument();
    expect(screen.queryByText('Uniqlo')).not.toBeInTheDocument();
  });

  it('supports numeric operators in number filters', async () => {
    setup({ showFilterRow: true });
    await userEvent.type(screen.getByLabelText('Filter Units'), '250');
    expect(screen.queryByText('Uniqlo')).not.toBeInTheDocument();
  });

  it('filters from the toolbar search', async () => {
    setup();
    await userEvent.type(screen.getByLabelText('Search rows'), 'Adidas');
    expect(screen.getByText('Adidas')).toBeInTheDocument();
    expect(screen.queryByText('Nordstrom')).not.toBeInTheDocument();
  });

  it('groups rows and rolls up aggregates', () => {
    setup({ initialGrouping: ['division'] });
    expect(screen.getByText('Denim')).toBeInTheDocument();
    expect(screen.getByText('Hosiery')).toBeInTheDocument();
    // Denim = 300 + 200
    expect(screen.getByText('500')).toBeInTheDocument();
  });

  it('selects rows and reports the ids', async () => {
    const onSelectionChange = vi.fn();
    setup({ selectable: true, onSelectionChange });
    const [firstRowCheckbox] = screen.getAllByRole('checkbox', { name: 'Select row' });
    await userEvent.click(firstRowCheckbox);
    expect(onSelectionChange).toHaveBeenLastCalledWith(['ILP-1']);
  });

  it('hides a column from the Columns menu', async () => {
    setup();
    await userEvent.click(screen.getByRole('button', { name: /Columns/ }));
    await userEvent.click(await screen.findByRole('menuitemcheckbox', { name: 'Client' }));
    expect(screen.queryByText('Nordstrom')).not.toBeInTheDocument();
  });

  it('shows an empty state when nothing matches', async () => {
    setup({ emptyTitle: 'No rows to show' });
    await userEvent.type(screen.getByLabelText('Search rows'), 'zzzz');
    expect(screen.getByText('No rows to show')).toBeInTheDocument();
  });

  it('reports the row range in the footer', () => {
    setup();
    expect(screen.getByText(/1–3/)).toBeInTheDocument();
  });

  it('fires onRowClick with the original row', async () => {
    const onRowClick = vi.fn();
    setup({ onRowClick });
    await userEvent.click(screen.getByText('Uniqlo'));
    expect(onRowClick).toHaveBeenCalledWith(expect.objectContaining({ id: 'ILP-2' }));
  });

  it('emits a server query on mount and marks the footer server-side', async () => {
    const onQueryChange = vi.fn();
    renderWithProviders(
      <DataGrid
        mode="server" columns={columns} data={rows} rowCount={4820}
        getRowId={(r) => r.id} onQueryChange={onQueryChange} pageSize={50}
      />,
    );
    expect(onQueryChange).toHaveBeenCalledWith(
      expect.objectContaining({ page: 1, pageSize: 50, sorting: null, filter: '' }),
    );
    expect(screen.getByText(/server-side/)).toBeInTheDocument();
    expect(screen.getByText(/4,820/)).toBeInTheDocument();
  });

  it('does not filter locally in server mode', async () => {
    renderWithProviders(
      <DataGrid mode="server" columns={columns} data={rows} rowCount={3} getRowId={(r) => r.id} />,
    );
    await userEvent.type(screen.getByLabelText('Search rows'), 'zzzz');
    expect(screen.getByText('Nordstrom')).toBeInTheDocument();
  });

  it('pages forward in client mode', async () => {
    const many = Array.from({ length: 30 }, (_, i) => ({ id: `R-${i}`, client: `C${i}`, division: 'Denim', units: i }));
    renderWithProviders(<DataGrid columns={columns} data={many} getRowId={(r) => r.id} pageSize={10} />);
    expect(screen.getByText(/1–10/)).toBeInTheDocument();
    await userEvent.click(screen.getByRole('button', { name: /Next/i }));
    expect(screen.getByText(/11–20/)).toBeInTheDocument();
  });

  it('toggles density from the toolbar', async () => {
    const { container } = setup();
    await userEvent.click(screen.getByRole('button', { name: 'Toggle row density' }));
    const grid = container.querySelector('[role="grid"]')!;
    expect(within(grid as HTMLElement).getByText('Nordstrom')).toBeInTheDocument();
  });
});
