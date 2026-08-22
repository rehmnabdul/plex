import * as React from 'react';
import { cn } from '@/lib/utils';

export interface LogoProps extends React.HTMLAttributes<HTMLSpanElement> {
  /** Full wordmark or the interlocking-loops insignia alone. @default "wordmark" */
  variant?: 'wordmark' | 'mark';
  /** White artwork for dark surfaces. @default "color" */
  tone?: 'color' | 'white';
  /** Rendered height in px. Clear space of one "E" height is applied as padding. */
  height?: number;
}

const SRC = {
  'wordmark-color': '/brand/interloop-logo.svg',
  'wordmark-white': '/brand/interloop-logo-white.svg',
  'mark-color': '/brand/interloop-mark.svg',
  'mark-white': '/brand/interloop-mark-white.svg',
} as const;

/**
 * Official Interloop artwork. Never re-draw, re-colour or stretch it —
 * the brand manual allows only the supplied colour and white masters.
 */
export function Logo({ variant = 'wordmark', tone = 'color', height = 28, className, ...props }: LogoProps) {
  return (
    <span className={cn('inline-flex items-center', className)} {...props}>
      <img
        src={SRC[`${variant}-${tone}` as keyof typeof SRC]}
        alt="Interloop"
        height={height}
        style={{ height, width: 'auto', display: 'block' }}
      />
    </span>
  );
}
