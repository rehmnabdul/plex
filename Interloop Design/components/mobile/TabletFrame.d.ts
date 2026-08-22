import React from 'react';

/**
 * 11-inch tablet shell — 834×1194 portrait, 1194×834 landscape.
 * Presentation only; never ship it around a real screen.
 */
export interface TabletFrameProps extends React.HTMLAttributes<HTMLDivElement> {
  /** @default "landscape" */
  orientation?: 'landscape' | 'portrait';
  /** Overrides the 11-inch defaults (rugged handhelds, 13-inch). */
  width?: number;
  height?: number;
  time?: string;
  date?: string;
  /** 0–100. @default 76 */
  battery?: number;
  /** Drop the bezel for documentation. @default false */
  flat?: boolean;
  showStatusBar?: boolean;
  showHome?: boolean;
  caption?: string;
  captionNote?: string;
  /** Render at a fraction of full size, reserving the right layout space. */
  scale?: number;
}
export function TabletFrame(props: TabletFrameProps): JSX.Element;

export interface TabletRailItem {
  key: string;
  label: string;
  icon?: React.ReactNode;
  badge?: number;
}

/**
 * Vertical navigation rail. On a tablet the thumbs rest at the sides, not the
 * bottom — a phone tab bar is the wrong instrument here.
 */
export interface TabletRailProps extends React.HTMLAttributes<HTMLElement> {
  items: TabletRailItem[];
  value?: string;
  onChange?: (key: string) => void;
  /** Brand mark at the top. */
  header?: React.ReactNode;
  /** Pinned below the items — the user avatar, sync state. */
  footer?: React.ReactNode;
  /** 216px rail with labels beside icons instead of the 92px stack. @default false */
  wide?: boolean;
}
export function TabletRail(props: TabletRailProps): JSX.Element;

/** Toolbar above a detail pane. */
export interface TabletToolbarProps extends React.HTMLAttributes<HTMLElement> {
  title: React.ReactNode;
  subtitle?: React.ReactNode;
  onBack?: () => void;
  /** Renders the pane control that collapses the master list. */
  onToggleMaster?: () => void;
  actions?: React.ReactNode;
}
export function TabletToolbar(props: TabletToolbarProps): JSX.Element;

/**
 * Master–detail split: the tablet's defining layout. The list stays on screen
 * while a record is worked, so nobody loses their place going back.
 */
export interface SplitViewProps extends React.HTMLAttributes<HTMLDivElement> {
  /** List pane content — usually a `MobileList`. */
  master: React.ReactNode;
  masterTitle?: string;
  masterSubtitle?: string;
  /** Controls in the list-pane header — a filter, a sort. */
  masterActions?: React.ReactNode;
  /** 320–420px reads best at 11 inches. @default 380 */
  masterWidth?: number;
  /** Collapse the list to give the detail full width. @default false */
  masterHidden?: boolean;
  /** Detail pane. Omit to show the empty state. */
  detail?: React.ReactNode;
  emptyTitle?: string;
  emptyMessage?: string;
}
export function SplitView(props: SplitViewProps): JSX.Element;

/** Scrolling body for the detail pane. */
export function SplitDetailBody(props: React.HTMLAttributes<HTMLDivElement> & {
  /** Remove padding for edge-to-edge lists and tables. @default false */
  flush?: boolean;
}): JSX.Element;
