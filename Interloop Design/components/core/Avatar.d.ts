import React from 'react';

/** User avatar — image or auto-colored initials with optional presence dot. */
export interface AvatarProps extends React.HTMLAttributes<HTMLSpanElement> {
  /** Image URL. Falls back to initials when absent. */
  src?: string;
  /** Full name — drives initials and the auto background color. */
  name?: string;
  /** Diameter in px. @default 40 */
  size?: number;
  /** Rounded-square instead of circle. @default false */
  square?: boolean;
  /** Presence indicator. */
  status?: 'online' | 'busy' | 'away' | 'offline';
  /** Draw a surface-colored ring (for overlapping stacks). @default false */
  ring?: boolean;
}

export function Avatar(props: AvatarProps): JSX.Element;
