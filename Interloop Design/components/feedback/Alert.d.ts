import React from 'react';

/** Inline contextual message banner. */
export interface AlertProps extends React.HTMLAttributes<HTMLDivElement> {
  /** Semantic style + icon. @default "info" */
  variant?: 'info' | 'success' | 'warning' | 'danger';
  /** Bold title line. */
  title?: React.ReactNode;
  /** Show a dismiss button wired to this handler. */
  onClose?: () => void;
}

export function Alert(props: AlertProps): JSX.Element;
