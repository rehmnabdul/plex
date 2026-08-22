import { describe, expect, it, vi } from 'vitest';
import { renderWithProviders, screen, userEvent } from '@/test/utils';
import { ActivityFeed, type ActivityItem } from '@/components/data/activity-feed';

const NOW = new Date('2026-08-02T14:20:00');
const at = (days: number, hh: number, mm: number) => {
  const d = new Date(NOW);
  d.setDate(d.getDate() - days);
  d.setHours(hh, mm, 0, 0);
  return d.toISOString();
};

const items: ActivityItem[] = [
  { id: '1', type: 'flag', actor: { name: 'Sana Iqbal', role: 'QA Lead' }, action: 'raised a defect on', target: 'ILP-10482', time: at(0, 13, 55), body: 'Bowing on the left selvedge.', tags: ['Skewness'], actions: [{ id: 'capa', label: 'Open CAPA', primary: true }] },
  { id: '2', type: 'status', actor: { name: 'Bilal Raza' }, action: 'moved', target: 'CAPA-338', time: at(0, 12, 10), from: 'Containment', to: 'Root cause', toTone: 'info' },
  { id: '3', type: 'upload', actor: { name: 'Usman Tariq' }, action: 'attached evidence to', target: 'INSP-77219', time: at(1, 9, 5), attachments: [{ name: 'worksheet.pdf', size: '318 KB' }] },
];

describe('ActivityFeed', () => {
  it('groups entries under day headers', () => {
    renderWithProviders(<ActivityFeed items={items} now={NOW} />);
    expect(screen.getByText('Today')).toBeInTheDocument();
    expect(screen.getByText('Yesterday')).toBeInTheDocument();
  });

  it('renders relative timestamps for today', () => {
    renderWithProviders(<ActivityFeed items={items} now={NOW} />);
    expect(screen.getByText('25m ago')).toBeInTheDocument();
    expect(screen.getByText('2h ago')).toBeInTheDocument();
  });

  it('sorts newest first regardless of input order', () => {
    renderWithProviders(<ActivityFeed items={[...items].reverse()} now={NOW} />);
    const articles = screen.getAllByRole('article');
    expect(articles[0]).toHaveTextContent('raised a defect on');
  });

  it('renders payloads: quote, status pills, attachments and tags', () => {
    renderWithProviders(<ActivityFeed items={items} now={NOW} />);
    expect(screen.getByText('Bowing on the left selvedge.')).toBeInTheDocument();
    expect(screen.getByText('Containment')).toBeInTheDocument();
    expect(screen.getByText('Root cause')).toBeInTheDocument();
    expect(screen.getByText('worksheet.pdf')).toBeInTheDocument();
    expect(screen.getByText('Skewness')).toBeInTheDocument();
  });

  it('filters by tab', async () => {
    renderWithProviders(
      <ActivityFeed
        items={items} now={NOW}
        tabs={[{ id: 'all', label: 'All' }, { id: 'files', label: 'Files', types: ['upload'] }]}
      />,
    );
    await userEvent.click(screen.getByRole('tab', { name: 'Files' }));
    expect(screen.getByText('worksheet.pdf')).toBeInTheDocument();
    expect(screen.queryByText('Bowing on the left selvedge.')).not.toBeInTheDocument();
  });

  it('fires item actions', async () => {
    const onItemAction = vi.fn();
    renderWithProviders(<ActivityFeed items={items} now={NOW} onItemAction={onItemAction} />);
    await userEvent.click(screen.getByRole('button', { name: 'Open CAPA' }));
    expect(onItemAction).toHaveBeenCalledWith('capa', expect.objectContaining({ id: '1' }));
  });

  it('loads more when there is more', async () => {
    const onLoadMore = vi.fn();
    renderWithProviders(<ActivityFeed items={items} now={NOW} hasMore onLoadMore={onLoadMore} />);
    await userEvent.click(screen.getByRole('button', { name: 'Load earlier activity' }));
    expect(onLoadMore).toHaveBeenCalledOnce();
  });

  it('shows the empty state', () => {
    renderWithProviders(<ActivityFeed items={[]} now={NOW} emptyTitle="Nothing here yet" />);
    expect(screen.getByText('Nothing here yet')).toBeInTheDocument();
  });

  it('shows skeletons while loading an empty feed', () => {
    const { container } = renderWithProviders(<ActivityFeed items={[]} loading now={NOW} />);
    expect(container.querySelectorAll('.animate-pulse').length).toBeGreaterThan(0);
  });
});
