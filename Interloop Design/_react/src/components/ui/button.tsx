import * as React from 'react';
import { Slot } from '@radix-ui/react-slot';
import { cva, type VariantProps } from 'class-variance-authority';
import { Loader2 } from 'lucide-react';
import { cn } from '@/lib/utils';

export const buttonVariants = cva(
  "inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-md font-bold leading-none transition-[background-color,border-color,box-shadow,transform] duration-[120ms] ease-[cubic-bezier(0.4,0,0.2,1)] active:scale-[0.975] disabled:pointer-events-none disabled:opacity-50 [&_svg]:pointer-events-none [&_svg]:size-4 [&_svg]:shrink-0",
  {
    variants: {
      variant: {
        default: 'bg-primary text-primary-foreground hover:bg-[var(--il-blue-600)] hover:shadow-[var(--shadow-brand)] active:bg-[var(--il-blue-700)]',
        destructive: 'bg-destructive text-destructive-foreground hover:bg-[var(--il-red-600)]',
        outline: 'border border-input bg-card text-foreground hover:bg-muted hover:border-[var(--il-grayblue-300)]',
        secondary: 'bg-secondary text-secondary-foreground hover:bg-[var(--il-grayblue-200)]',
        ghost: 'text-muted-foreground hover:bg-muted hover:text-foreground',
        link: 'text-[var(--il-blue-600)] underline-offset-4 hover:underline hover:text-[var(--il-blue-800)]',
        /** Interloop extension — the corporate Gray Blue action. */
        ink: 'bg-ink text-ink-foreground hover:bg-[var(--il-grayblue-800)]',
      },
      size: {
        default: 'h-10 px-[18px] text-sm',
        sm: 'h-8 px-3 text-xs',
        lg: 'h-12 px-6 text-base',
        icon: 'h-9 w-9 p-0',
      },
    },
    defaultVariants: { variant: 'default', size: 'default' },
  },
);

export interface ButtonProps
  extends React.ButtonHTMLAttributes<HTMLButtonElement>,
    VariantProps<typeof buttonVariants> {
  asChild?: boolean;
  /** Swaps the content for a spinner and disables the button. */
  loading?: boolean;
}

const Button = React.forwardRef<HTMLButtonElement, ButtonProps>(
  ({ className, variant, size, asChild = false, loading = false, children, disabled, ...props }, ref) => {
    const Comp = asChild ? Slot : 'button';
    return (
      <Comp
        ref={ref}
        className={cn(buttonVariants({ variant, size, className }))}
        disabled={disabled || loading}
        aria-busy={loading || undefined}
        {...props}
      >
        {loading ? (
          <>
            <Loader2 className="animate-spin" aria-hidden />
            {children}
          </>
        ) : (
          children
        )}
      </Comp>
    );
  },
);
Button.displayName = 'Button';

export { Button };
