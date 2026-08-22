import React from 'react';

export interface LookupColumn {
  key: string;
  header: string;
  numeric?: boolean;
  width?: string | number;
  render?: (value: any, row: any) => React.ReactNode;
}

/**
 * Lookup field — a read-only display that opens a searchable grid and takes
 * the chosen row back into the field. For picking one record out of thousands,
 * where a dropdown would be useless.
 *
 * Click selects, double-click or Enter confirms, Select commits.
 */
export interface LookupFieldProps {
  /** The chosen row object, or null. */
  value?: any;
  onChange?: (row: any | null) => void;
  columns: LookupColumn[];
  rows: any[];
  /** @default "id" */
  rowKey?: string;
  label?: string;
  placeholder?: string;
  required?: boolean;
  hint?: string;
  error?: string;
  disabled?: boolean;
  /** Row field shown as the field's headline. @default "name" */
  displayKey?: string;
  /** Row field shown as the field's second line. */
  metaKey?: string;
  /** Fields the modal search looks at. Defaults to every column. */
  searchKeys?: string[];
  title?: string;
  subtitle?: string;
  emptyMessage?: string;
  clearable?: boolean;
  className?: string;
}
export function LookupField(props: LookupFieldProps): JSX.Element;

/** Dual-thumb integer range. The thumbs share a track and cannot cross. */
export interface RangeSliderProps {
  value: [number, number];
  onChange?: (value: [number, number]) => void;
  min?: number;
  max?: number;
  step?: number;
  label?: string;
  /** Appended to the readout, e.g. "%" or " pcs". */
  unit?: string;
  /** Full control of the readout. */
  format?: (value: number) => string;
  hint?: string;
  /** Min/max captions under the track. @default true */
  showTicks?: boolean;
  disabled?: boolean;
  className?: string;
}
export function RangeSlider(props: RangeSliderProps): JSX.Element;

/** Primary action plus its alternates — the enterprise "save and…" control. */
export interface SplitButtonProps {
  label: string;
  onClick?: () => void;
  items: Array<{
    key?: string;
    label?: string;
    icon?: React.ReactNode;
    onSelect?: () => void;
    disabled?: boolean;
    danger?: boolean;
    /** Renders a divider instead of an item. */
    separator?: boolean;
  }>;
  /** @default "primary" */
  variant?: 'primary' | 'secondary';
  disabled?: boolean;
  icon?: React.ReactNode;
  className?: string;
}
export function SplitButton(props: SplitButtonProps): JSX.Element;
