import React from 'react';

export interface GanttTask {
  id: string;
  name: string;
  /** Second line in the task pane — owner, article, work centre. */
  meta?: string;
  /** ISO date or Date. A milestone uses `start` only. */
  start: string | Date;
  end?: string | Date;
  /** 0–100, drawn as a lighter fill inside the bar. */
  progress?: number;
  /** Drives the bar colour. @default "planned" */
  status?: 'done' | 'active' | 'planned' | 'late' | 'risk' | 'blocked';
  /** Diamond marker instead of a bar — a date, not a duration. */
  milestone?: boolean;
  /** Nest under this task; the parent then draws a roll-up bracket. */
  parentId?: string;
  /** Ids this task starts after — drawn as finish-to-start arrows. */
  dependsOn?: string[];
  /** Marks the row and its dependency arrows red. */
  critical?: boolean;
  /** Original plan, drawn as a thin grey bar beneath the actual. */
  baselineStart?: string | Date;
  baselineEnd?: string | Date;
  /** Text inside the bar when it is wide enough. */
  label?: string;
  /** Shown after short bars and in the tooltip. */
  owner?: string;
}

/**
 * Gantt chart — scheduled bars against a time axis, with finish-to-start
 * dependencies, baselines, milestones, roll-up phases, a critical path and a
 * today marker. Built for T&A plans and production schedules.
 */
export interface GanttChartProps extends React.HTMLAttributes<HTMLDivElement> {
  /** Flat list; nesting comes from `parentId`. */
  tasks: GanttTask[];
  /** Initial zoom. @default "week" */
  scale?: 'day' | 'week' | 'month';
  /** Zoom levels offered in the toolbar. Pass one to hide the switch. */
  scales?: Array<'day' | 'week' | 'month'>;
  /** Pin the axis range; otherwise it is derived from the tasks. */
  start?: string | Date;
  end?: string | Date;
  /** Position of the today line. @default new Date() */
  today?: string | Date;
  title?: string;
  subtitle?: string;
  actions?: React.ReactNode;
  /** @default 300 */
  taskPaneWidth?: number;
  /** @default 38 */
  rowHeight?: number;
  /** @default 520 */
  height?: number | string;
  /** @default true */
  showDependencies?: boolean;
  /** @default true */
  showBaseline?: boolean;
  /** @default true */
  showToday?: boolean;
  /** @default true */
  showLegend?: boolean;
  /** @default true */
  showToolbar?: boolean;
  onTaskClick?: (task: GanttTask) => void;
}

export function GanttChart(props: GanttChartProps): JSX.Element;
