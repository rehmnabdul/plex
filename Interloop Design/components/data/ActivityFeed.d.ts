import React from 'react';

export type ActivityTone = 'neutral' | 'info' | 'success' | 'warning' | 'danger' | 'brand';

/** Built-in event types. Each maps to a rail icon and a tone. */
export type ActivityType =
  | 'comment' | 'mention' | 'upload' | 'approval' | 'rejected'
  | 'status' | 'flag' | 'alert' | 'schedule' | 'system';

export interface ActivityItem {
  /** Stable key. */
  id: string;
  /** Drives the rail icon and default tone. @default "system" */
  type?: ActivityType;
  /** Override the tone the type would pick. */
  tone?: ActivityTone;
  /** Who did it. `src` replaces the icon with their avatar. */
  actor?: { name: string; src?: string; role?: string };
  /** Verb phrase — "commented on", "approved", "uploaded 3 files to". */
  action: string;
  /** The record acted on. Rendered as a link when `targetHref` is set. */
  target?: string;
  targetHref?: string;
  /** ISO string or Date. Drives day grouping and the relative timestamp. */
  time: string | Date;
  /** Comment text / note, shown in a quote block. */
  body?: React.ReactNode;
  /** Before → after pills for a status change. */
  from?: string;
  to?: string;
  fromTone?: ActivityTone;
  toTone?: ActivityTone;
  /** Inline metric readout, e.g. an inspection result. `trend` colours the value. */
  stats?: Array<{ label: string; value: string; trend?: 'up' | 'down' }>;
  /** File chips. Extension drives the chip colour. */
  attachments?: Array<{ name: string; size?: string; href?: string }>;
  /** Small outline chips under the entry. */
  tags?: string[];
  /** Inline buttons; clicks go to `onItemAction`. */
  actions?: Array<{ id: string; label: string; primary?: boolean }>;
}

export interface ActivityFeedTab {
  id: string;
  label: string;
  /** Item types this tab keeps. Omit on the "All" tab. */
  types?: ActivityType[];
  /** Optional count badge. */
  count?: number;
}

/**
 * Date-grouped activity timeline for a record, a person or a whole workspace.
 * Sticky day headers, a connected rail, and per-entry payloads (comments,
 * status changes, files, metrics, actions).
 */
export interface ActivityFeedProps extends Omit<React.HTMLAttributes<HTMLDivElement>, 'title'> {
  /** Events, any order — the feed sorts newest first. */
  items: ActivityItem[];
  /** Heading above the feed. */
  title?: string;
  /** Filter tabs. Uncontrolled unless you pass `activeTab`. */
  tabs?: ActivityFeedTab[];
  /** Controlled tab id — when set, filtering is yours to do. */
  activeTab?: string;
  onTabChange?: (id: string) => void;
  /** Reference time for "2h ago" / "Today". @default new Date() */
  now?: Date;
  /** Group entries under Today / Yesterday / date headers. @default true */
  groupByDay?: boolean;
  /** Row density. The canonical prop across the system. @default "default" */
  density?: 'default' | 'compact';
  /** @deprecated Alias for `density="compact"`. */
  dense?: boolean;
  /** Use actor avatars on the rail when available. @default true */
  showActor?: boolean;
  /** Show the "Load earlier activity" button. @default false */
  hasMore?: boolean;
  /** Skeletons when empty, spinner text on the load-more button. @default false */
  loading?: boolean;
  onLoadMore?: () => void;
  /** Fired with (actionId, item) when an entry button is clicked. */
  onItemAction?: (actionId: string, item: ActivityItem) => void;
  /** Text shown when the log is fully loaded. Pass "" to hide. */
  endMessage?: string;
  emptyTitle?: string;
  emptyMessage?: string;
  /** Fix the height and scroll inside (sticky day headers need this). */
  maxHeight?: number | string;
}

export function ActivityFeed(props: ActivityFeedProps): JSX.Element;
