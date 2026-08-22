import React from 'react';

/** Text input with label, hint/error states and optional inline icons. */
export interface InputProps extends React.InputHTMLAttributes<HTMLInputElement> {
  /** Field label rendered above the control. */
  label?: string;
  /** Helper text below the field. */
  hint?: string;
  /** Error message — turns the field red and overrides the hint. */
  error?: string;
  /** Mark the label with a required asterisk. @default false */
  required?: boolean;
  /** Icon node inside the left edge. */
  leadingIcon?: React.ReactNode;
  /** Icon node inside the right edge. */
  trailingIcon?: React.ReactNode;
}

export function Input(props: InputProps): JSX.Element;
