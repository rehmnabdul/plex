import React from 'react';

export interface WizardStep {
  /** Stable key. Falls back to the index. */
  key?: string;
  /** Step name in the rail. */
  title: string;
  /** One line under the title. */
  subtitle?: string;
  /** Adds an "Optional" tag next to the title. */
  optional?: boolean;
}

/**
 * Multi-step form shell. Horizontal rail across the top for 3–5 short steps,
 * vertical rail down the left when the steps need explaining or there are
 * more than five. Step panels are children, one per step.
 *
 * Uncontrolled by default; pass `current` + `onStepChange` to drive it from
 * a form library or the router.
 */
export interface WizardProps extends React.HTMLAttributes<HTMLElement> {
  /** Rail definition, in order. */
  steps: WizardStep[];
  /** @default "horizontal" */
  orientation?: 'horizontal' | 'vertical';
  /** Controlled step index. */
  current?: number;
  /** Uncontrolled starting index. @default 0 */
  defaultStep?: number;
  onStepChange?: (index: number) => void;
  /** Called by the primary button on the last step. */
  onFinish?: () => void;
  /** Indices to mark with the error badge (failed validation). */
  errorSteps?: number[];
  /** Only completed steps are clickable in the rail. @default true */
  linear?: boolean;
  /** @default "Back" */
  backLabel?: string;
  /** @default "Next" */
  nextLabel?: string;
  /** Primary label on the last step. @default "Finish" */
  finishLabel?: string;
  /** Show "Step 2 of 5" in the footer. @default true */
  showCount?: boolean;
  /** Set false to block the primary button while the step is invalid. @default true */
  canAdvance?: boolean;
  /** Extra footer nodes (Skip, Save draft) placed after Back. */
  footerStart?: React.ReactNode;
  /** Fix the height and scroll the panel instead of the page. */
  height?: number | string;
  /** One element per step, or a render function `(step, index) => node`. */
  children: React.ReactNode | ((step: WizardStep, index: number) => React.ReactNode);
}

export function Wizard(props: WizardProps): JSX.Element;

/** Heading block inside a step: title, description and an optional help link. */
export interface WizardStepHeaderProps {
  title: string;
  description?: string;
  /** Link text appended to the description, e.g. "Help page." */
  helpLabel?: string;
  helpHref?: string;
}
export function WizardStepHeader(props: WizardStepHeaderProps): JSX.Element;

/** Large selectable card — the wizard's primary choice control. */
export interface WizardOptionCardProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  selected?: boolean;
  icon?: React.ReactNode;
  title: string;
  description?: string;
  /** Render as another element. @default "button" */
  as?: any;
}
export function WizardOptionCard(props: WizardOptionCardProps): JSX.Element;

/** Layout wrapper for a set of WizardOptionCards. */
export interface WizardOptionsProps {
  /** "grid" flows 2-up; "list" stacks full width. @default "grid" */
  layout?: 'grid' | 'list';
  children: React.ReactNode;
}
export function WizardOptions(props: WizardOptionsProps): JSX.Element;

/** Terminal success panel for the final step. */
export interface WizardDoneProps {
  title: string;
  description?: string;
  children?: React.ReactNode;
}
export function WizardDone(props: WizardDoneProps): JSX.Element;
