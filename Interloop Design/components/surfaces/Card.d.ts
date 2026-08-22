import React from 'react';

/** Surface container with optional header, body and footer. */
export interface CardProps extends React.HTMLAttributes<HTMLDivElement> {
  /** Header title. Header renders only if `title` or `actions` is set. */
  title?: React.ReactNode;
  /** Subtitle under the title. */
  subtitle?: React.ReactNode;
  /** Right-aligned header actions (buttons, menu). */
  actions?: React.ReactNode;
  /** Footer content. */
  footer?: React.ReactNode;
  /** Shadow depth. @default "sm" */
  elevation?: 'flat' | 'sm' | 'raised';
  /** Lift on hover. @default false */
  hover?: boolean;
  /** Remove body padding (for tables/media). @default false */
  flush?: boolean;
}

export function Card(props: CardProps): JSX.Element;
