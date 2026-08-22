import React from 'react';

interface Option { value: string; label: string; }

/** Styled native select with brand chevron. */
export interface SelectProps extends React.SelectHTMLAttributes<HTMLSelectElement> {
  /** Field label. */
  label?: string;
  /** Options as `{value,label}` objects or plain strings. */
  options?: Array<Option | string>;
  /** Disabled first option used as a prompt. */
  placeholder?: string;
}

export function Select(props: SelectProps): JSX.Element;
