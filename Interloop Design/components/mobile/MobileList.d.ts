import React from 'react';

export interface MobileListItem {
  id?: string;
  title: string;
  subtitle?: string;
  /** Status pill after the title. */
  status?: string;
  statusTone?: 'info' | 'success' | 'warning' | 'danger';
  /** Left edge stripe — the fastest status read on a scrolling list. */
  stripe?: 'info' | 'success' | 'warning' | 'danger' | 'neutral' | string;
  /** Leading icon tile. */
  icon?: React.ReactNode;
  tone?: 'info' | 'success' | 'warning' | 'danger' | 'neutral';
  /** Any value renders an initials avatar instead of an icon. */
  avatar?: unknown;
  /** Small facts under the subtitle: `{ icon, label }`. */
  meta?: Array<{ icon?: React.ReactNode; label: React.ReactNode }>;
  /** 0–100 progress bar. */
  progress?: number;
  progressColor?: string;
  /** Right-hand figure. */
  value?: React.ReactNode;
  valueLabel?: string;
  /** Node placed before the chevron. */
  trailing?: React.ReactNode;
  /** Show a 26px checkbox instead of the chevron. */
  checkable?: boolean;
  checked?: boolean;
  disabled?: boolean;
  onClick?: (item: MobileListItem) => void;
}

/**
 * Touch list. Rows are 64px by default and 84px in `glove` density — a shop
 * floor operator wearing gloves cannot hit a 44px target reliably.
 */
export interface MobileListProps extends React.HTMLAttributes<HTMLDivElement> {
  items: MobileListItem[];
  /** @default "default" */
  density?: 'compact' | 'default' | 'comfortable' | 'glove';
  /** Inset rounded card instead of edge-to-edge. @default false */
  card?: boolean;
  onItemClick?: (item: MobileListItem, index: number) => void;
  /** Required when items are `checkable`. */
  onToggle?: (item: MobileListItem, index: number) => void;
  /** @default true */
  showChevron?: boolean;
}
export function MobileList(props: MobileListProps): JSX.Element;

/** The task card an operator acts on — one job, its facts, its actions. */
export interface MobileCardProps extends React.HTMLAttributes<HTMLElement> {
  eyebrow?: string;
  title: React.ReactNode;
  subtitle?: React.ReactNode;
  stripe?: 'info' | 'success' | 'warning' | 'danger' | 'neutral' | string;
  status?: string;
  statusTone?: 'info' | 'success' | 'warning' | 'danger';
  /** Fact grid under the header. */
  facts?: Array<{ label: string; value: React.ReactNode }>;
  /** Button row at the foot — `MobileButton` nodes. */
  actions?: React.ReactNode;
}
export function MobileCard(props: MobileCardProps): JSX.Element;
