import React from 'react';

/**
 * Primary action button.
 *
 * @startingPoint section="Core" subtitle="Brand button — variants, sizes, icons, loading" viewport="700x160"
 */
export interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  /** Visual style. @default "primary" */
  variant?: 'primary' | 'ink' | 'secondary' | 'ghost' | 'danger';
  /** Size. @default "md" */
  size?: 'sm' | 'md' | 'lg';
  /** Stretch to full container width. @default false */
  block?: boolean;
  /** Show a spinner and disable. @default false */
  loading?: boolean;
  /** Icon node rendered before the label. */
  leadingIcon?: React.ReactNode;
  /** Icon node rendered after the label. */
  trailingIcon?: React.ReactNode;
  /** Render as another element/component (e.g. "a"). @default "button" */
  as?: any;
}

export function Button(props: ButtonProps): JSX.Element;
