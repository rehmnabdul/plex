import React from 'react';

/** Vertical app root: app bar, scrolling screen, tab bar. Use outside a PhoneFrame. */
export function MobileShell(props: React.HTMLAttributes<HTMLDivElement>): JSX.Element;

/** Top app bar. Back, title, subtitle, up to two trailing actions. */
export interface MobileAppBarProps extends React.HTMLAttributes<HTMLElement> {
  title: React.ReactNode;
  subtitle?: React.ReactNode;
  /** Renders the back chevron when supplied. */
  onBack?: () => void;
  backLabel?: string;
  /** Trailing `MobileAction` nodes. Two maximum. */
  actions?: React.ReactNode;
  /** @default "default" */
  tone?: 'default' | 'brand' | 'accent';
  /** Centre the title (modal screens). @default false */
  center?: boolean;
}
export function MobileAppBar(props: MobileAppBarProps): JSX.Element;

/** Icon action for the app bar — 44px target, optional count badge. */
export function MobileAction(props: {
  icon: React.ReactNode;
  /** Required: the button has no visible text. */
  label: string;
  badge?: number;
  onClick?: () => void;
}): JSX.Element;

/** Scrolling body between the app bar and the tab bar. */
export function MobileScreen(props: React.HTMLAttributes<HTMLDivElement> & {
  /** 14px inset. Leave off for edge-to-edge lists. @default false */
  padded?: boolean;
}): JSX.Element;

/** All-caps group heading inside a screen. */
export function MobileSectionLabel(props: { children: React.ReactNode }): JSX.Element;

export interface MobileTab {
  key: string;
  label: string;
  icon?: React.ReactNode;
  badge?: number;
}

/** Bottom tab bar. Three to five destinations, optionally with a centre action. */
export interface MobileTabBarProps extends React.HTMLAttributes<HTMLElement> {
  tabs: MobileTab[];
  value?: string;
  onChange?: (key: string) => void;
  /** Icon for the raised centre button — splits the tabs either side. */
  fab?: React.ReactNode;
  onFab?: () => void;
  fabLabel?: string;
}
export function MobileTabBar(props: MobileTabBarProps): JSX.Element;

/** Bottom sheet — the mobile substitute for a dialog. */
export interface MobileSheetProps extends React.HTMLAttributes<HTMLElement> {
  /** @default true */
  open?: boolean;
  title?: string;
  subtitle?: string;
  /** Renders the close button and makes the scrim dismiss. */
  onClose?: () => void;
  /** Action row pinned to the bottom, above the safe area. */
  footer?: React.ReactNode;
  closeLabel?: string;
}
export function MobileSheet(props: MobileSheetProps): JSX.Element;

/** Full-width touch button. 52px standard, 60px (`lg`) for gloved use. */
export interface MobileButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  /** @default "primary" */
  variant?: 'primary' | 'secondary' | 'ghost' | 'danger' | 'success';
  /** @default "md" */
  size?: 'md' | 'lg';
  icon?: React.ReactNode;
}
export function MobileButton(props: MobileButtonProps): JSX.Element;
