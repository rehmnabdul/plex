import React from 'react';

interface DateBase {
  label?: string;
  placeholder?: string;
  required?: boolean;
  hint?: string;
  error?: string;
  disabled?: boolean;
  /** Bounds — days outside are disabled in the calendar. */
  min?: string | Date;
  max?: string | Date;
  /** Reference "today", for the marker and the Today action. */
  today?: Date;
  className?: string;
}

/**
 * Date, date-time or time field with a calendar popover.
 * `mode="time"` uses the native time input and skips the calendar.
 */
export interface DateFieldProps extends DateBase {
  /** ISO string or Date. */
  value?: string | Date | null;
  /** Receives an ISO string (date) or ISO datetime, plus the Date object. */
  onChange?: (value: string | null, date: Date | null) => void;
  /** @default "date" */
  mode?: 'date' | 'datetime' | 'time';
  /** @default true */
  clearable?: boolean;
}
export function DateField(props: DateFieldProps): JSX.Element;

/** Two-month range picker with presets. Click start, then end. */
export interface DateRangeFieldProps extends DateBase {
  value?: { start?: string | null; end?: string | null };
  onChange?: (range: { start: string | null; end: string | null }) => void;
  /** Left-hand shortcuts. Pass [] to hide the column. */
  presets?: Array<{ label: string; days: number }>;
  /** Anchor the popover to the field's right edge. @default "left" */
  align?: 'left' | 'right';
}
export function DateRangeField(props: DateRangeFieldProps): JSX.Element;
