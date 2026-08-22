import React from 'react';

/** Horizontal progress / completion bar with optional label and value. */
export interface ProgressBarProps extends React.HTMLAttributes<HTMLDivElement> {
  /** Current value. @default 0 */
  value?: number;
  /** Maximum value. @default 100 */
  max?: number;
  /** Label shown above the bar. */
  label?: React.ReactNode;
  /** Show the percentage on the right. @default false */
  showValue?: boolean;
  /** Bar thickness. @default "md" */
  size?: 'sm' | 'md' | 'lg';
  /** Fill color from the brand palette. @default "blue" */
  tone?: 'blue' | 'earth' | 'air' | 'sun' | 'danger';
}

export function ProgressBar(props: ProgressBarProps): JSX.Element;
