import React from 'react';

export interface DataListItem {
  id?: string;
  /** Primary line. */
  title: string;
  /** Secondary line. */
  subtitle?: string;
  /** Right-hand primary figure. */
  value?: React.ReactNode;
  /** Right-hand caption under the value. */
  meta?: string;
  /** Signed change, e.g. "+12.4%". Direction is inferred from the sign. */
  delta?: string;
  direction?: 'up' | 'down' | 'flat';
  /** 0–100 — renders a bar under the subtitle. */
  progress?: number;
  /** Bar / swatch colour. */
  color?: string;
  /** Leading icon (variant "icon"). */
  icon?: React.ReactNode;
  /** Icon tint (variant "icon"). */
  tone?: 'info' | 'success' | 'warning' | 'danger' | 'neutral';
  /** Avatar URL (variant "people"); initials are derived otherwise. */
  avatar?: string;
  /** Small chip after the title. */
  tag?: string;
  tagTone?: 'info' | 'success' | 'warning' | 'danger';
  /** Checked state (variant "check"). */
  done?: boolean;
}

/**
 * The list widget family. One row model; the `variant` picks the leading
 * treatment — nothing, a rank chip, an avatar, an icon tile, a colour swatch,
 * or a checkbox.
 */
export interface DataListProps extends React.HTMLAttributes<HTMLDivElement> {
  items: DataListItem[];
  /** @default "plain" */
  variant?: 'plain' | 'ranked' | 'people' | 'icon' | 'swatch' | 'check';
  /** Hairlines between rows. @default true */
  divided?: boolean;
  /** Row density. The canonical prop across the system. @default "default" */
  density?: 'default' | 'compact';
  /** @deprecated Alias for `density="compact"`. */
  compact?: boolean;
  /** Pad rows to the widget edge — pair with `Widget flush`. @default false */
  inset?: boolean;
  onItemClick?: (item: DataListItem, index: number) => void;
  /** Required by variant "check". */
  onToggle?: (item: DataListItem, index: number) => void;
}

export function DataList(props: DataListProps): JSX.Element;
