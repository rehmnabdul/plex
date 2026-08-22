import * as React from 'react';
import { cva, type VariantProps } from 'class-variance-authority';
import { AlertCircle, CheckCircle2, Info, TriangleAlert, X } from 'lucide-react';
import { cn } from '@/lib/utils';

export const alertVariants = cva(
  'relative flex w-full gap-3 rounded-lg border p-4 text-sm [&_svg]:size-[18px] [&_svg]:shrink-0',
  {
    variants: {
      variant: {
        default: 'border-[var(--il-blue-200)] bg-info-soft text-info-ink',
        destructive: 'border-[#f8cfcb] bg-danger-soft text-danger-ink',
        success: 'border-[#dcebb4] bg-success-soft text-success-ink',
        warning: 'border-[#fbdcc7] bg-warning-soft text-warning-ink',
        neutral: 'border-border bg-card text-foreground',
      },
    },
    defaultVariants: { variant: 'default' },
  },
);

const ICONS = {
  default: Info, destructive: AlertCircle, success: CheckCircle2, warning: TriangleAlert, neutral: Info,
} as const;

export interface AlertProps
  extends React.HTMLAttributes<HTMLDivElement>,
    VariantProps<typeof alertVariants> {
  /** Hide the leading status icon. */
  hideIcon?: boolean;
  /** Renders a dismiss button. */
  onDismiss?: () => void;
}

const Alert = React.forwardRef<HTMLDivElement, AlertProps>(
  ({ className, variant = 'default', hideIcon, onDismiss, children, ...props }, ref) => {
    const Icon = ICONS[(variant ?? 'default') as keyof typeof ICONS];
    return (
      <div ref={ref} role="alert" className={cn(alertVariants({ variant }), className)} {...props}>
        {!hideIcon && <Icon aria-hidden className="mt-px" />}
        <div className="min-w-0 flex-1">{children}</div>
        {onDismiss && (
          <button
            type="button" onClick={onDismiss} aria-label="Dismiss"
            className="-m-1 rounded-sm p-1 opacity-60 transition-opacity hover:opacity-100"
          >
            <X className="size-4" />
          </button>
        )}
      </div>
    );
  },
);
Alert.displayName = 'Alert';

const AlertTitle = React.forwardRef<HTMLHeadingElement, React.HTMLAttributes<HTMLHeadingElement>>(
  ({ className, ...props }, ref) => (
    <h5 ref={ref} className={cn('mb-0.5 font-bold leading-snug', className)} {...props} />
  ),
);
AlertTitle.displayName = 'AlertTitle';

const AlertDescription = React.forwardRef<HTMLParagraphElement, React.HTMLAttributes<HTMLParagraphElement>>(
  ({ className, ...props }, ref) => (
    <div ref={ref} className={cn('text-sm leading-relaxed opacity-90', className)} {...props} />
  ),
);
AlertDescription.displayName = 'AlertDescription';

export { Alert, AlertTitle, AlertDescription };
