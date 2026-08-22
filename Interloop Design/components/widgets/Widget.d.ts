import React from 'react';

/**
 * The shell every dashboard widget sits in. Supplies the card, the header
 * (eyebrow / title / subtitle / actions), the padded body and the footer,
 * so charts, lists, stats and tables stay visually interchangeable.
 */
export interface WidgetProps extends React.HTMLAttributes<HTMLElement> {
  title?: React.ReactNode;
  subtitle?: React.ReactNode;
  /** Small all-caps label above the title. */
  eyebrow?: string;
  /** Controls placed at the top right — a range switch, a filter, a link. */
  actions?: React.ReactNode;
  /** Renders the ⋮ button and wires this handler. */
  onMenu?: (event: React.MouseEvent) => void;
  /** Footer strip — totals, "View all", last-updated. */
  footer?: React.ReactNode;
  /** Surface treatment. @default "default" */
  tone?: 'default' | 'brand' | 'accent';
  /** Drop the shadow (for widgets inside another surface). @default false */
  flat?: boolean;
  /** Remove body padding — for tables and full-bleed lists. @default false */
  flush?: boolean;
  /** Hairline under the header. @default false */
  rule?: boolean;
  /** Scroll the body instead of growing. @default false */
  scroll?: boolean;
  /** Fix the widget height (pairs with `scroll`). */
  height?: number | string;
  /** Skeleton lines in place of the body. @default false */
  loading?: boolean;
  /** Empty state in place of the body. @default false */
  empty?: boolean;
  emptyTitle?: string;
  emptyMessage?: string;
}

export function Widget(props: WidgetProps): JSX.Element;
