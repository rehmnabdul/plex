import React from 'react';

/**
 * Device shell for showing a mobile screen in context. Purely presentational —
 * everything inside is real, scrollable UI.
 */
export interface PhoneFrameProps extends React.HTMLAttributes<HTMLDivElement> {
  /** Screen width in px. @default 390 */
  width?: number;
  /** Screen height in px. @default 844 */
  height?: number;
  /** Status-bar clock. @default "09:41" */
  time?: string;
  carrier?: string;
  /** Dark screen background. @default false */
  dark?: boolean;
  /** Drop the bezel and notch — a plain rounded viewport for docs. @default false */
  flat?: boolean;
  /** @default true */
  showStatusBar?: boolean;
  /** @default true */
  showHome?: boolean;
  /** Battery fill, 0–100. @default 82 */
  battery?: number;
  /** Label under the device. */
  caption?: string;
  captionNote?: string;
  /** Render at a fraction of full size (0.75 fits three phones on a page). */
  scale?: number;
}

export function PhoneFrame(props: PhoneFrameProps): JSX.Element;
