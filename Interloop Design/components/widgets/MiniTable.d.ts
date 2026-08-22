import React from 'react';

export interface MiniTableColumn<T = any> {
  /** Field path on the row. Dotted paths supported. */
  key: string;
  header: React.ReactNode;
  align?: 'left' | 'center' | 'right';
  /** Right-aligns with tabular figures. */
  numeric?: boolean;
  width?: string | number;
  muted?: boolean;
  strong?: boolean;
  format?: (value: any, row: T) => React.ReactNode;
  render?: (value: any, row: T) => React.ReactNode;
}

/**
 * Compact read-only table for dashboard widgets — the small sibling of
 * `DataGrid`, with no toolbar, filtering, paging or virtualisation.
 * Reach for `DataGrid` the moment the user needs to slice the data.
 */
export interface MiniTableProps<T = any> extends React.TableHTMLAttributes<HTMLTableElement> {
  columns: MiniTableColumn<T>[];
  rows: T[];
  /** Field name or getter. @default "id" */
  rowKey?: string | ((row: T) => string | number);
  /** Footer row keyed by column key. */
  totals?: Record<string, React.ReactNode> | null;
  /** @default false */
  zebra?: boolean;
  /** Row density. The canonical prop across the system. @default "default" */
  density?: 'default' | 'compact';
  /** @deprecated Alias for `density="compact"`. */
  compact?: boolean;
  /** Transparent header instead of the tinted band. @default false */
  plainHead?: boolean;
  /** @default true */
  hover?: boolean;
  onRowClick?: (row: T) => void;
  emptyMessage?: string;
}

export function MiniTable<T = any>(props: MiniTableProps<T>): JSX.Element;

/** Status pill for a table cell. */
export function TableStatus(props: {
  tone?: 'neutral' | 'info' | 'success' | 'warning' | 'danger';
  children: React.ReactNode;
}): JSX.Element;

/** Name + secondary line, with an avatar or derived initials. */
export function TableIdentity(props: {
  name: string;
  meta?: string;
  avatar?: string;
  showAvatar?: boolean;
}): JSX.Element;

/** Inline progress cell. */
export function TableBar(props: {
  value: number;
  color?: string;
  label?: string;
}): JSX.Element;
