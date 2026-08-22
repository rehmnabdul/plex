import React from 'react';

export interface SidebarNavItem {
  key: string;
  label: string;
  icon?: React.ReactNode;
  /** Count or short pill on the right. */
  badge?: React.ReactNode;
  badgeTone?: 'danger' | 'soft';
  disabled?: boolean;
  /** Second-level items. Parents disclose; they don't navigate. */
  children?: Array<{ key: string; label: string; badge?: React.ReactNode; badgeTone?: 'danger' | 'soft'; disabled?: boolean }>;
}

export interface SidebarNavSection {
  /** All-caps group heading. Omit for an unlabelled group. */
  title?: string;
  /** Draw a divider above this section. */
  rule?: boolean;
  items: SidebarNavItem[];
}

/**
 * App sidebar. Grouped, optionally nested navigation with a collapsible rail,
 * flyout submenus when collapsed, and an optional filter for long menus.
 *
 * The group containing `activeKey` opens automatically — the user's current
 * location is never hidden inside a closed parent.
 */
export interface SidebarNavProps extends React.HTMLAttributes<HTMLElement> {
  sections: SidebarNavSection[];
  /** Key of the current route — matches an item or a child. */
  activeKey?: string;
  onSelect?: (key: string) => void;
  /** Replaces the default Logo lockup. Pass `null` for no brand block. */
  header?: React.ReactNode;
  /** Pinned below the scroll area — the user block, a version string. */
  footer?: React.ReactNode;
  /** Icon rail at 76px. Parents open a flyout on hover. @default false */
  collapsed?: boolean;
  /** Renders the collapse control in the brand row when supplied. */
  onToggleCollapse?: () => void;
  /** "brand" is the Gray Blue panel; "light" is a white sidebar. @default "brand" */
  tone?: 'brand' | 'light';
  /** Filter field above the menu. Worth it past ~12 destinations. @default false */
  filterable?: boolean;
  filterPlaceholder?: string;
  /** Parent keys expanded on mount. */
  defaultOpenKeys?: string[];
}

export function SidebarNav(props: SidebarNavProps): JSX.Element;
