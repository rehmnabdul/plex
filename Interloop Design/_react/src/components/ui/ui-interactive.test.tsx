import { describe, expect, it, vi } from 'vitest';
import { renderWithProviders, screen, userEvent, within } from '@/test/utils';
import { UserAvatar, initialsOf, tintFor } from '@/components/ui/avatar';
import { Checkbox, CheckboxField } from '@/components/ui/checkbox';
import { Switch, SwitchField } from '@/components/ui/switch';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';
import {
  DropdownMenu, DropdownMenuContent, DropdownMenuItem, DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu';
import { Popover, PopoverContent, PopoverTrigger } from '@/components/ui/popover';
import { SidebarNav } from '@/components/ui/sidebar-nav';

describe('UserAvatar', () => {
  it('derives two initials from the name', () => {
    expect(initialsOf('Ayesha Khan')).toBe('AK');
    expect(initialsOf('zain')).toBe('Z');
  });

  it('is deterministic about the tint', () => {
    expect(tintFor('Ayesha Khan')).toBe(tintFor('Ayesha Khan'));
  });

  it('renders the presence dot with a label', () => {
    renderWithProviders(<UserAvatar name="Ayesha Khan" status="online" />);
    expect(screen.getByLabelText('online')).toBeInTheDocument();
  });
});

describe('Checkbox', () => {
  it('toggles on click', async () => {
    const onCheckedChange = vi.fn();
    renderWithProviders(<Checkbox aria-label="Select row" onCheckedChange={onCheckedChange} />);
    await userEvent.click(screen.getByRole('checkbox', { name: 'Select row' }));
    expect(onCheckedChange).toHaveBeenCalledWith(true);
  });

  it('supports the indeterminate state', () => {
    renderWithProviders(<Checkbox aria-label="Select all" checked="indeterminate" />);
    expect(screen.getByRole('checkbox')).toHaveAttribute('data-state', 'indeterminate');
  });

  it('links its label to the control', async () => {
    renderWithProviders(<CheckboxField label="Weekly reports" description="Mondays" />);
    await userEvent.click(screen.getByText('Weekly reports'));
    expect(screen.getByRole('checkbox')).toBeChecked();
    expect(screen.getByText('Mondays')).toBeInTheDocument();
  });
});

describe('Switch', () => {
  it('toggles', async () => {
    const onCheckedChange = vi.fn();
    renderWithProviders(<Switch aria-label="Push" onCheckedChange={onCheckedChange} />);
    await userEvent.click(screen.getByRole('switch'));
    expect(onCheckedChange).toHaveBeenCalledWith(true);
  });

  it('renders a labelled field', () => {
    renderWithProviders(<SwitchField label="Rush order" description="Skips the queue" />);
    expect(screen.getByText('Rush order')).toBeInTheDocument();
    expect(screen.getByRole('switch')).toBeInTheDocument();
  });
});

describe('Tabs', () => {
  it('switches panels', async () => {
    renderWithProviders(
      <Tabs defaultValue="a">
        <TabsList>
          <TabsTrigger value="a">Information</TabsTrigger>
          <TabsTrigger value="b" count={6}>Stakeholders</TabsTrigger>
        </TabsList>
        <TabsContent value="a">Panel A</TabsContent>
        <TabsContent value="b">Panel B</TabsContent>
      </Tabs>,
    );
    expect(screen.getByText('Panel A')).toBeInTheDocument();
    await userEvent.click(screen.getByRole('tab', { name: /Stakeholders/ }));
    expect(screen.getByText('Panel B')).toBeInTheDocument();
    expect(screen.getByText('6')).toBeInTheDocument();
  });
});

describe('Select', () => {
  it('shows the placeholder until a value is set', () => {
    renderWithProviders(
      <Select>
        <SelectTrigger aria-label="Division"><SelectValue placeholder="Choose…" /></SelectTrigger>
        <SelectContent><SelectItem value="Denim">Denim</SelectItem></SelectContent>
      </Select>,
    );
    expect(screen.getByLabelText('Division')).toHaveTextContent('Choose…');
  });

  it('renders the selected value', () => {
    renderWithProviders(
      <Select defaultValue="Denim">
        <SelectTrigger aria-label="Division"><SelectValue /></SelectTrigger>
        <SelectContent><SelectItem value="Denim">Denim</SelectItem></SelectContent>
      </Select>,
    );
    expect(screen.getByLabelText('Division')).toHaveTextContent('Denim');
  });
});

describe('DropdownMenu', () => {
  it('opens and fires the selected item', async () => {
    const onSelect = vi.fn();
    renderWithProviders(
      <DropdownMenu>
        <DropdownMenuTrigger>Options</DropdownMenuTrigger>
        <DropdownMenuContent>
          <DropdownMenuItem onSelect={onSelect}>Hide column</DropdownMenuItem>
        </DropdownMenuContent>
      </DropdownMenu>,
    );
    await userEvent.click(screen.getByText('Options'));
    await userEvent.click(await screen.findByText('Hide column'));
    expect(onSelect).toHaveBeenCalled();
  });
});

describe('Popover', () => {
  it('reveals its content on trigger', async () => {
    renderWithProviders(
      <Popover>
        <PopoverTrigger>Open</PopoverTrigger>
        <PopoverContent>Panel body</PopoverContent>
      </Popover>,
    );
    await userEvent.click(screen.getByText('Open'));
    expect(await screen.findByText('Panel body')).toBeInTheDocument();
  });
});

describe('SidebarNav', () => {
  const items = [
    { key: 'ops', label: 'Operations', section: true },
    { key: 'orders', label: 'Orders', badge: 12 },
    { key: 'people', label: 'People', disabled: true },
  ];

  it('marks the active item and reports selection', async () => {
    const onSelect = vi.fn();
    renderWithProviders(<SidebarNav items={items} activeKey="orders" onSelect={onSelect} />);
    const orders = screen.getByRole('button', { name: /Orders/ });
    expect(orders).toHaveAttribute('aria-current', 'page');
    await userEvent.click(orders);
    expect(onSelect).toHaveBeenCalledWith('orders');
  });

  it('renders section headings and badges, and disables items', () => {
    renderWithProviders(<SidebarNav items={items} />);
    const nav = screen.getByRole('navigation');
    expect(within(nav).getByText('Operations')).toBeInTheDocument();
    expect(within(nav).getByText('12')).toBeInTheDocument();
    expect(screen.getByRole('button', { name: 'People' })).toBeDisabled();
  });

  it('hides labels when collapsed', () => {
    renderWithProviders(<SidebarNav items={items} collapsed />);
    expect(screen.queryByText('Orders')).not.toBeInTheDocument();
  });
});
