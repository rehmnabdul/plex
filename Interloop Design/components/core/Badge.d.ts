import React from 'react';

/** Compact status or category label. */
export interface BadgeProps extends React.HTMLAttributes<HTMLSpanElement> {
  /** Semantic tone. The canonical prop across the system. @default "neutral" */
  variant?: 'neutral' | 'info' | 'success' | 'warning' | 'danger';
  /** @deprecated Alias for `variant`, kept for existing call sites. */
  color?: 'neutral' | 'info' | 'success' | 'warning' | 'danger';
  /** Fill style. @default "soft" */
  appearance?: 'soft' | 'solid' | 'outline';
  /** Show a leading status dot. @default false */
  dot?: boolean;
  /** Use a small radius instead of a pill. @default false */
  square?: boolean;
}

export function Badge(props: BadgeProps): JSX.Element;
