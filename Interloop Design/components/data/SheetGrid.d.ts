import React from 'react';

/** Cell data type — drives the display format, alignment and the editor. */
export type SheetCellType =
  | 'text' | 'number' | 'currency' | 'percent'
  | 'date' | 'datetime' | 'time'
  | 'select' | 'checkbox';

export interface SheetColumn<T = any> {
  /** Field on the row. */
  key: string;
  header: string;
  /** @default "text" */
  type?: SheetCellType;
  /** Start width in px. @default 150 */
  width?: number;
  /** Floor for drag-resize. @default 72 */
  minWidth?: number;
  /** Set false to lock the width. @default true */
  resizable?: boolean;
  /** Cell cannot be edited, pasted into or filled. */
  readOnly?: boolean;
  /** Flags empty cells and marks the header with an asterisk. */
  required?: boolean;
  /** Options for `type: "select"` — strings or `{ value, label }`. */
  options?: Array<string | { value: string; label: string }>;
  /** Pill tint per select value, e.g. `{ Shipped: 'success' }`. */
  tones?: Record<string, 'info' | 'success' | 'warning' | 'danger'>;
  /** Bounds for numeric types; violations flag the cell. */
  min?: number;
  max?: number;
  /** Step for the numeric editor. Currency defaults to 0.01. */
  step?: string | number;
  /** Override the display string (not the editor). */
  format?: (value: any) => string;
  /** Full control of the display cell. */
  render?: (value: any, row: T) => React.ReactNode;
  /** Return `true` or an error string. Errors flag the cell and the status bar. */
  validate?: (value: any, row: T) => true | string;
}

/** Describes what changed, passed as the second argument to `onChange`. */
export interface SheetChange {
  row?: number;
  column?: string;
  value?: any;
  paste?: boolean;
  filled?: boolean;
  cleared?: boolean;
  added?: boolean;
  deleted?: number;
  undo?: boolean;
  redo?: boolean;
}

/**
 * Spreadsheet-style editable grid — the data-entry counterpart to `DataGrid`.
 *
 * Keyboard: arrows move, Shift+arrows extend the range, Tab moves right,
 * Enter or F2 or any printable key starts editing, Escape cancels,
 * Delete clears the range, Ctrl+C copies TSV, Ctrl+V pastes a block,
 * Ctrl+A selects all, Ctrl+Z / Ctrl+Shift+Z undo and redo.
 * Mouse: click selects, Shift+click extends, double-click edits, and the
 * handle at the range's bottom-right fills downward.
 */
export interface SheetGridProps extends React.HTMLAttributes<HTMLDivElement> {
  columns: SheetColumn[];
  /** The sheet's rows. Treated as the source of truth — echo `onChange` back. */
  rows: any[];
  /** Fires with the whole next dataset plus a description of the edit. */
  onChange?: (rows: any[], change: SheetChange) => void;
  /** Row identity. @default "id" */
  rowKey?: string;
  /** Freeze this many leading columns. @default 0 */
  freeze?: number;
  /** @default 520 */
  height?: number | string;
  /** @default 34 */
  rowHeight?: number;
  title?: string;
  /** @default true */
  showToolbar?: boolean;
  /** Numbered gutter down the left. @default true */
  showRowHeaders?: boolean;
  /** Spreadsheet letters (A, B, C…) in the header. @default false */
  showColumnLetters?: boolean;
  /** Row/column counts, selection sum and average, error count. @default true */
  showStatusBar?: boolean;
  /** @default false */
  allowAddRows?: boolean;
  /** @default false */
  allowDeleteRows?: boolean;
  /** Builds the blank row for "Add row". */
  newRow?: (index: number) => Record<string, any>;
  /** Sticky footer row, keyed by column key. */
  totals?: Record<string, 'sum' | 'avg' | 'count' | ((rows: any[]) => React.ReactNode)> | null;
  /** Lock the whole sheet. @default false */
  readOnly?: boolean;
}

export function SheetGrid(props: SheetGridProps): JSX.Element;
