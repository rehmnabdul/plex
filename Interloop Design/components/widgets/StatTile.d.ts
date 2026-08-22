import React from 'react';

/**
 * A single KPI: label, big number, optional delta, sparkline or progress bar.
 * Drop several into a `StatGrid` for the classic dashboard strip.
 */
export interface StatTileProps extends React.HTMLAttributes<HTMLDivElement> {
  label: string;
  value: React.ReactNode;
  /** Suffix rendered smaller than the value — "%", "pcs", "hrs". */
  unit?: string;
  /** Caption next to the delta. */
  hint?: string;
  /** Signed change, e.g. "+4.2%". */
  delta?: string;
  /** @default "flat" */
  direction?: 'up' | 'down' | 'flat';
  /** "Up is bad" metrics — defect rate, returns, downtime. @default false */
  invert?: boolean;
  icon?: React.ReactNode;
  /** @default "info" */
  iconTone?: 'info' | 'success' | 'warning' | 'danger';
  /** Surface treatment. @default "default" */
  tone?: 'default' | 'brand' | 'accent';
  /** Accent stripe down the left edge — a semantic name or any CSS colour. */
  stripe?: 'brand' | 'success' | 'warning' | 'danger' | string;
  /** Series for the inline sparkline. */
  spark?: number[];
  sparkColor?: string;
  /** 0–100 — renders a bar across the bottom. */
  progress?: number;
  progressColor?: string;
  /** Give the tile its own card shell (standalone use). @default false */
  card?: boolean;
  /** Makes the tile a button — hover lift, focus ring and a hover arrow. */
  onClick?: (event: React.MouseEvent) => void;
  /** Makes the tile a link. Prefer this over `onClick` when it navigates. */
  href?: string;
  /** Render as another element (e.g. a router `Link`). */
  as?: any;
}

export function StatTile(props: StatTileProps): JSX.Element;

/** Hairline-divided responsive grid of StatTiles. */
export interface StatGridProps extends React.HTMLAttributes<HTMLDivElement> {
  /** Set 0 to supply your own `gridTemplateColumns`. @default 4 */
  columns?: number;
  /** Minimum tile width before wrapping. @default 200 */
  minWidth?: number;
}

export function StatGrid(props: StatGridProps): JSX.Element;

/** Circular percentage — completion, capacity, a score against a target. */
export interface ProgressRingProps extends React.HTMLAttributes<HTMLDivElement> {
  value: number;
  /** @default 100 */
  max?: number;
  /** Diameter in px. @default 132 */
  size?: number;
  /** @default 12 */
  thickness?: number;
  color?: string;
  /** All-caps caption inside the ring. */
  label?: string;
  /** Caption under the ring. */
  caption?: string;
  /** Replaces the derived percentage in the centre. */
  display?: React.ReactNode;
}

export function ProgressRing(props: ProgressRingProps): JSX.Element;
