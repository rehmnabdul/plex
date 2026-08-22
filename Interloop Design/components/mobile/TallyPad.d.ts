import React from 'react';

export interface TallyItem {
  key: string;
  label: string;
  /** Short qualifier shown right-aligned — "Major", "Critical". */
  severity?: string;
}

/**
 * Defect tally pad — the primary data-entry control on the floor. One tile per
 * defect code, 52px +/− targets, the count between them.
 */
export interface TallyPadProps extends React.HTMLAttributes<HTMLDivElement> {
  items: TallyItem[];
  /** Counts keyed by `item.key`. */
  values: Record<string, number>;
  onChange?: (key: string, value: number, all: Record<string, number>) => void;
  /** Counts at or above this turn the tile red. */
  criticalAt?: number;
}
export function TallyPad(props: TallyPadProps): JSX.Element;

/** Numeric stepper with 56px targets — quantities, sample sizes. */
export interface MobileStepperProps extends React.HTMLAttributes<HTMLDivElement> {
  value: number;
  /** @default 0 */
  min?: number;
  max?: number;
  /** @default 1 */
  step?: number;
  onChange?: (value: number) => void;
  /** Accessible name for the field and its buttons. */
  label?: string;
}
export function MobileStepper(props: MobileStepperProps): JSX.Element;

/**
 * Big segmented control for a verdict. Two or three options, never more.
 * `kind` adds the matching icon and semantic colour when selected.
 */
export interface MobileSegmentedProps extends React.HTMLAttributes<HTMLDivElement> {
  options: Array<string | { value: string; label: string; kind?: 'pass' | 'fail' | 'hold' }>;
  value?: string;
  onChange?: (value: string) => void;
}
export function MobileSegmented(props: MobileSegmentedProps): JSX.Element;

/**
 * Persistent sync state. On an offline-first app this is never hidden — the
 * operator must always know whether their work has left the device.
 */
export interface SyncStatusProps extends React.HTMLAttributes<HTMLDivElement> {
  /** @default "synced" */
  state?: 'synced' | 'syncing' | 'offline' | 'error';
  /** Outbox depth, shown on the right. */
  pending?: number;
  /** Overrides the default wording for the state. */
  message?: string;
}
export function SyncStatus(props: SyncStatusProps): JSX.Element;

/** Photo evidence slots. Tap to capture; filled slots show a remove control. */
export interface PhotoCaptureProps extends React.HTMLAttributes<HTMLDivElement> {
  photos?: Array<{ id?: string; src?: string; name?: string }>;
  /** Total slots including filled ones. @default 4 */
  slots?: number;
  onCapture?: () => void;
  onRemove?: (photo: { id?: string; src?: string }, index: number) => void;
  label?: string;
}
export function PhotoCapture(props: PhotoCaptureProps): JSX.Element;
