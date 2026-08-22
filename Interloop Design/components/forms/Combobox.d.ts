import React from 'react';

export type Option = string | {
  value: string; label: string;
  /** Second line in the menu row. */
  meta?: string;
  disabled?: boolean;
  /** Any extra key can be used as `groupBy`. */
  [k: string]: any;
};

interface FieldBase {
  label?: string;
  placeholder?: string;
  required?: boolean;
  hint?: string;
  /** Replaces the hint and announces via role="alert". */
  error?: string;
  disabled?: boolean;
  className?: string;
}

/**
 * Searchable single-select. Type to filter, arrows to move, Enter to pick,
 * Escape to close. Matched text is highlighted so the filter is explainable.
 * Pass `onSearch` to filter server-side and feed `options` back.
 */
export interface ComboboxProps extends FieldBase {
  options: Option[];
  value?: string | null;
  onChange?: (value: string | null, option: Option | null) => void;
  /** Show the clear button once something is chosen. @default true */
  clearable?: boolean;
  /** Server-side filtering — the component stops filtering locally. */
  onSearch?: (query: string) => void;
  loading?: boolean;
  emptyMessage?: string;
  /** Option key to band the menu by. */
  groupBy?: string;
  renderOption?: (option: Option, query: string) => React.ReactNode;
}
export function Combobox(props: ComboboxProps): JSX.Element;

/** Multi-select with chips in the field and checkboxes in the menu. */
export interface MultiSelectProps extends FieldBase {
  options: Option[];
  value?: string[];
  onChange?: (values: string[]) => void;
  /** Chips shown before collapsing to "+n more". @default 3 */
  maxChips?: number;
  /** Select-all / clear footer. @default true */
  showSelectAll?: boolean;
  emptyMessage?: string;
}
export function MultiSelect(props: MultiSelectProps): JSX.Element;

/**
 * Free-text tags. Enter, comma or Tab commits; pasting a delimited list
 * splits it; Backspace on an empty field removes the last tag.
 */
export interface TagInputProps extends FieldBase {
  value?: string[];
  onChange?: (tags: string[]) => void;
  /** Cap the number of tags; the field disables at the limit. */
  max?: number;
  /** Offered below the field as you type. */
  suggestions?: Option[];
  /** Return true, or a message — invalid tags render in the danger chip. */
  validate?: (tag: string) => true | string;
  /** @default [",", "Enter", "Tab"] */
  separators?: string[];
}
export function TagInput(props: TagInputProps): JSX.Element;
