import * as React from 'react';
import { Slot } from '@radix-ui/react-slot';
import { cva, type VariantProps } from 'class-variance-authority';
import { cn } from '@/lib/utils';

export const iconButtonVariants = cva(
  'inline-flex items-center justify-center rounded-md transition-colors duration-[120ms] disabled:pointer-events-none disabled:opacity-50 [&_svg]:shrink-0',
  {
    variants: {
      variant: {
        default: 'bg-primary text-primary-foreground hover:bg-[var(--il-blue-600)]',
        outline: 'border border-input bg-card text-muted-foreground hover:bg-muted hover:text-foreground',
        ghost: 'text-muted-foreground hover:bg-muted hover:text-foreground',
        destructive: 'bg-destructive text-destructive-foreground hover:bg-[var(--il-red-600)]',
      },
      size: {
        sm: 'size-8 [&_svg]:size-4',
        default: 'size-10 [&_svg]:size-[18px]',
        lg: 'size-12 [&_svg]:size-5',
      },
      shape: { square: '', pill: 'rounded-full' },
    },
    defaultVariants: { variant: 'ghost', size: 'default', shape: 'square' },
  },
);

export interface IconButtonProps
  extends React.ButtonHTMLAttributes<HTMLButtonElement>,
    VariantProps<typeof iconButtonVariants> {
  /** Required — the button has no visible text. */
  'aria-label': string;
  asChild?: boolean;
  /** Small count bubble in the top-right (notifications). */
  badge?: number;
}

const IconButton = React.forwardRef<HTMLButtonElement, IconButtonProps>(
  ({ className, variant, size, shape, asChild, badge, children, ...props }, ref) => {
    const Comp = asChild ? Slot : 'button';
    const button = (
      <Comp ref={ref} className={cn(iconButtonVariants({ variant, size, shape, className }))} {...props}>
        {children}
      </Comp>
    );
    if (badge == null) return button;
    return (
      <span className="relative inline-flex">
        {button}
        <span className="pointer-events-none absolute -right-0.5 -top-0.5 flex h-4 min-w-4 items-center justify-center rounded-full bg-destructive px-1 text-[10px] font-bold text-white">
          {badge > 99 ? '99+' : badge}
        </span>
      </span>
    );
  },
);
IconButton.displayName = 'IconButton';

export { IconButton };
