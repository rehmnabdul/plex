import React from 'react';

/** Checkbox or radio control with label and optional description. */
export interface CheckboxProps extends Omit<React.InputHTMLAttributes<HTMLInputElement>, 'type'> {
  /** Label text beside the control. */
  label?: string;
  /** Secondary description under the label. */
  description?: string;
  /** Render as a radio button instead of a checkbox. @default false */
  radio?: boolean;
  /** Show the indeterminate (mixed) state (checkbox only). @default false */
  indeterminate?: boolean;
}

export function Checkbox(props: CheckboxProps): JSX.Element;
