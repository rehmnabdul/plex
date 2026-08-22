import * as React from 'react';
import * as ProgressPrimitive from '@radix-ui/react-progress';
import { cn } from '@/lib/utils';

const TONES = {
  brand: 'var(--primary)',
  success: 'var(--success)',
  warning: 'var(--warning)',
  danger: 'var(--destructive)',
  ink: 'var(--ink)',
} as const;

export interface ProgressProps
  extends React.ComponentPropsWithoutRef<typeof ProgressPrimitive.Root> {
  tone?: keyof typeof TONES;
  size?: 'sm' | 'default' | 'lg';
  /** Renders the percentage to the right of the track. */
  showValue?: boolean;
  label?: string;
}

const Progress = React.forwardRef<React.ElementRef<typeof ProgressPrimitive.Root>, ProgressProps>(
  ({ className, value = 0, tone = 'brand', size = 'default', showValue, label, ...props }, ref) => {
    const pct = Math.max(0, Math.min(100, value ?? 0));
    const track = (
      <ProgressPrimitive.Root
        ref={ref}
        value={pct}
        className={cn(
          'relative w-full overflow-hidden rounded-full bg-[var(--il-grayblue-100)]',
          size === 'sm' ? 'h-1' : size === 'lg' ? 'h-2.5' : 'h-1.5',
          className,
        )}
        {...props}
      >
        <ProgressPrimitive.Indicator
          className="h-full rounded-full transition-transform duration-500 ease-out"
          style={{ background: TONES[tone], transform: `translateX(-${100 - pct}%)` }}
        />
      </ProgressPrimitive.Root>
    );
    if (!showValue && !label) return track;
    return (
      <div className="flex flex-col gap-1.5">
        {label && (
          <div className="flex items-baseline justify-between text-xs">
            <span className="font-semibold text-foreground">{label}</span>
            {showValue && <span className="font-bold tabular-nums text-muted-foreground">{Math.round(pct)}%</span>}
          </div>
        )}
        <div className="flex items-center gap-2.5">
          {track}
          {showValue && !label && <span className="w-9 text-right text-xs font-bold tabular-nums text-muted-foreground">{Math.round(pct)}%</span>}
        </div>
      </div>
    );
  },
);
Progress.displayName = ProgressPrimitive.Root.displayName;

export { Progress };
