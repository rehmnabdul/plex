import { describe, expect, it, vi } from 'vitest';
import { renderWithProviders, screen, userEvent } from '@/test/utils';
import { Alert, AlertDescription, AlertTitle } from '@/components/ui/alert';
import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { IconButton } from '@/components/ui/icon-button';
import { Input } from '@/components/ui/input';
import { Field } from '@/components/ui/label';
import { Progress } from '@/components/ui/progress';
import { Separator } from '@/components/ui/separator';
import { Skeleton } from '@/components/ui/skeleton';
import { StatCard } from '@/components/ui/stat-card';

describe('Button', () => {
  it('renders its label and fires onClick', async () => {
    const onClick = vi.fn();
    renderWithProviders(<Button onClick={onClick}>Create order</Button>);
    await userEvent.click(screen.getByRole('button', { name: 'Create order' }));
    expect(onClick).toHaveBeenCalledOnce();
  });

  it('disables and marks itself busy while loading', () => {
    renderWithProviders(<Button loading>Saving</Button>);
    const btn = screen.getByRole('button');
    expect(btn).toBeDisabled();
    expect(btn).toHaveAttribute('aria-busy', 'true');
  });

  it('does not fire onClick when disabled', async () => {
    const onClick = vi.fn();
    renderWithProviders(<Button disabled onClick={onClick}>Nope</Button>);
    await userEvent.click(screen.getByRole('button'));
    expect(onClick).not.toHaveBeenCalled();
  });

  it('renders as a child element with asChild', () => {
    renderWithProviders(<Button asChild><a href="/orders">Orders</a></Button>);
    expect(screen.getByRole('link', { name: 'Orders' })).toHaveAttribute('href', '/orders');
  });

  it.each(['default', 'ink', 'secondary', 'outline', 'ghost', 'link', 'destructive'] as const)(
    'renders the %s variant', (variant) => {
      renderWithProviders(<Button variant={variant}>{variant}</Button>);
      expect(screen.getByRole('button', { name: variant })).toBeInTheDocument();
    },
  );
});

describe('Badge', () => {
  it('renders content and an optional status dot', () => {
    const { container } = renderWithProviders(<Badge variant="success" dot>Shipped</Badge>);
    expect(screen.getByText('Shipped')).toBeInTheDocument();
    expect(container.querySelector('.rounded-full.bg-current')).toBeTruthy();
  });
});

describe('Input', () => {
  it('accepts typing', async () => {
    renderWithProviders(<Input aria-label="Client" />);
    const input = screen.getByLabelText('Client');
    await userEvent.type(input, 'Nordstrom');
    expect(input).toHaveValue('Nordstrom');
  });

  it('flags the invalid state for assistive tech', () => {
    renderWithProviders(<Input aria-label="Client" invalid />);
    expect(screen.getByLabelText('Client')).toHaveAttribute('aria-invalid', 'true');
  });

  it('renders a start adornment', () => {
    renderWithProviders(<Input aria-label="Search" startAdornment={<svg data-testid="icon" />} />);
    expect(screen.getByTestId('icon')).toBeInTheDocument();
  });
});

describe('Field', () => {
  it('shows the hint when there is no error', () => {
    renderWithProviders(<Field label="Units" hint="Whole pieces"><Input aria-label="Units" /></Field>);
    expect(screen.getByText('Whole pieces')).toBeInTheDocument();
  });

  it('replaces the hint with the error and announces it', () => {
    renderWithProviders(<Field label="Units" hint="Whole pieces" error="Required"><Input aria-label="Units" /></Field>);
    expect(screen.queryByText('Whole pieces')).not.toBeInTheDocument();
    expect(screen.getByRole('alert')).toHaveTextContent('Required');
  });

  it('marks required fields', () => {
    const { container } = renderWithProviders(<Field label="Client" required><Input aria-label="Client" /></Field>);
    expect(container.querySelector('.text-destructive')).toHaveTextContent('*');
  });
});

describe('Card', () => {
  it('composes header, title and content', () => {
    renderWithProviders(
      <Card><CardHeader><CardTitle>Orders</CardTitle></CardHeader><CardContent>Body</CardContent></Card>,
    );
    expect(screen.getByRole('heading', { name: 'Orders' })).toBeInTheDocument();
    expect(screen.getByText('Body')).toBeInTheDocument();
  });
});

describe('Alert', () => {
  it('renders with the alert role', () => {
    renderWithProviders(<Alert variant="warning"><AlertTitle>Careful</AlertTitle><AlertDescription>Rate climbing</AlertDescription></Alert>);
    expect(screen.getByRole('alert')).toHaveTextContent('Careful');
    expect(screen.getByText('Rate climbing')).toBeInTheDocument();
  });

  it('calls onDismiss', async () => {
    const onDismiss = vi.fn();
    renderWithProviders(<Alert onDismiss={onDismiss}><AlertTitle>Bye</AlertTitle></Alert>);
    await userEvent.click(screen.getByRole('button', { name: 'Dismiss' }));
    expect(onDismiss).toHaveBeenCalledOnce();
  });
});

describe('Progress', () => {
  it('exposes the value on the progressbar role', () => {
    renderWithProviders(<Progress value={64} />);
    expect(screen.getByRole('progressbar')).toHaveAttribute('aria-valuenow', '64');
  });

  it('clamps out-of-range values and renders the readout', () => {
    renderWithProviders(<Progress value={140} label="Cutting" showValue />);
    expect(screen.getByRole('progressbar')).toHaveAttribute('aria-valuenow', '100');
    expect(screen.getByText('100%')).toBeInTheDocument();
  });
});

describe('IconButton', () => {
  it('requires and exposes an accessible name', () => {
    renderWithProviders(<IconButton aria-label="Notifications"><svg /></IconButton>);
    expect(screen.getByRole('button', { name: 'Notifications' })).toBeInTheDocument();
  });

  it('caps the badge at 99+', () => {
    renderWithProviders(<IconButton aria-label="Alerts" badge={150}><svg /></IconButton>);
    expect(screen.getByText('99+')).toBeInTheDocument();
  });
});

describe('StatCard', () => {
  it('renders label, value and delta', () => {
    renderWithProviders(<StatCard label="Open orders" value="1,284" delta="+4.2%" direction="up" hint="vs. last month" />);
    expect(screen.getByText('Open orders')).toBeInTheDocument();
    expect(screen.getByText('1,284')).toBeInTheDocument();
    expect(screen.getByText('+4.2%')).toBeInTheDocument();
  });

  it('treats an upward move as bad when inverted', () => {
    const { container } = renderWithProviders(<StatCard label="Defect rate" value="1.9%" delta="+0.2" direction="up" invert />);
    expect(container.querySelector('.text-danger-ink')).toBeTruthy();
  });
});

describe('Separator & Skeleton', () => {
  it('renders a decorative separator', () => {
    const { container } = renderWithProviders(<Separator />);
    expect(container.firstChild).toHaveAttribute('data-orientation', 'horizontal');
  });

  it('hides the skeleton from assistive tech', () => {
    const { container } = renderWithProviders(<Skeleton className="h-4 w-20" />);
    expect(container.firstChild).toHaveAttribute('aria-hidden', 'true');
  });
});
