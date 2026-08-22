import React from 'react';

/** One plotted series. */
export interface ChartSeries {
  name: string;
  data: number[];
  /** Overrides the palette slot. */
  color?: string;
  /** Per-point colours (donut, pie, hbar). */
  colors?: string[];
  /** Combo charts: how this series is drawn. @default "bar" */
  mark?: 'bar' | 'line';
  /** Combo charts: which value axis it reads. @default "left" */
  axis?: 'left' | 'right';
  /** Dash the line (forecast, plan, prior period). */
  dashed?: boolean;
  /** Heatmap payload — rows × categories. */
  matrix?: number[][];
  /** Scatter: 0–1 per point, scales the mark. */
  sizes?: number[];
}

/** A reference line, or a band when `to` is set. */
export interface ChartReference {
  value: number;
  /** Turns the line into a band spanning value → to. */
  to?: number;
  label?: string;
  color?: string;
}

/** Categorical palette — brand-first, ordered for maximum separation. */
export const CHART_COLORS: string[];
/** Sequential ramp for heatmaps and any continuous encoding. */
export const CHART_RAMP: string[];

/**
 * Analytics chart in the enterprise-BI idiom: round axis scales, restrained
 * grids, reference lines and bands, mark labels, a light tooltip card and a
 * legend that filters. No charting dependency.
 *
 * | Mark | Answers |
 * |---|---|
 * | `line`, `area` | How has this moved over time? |
 * | `bar` | How do these categories compare? (`stacked`, `percentStack`) |
 * | `hbar` | Which are the biggest? (pair with `sort`) |
 * | `combo` | Do these two measures move together? (dual axis) |
 * | `scatter` | Are these two measures related? |
 * | `bullet` | Did we hit the target? |
 * | `heatmap` | Where are the hot spots across two dimensions? |
 * | `trellis` | How does the same measure differ across many groups? |
 * | `donut`, `pie` | What is the composition? |
 * | `radial` | One number against a target. |
 * | `spark` | Micro-trend inside a tile or cell. |
 */
export interface ChartProps extends React.HTMLAttributes<HTMLDivElement> {
  /** @default "line" */
  type?: 'line' | 'area' | 'bar' | 'hbar' | 'combo' | 'scatter' | 'bullet'
    | 'heatmap' | 'trellis' | 'donut' | 'pie' | 'radial' | 'spark';
  series?: ChartSeries[];
  /** X labels (cartesian), slice labels (donut), columns (heatmap). */
  categories?: string[];
  /** Row labels for `heatmap`. */
  rowLabels?: string[];
  /** Panels for `trellis` — one small multiple each. */
  panels?: Array<{ title: string; data: number[]; color?: string }>;
  /** @default 240 */
  height?: number;
  /** @default CHART_COLORS */
  colors?: string[];
  /** @default true */
  showGrid?: boolean;
  /** @default true */
  showAxis?: boolean;
  /** @default false */
  showLegend?: boolean;
  /** Right-hand legends read like a Tableau colour card. @default "bottom" */
  legendPosition?: 'bottom' | 'right';
  /** Heading above a right-hand legend — name the encoded field. */
  legendTitle?: string;
  /** @default true */
  showTooltip?: boolean;
  /** Print the value on each mark. Use on charts with few marks. @default false */
  showLabels?: boolean;
  /** Curve line/area. Off by default — straight segments don't invent data. */
  smooth?: boolean;
  /** @default false */
  stacked?: boolean;
  /** Stack to 100% — composition over time. @default false */
  percentStack?: boolean;
  /** Sort categories by the first series. */
  sort?: 'asc' | 'desc';
  /** Bar corner radius. Enterprise default is near-square. @default 2 */
  barRadius?: number;
  /** Ring thickness for donut/radial. @default 22 */
  thickness?: number;
  /** Target tick count for the value axis. @default 4 */
  tickCount?: number;
  /** Pin the axis bounds instead of deriving round ones. */
  max?: number;
  min?: number;
  /** The plotted value for `radial`. */
  value?: number;
  /** Big number in a donut's centre. */
  centerValue?: React.ReactNode;
  centerLabel?: string;
  /** Caption under a radial gauge's value. */
  label?: string;
  /** Axis titles. Name the measure and its unit. */
  xTitle?: string;
  yTitle?: string;
  y2Title?: string;
  /** Targets, control limits, averages — lines or shaded bands. */
  reference?: ChartReference[];
  /** Formats ticks, tooltips and labels on the left axis. */
  valueFormat?: (value: number) => string;
  /** Formats the right axis of a combo chart. */
  rightFormat?: (value: number) => string;
  /** Force the small-multiple column count. */
  trellisColumns?: number;
}

export function Chart(props: ChartProps): JSX.Element;
