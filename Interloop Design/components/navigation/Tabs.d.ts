import React from 'react';

export interface TabItem {
  value: string;
  label: React.ReactNode;
  icon?: React.ReactNode;
  /** Count chip after the label. */
  count?: number;
  /** Attention dot — `true` for brand, or a semantic tone. */
  dot?: boolean | 'danger' | 'warning';
  disabled?: boolean;
}

/**
 * Tab strip implementing the WAI-ARIA tabs pattern: roving tabindex,
 * Arrow / Home / End navigation, and automatic or manual activation.
 * Overflowing strips scroll with edge fades and step buttons — they never wrap.
 */
export interface TabsProps extends Omit<React.HTMLAttributes<HTMLDivElement>, 'onChange'> {
  tabs: TabItem[];
  /** Active value (controlled). Omit to run uncontrolled. */
  value?: string;
  onChange?: (value: string) => void;
  /** @default "line" */
  variant?: 'line' | 'pill' | 'enclosed';
  /** @default "md" */
  size?: 'sm' | 'md' | 'lg';
  /** @default "horizontal" */
  orientation?: 'horizontal' | 'vertical';
  /**
   * "automatic" selects on arrow-key focus (right for cheap panels);
   * "manual" waits for Enter or Space (right when switching costs a fetch).
   * @default "automatic"
   */
  activation?: 'automatic' | 'manual';
  /** Scroll instead of wrapping when the strip overflows. @default true */
  scrollable?: boolean;
  /** Shared id root, so `TabPanel` can wire aria-controls / aria-labelledby. */
  idPrefix?: string;
}

export function Tabs(props: TabsProps): JSX.Element;

/** Panel paired with a tab. Pass the same `idPrefix` as its `Tabs`. */
export function TabPanel(props: React.HTMLAttributes<HTMLDivElement> & {
  /** This panel's tab value. */
  value: string;
  /** The strip's current value — the panel renders only when they match. */
  active: string;
  idPrefix: string;
}): JSX.Element | null;
