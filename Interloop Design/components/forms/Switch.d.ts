import React from 'react';

/** Toggle switch for instant on/off settings. */
export interface SwitchProps extends Omit<React.InputHTMLAttributes<HTMLInputElement>, 'type' | 'size'> {
  /** Label beside the switch. */
  label?: string;
  /** Size. @default "md" */
  size?: 'sm' | 'md';
}

export function Switch(props: SwitchProps): JSX.Element;
