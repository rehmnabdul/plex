import React from 'react';

/** Square icon-only button for toolbars, table rows and topbar controls. */
export interface IconButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  /** Visual style. @default "ghost" */
  variant?: 'ghost' | 'solid' | 'outline';
  /** Size. @default "md" */
  size?: 'sm' | 'md' | 'lg';
  /** Accessible label (also the tooltip title). */
  label?: string;
}

export function IconButton(props: IconButtonProps): JSX.Element;
