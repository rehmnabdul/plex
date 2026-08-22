import React from 'react';

/**
 * KPI tile with label, value, trend delta and an accent icon.
 *
 * @startingPoint section="Core" subtitle="Dashboard KPI / metric tile" viewport="700x150"
 */
export interface StatCardProps extends React.HTMLAttributes<HTMLDivElement> {
  /** Metric name. */
  label: React.ReactNode;
  /** The big value (already formatted, e.g. "$2,940.00"). */
  value: React.ReactNode;
  /** Change indicator text, e.g. "+$1,210.50". */
  delta?: React.ReactNode;
  /** Direction of the delta. @default "up" */
  trend?: 'up' | 'down';
  /** Muted note shown after the delta (e.g. "vs last month"). */
  note?: React.ReactNode;
  /** Accent icon node (Lucide). */
  icon?: React.ReactNode;
  /** Icon tile color from the brand palette. @default "blue" */
  iconTone?: 'blue' | 'earth' | 'air' | 'sun' | 'ink';
}

export function StatCard(props: StatCardProps): JSX.Element;
