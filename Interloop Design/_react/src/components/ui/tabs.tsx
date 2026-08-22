import * as React from 'react';
import * as TabsPrimitive from '@radix-ui/react-tabs';
import { cn } from '@/lib/utils';

const Tabs = TabsPrimitive.Root;

const TabsList = React.forwardRef<
  React.ElementRef<typeof TabsPrimitive.List>,
  React.ComponentPropsWithoutRef<typeof TabsPrimitive.List> & { variant?: 'line' | 'pill' }
>(({ className, variant = 'line', ...props }, ref) => (
  <TabsPrimitive.List
    ref={ref}
    data-variant={variant}
    className={cn(
      'inline-flex items-center',
      variant === 'line' ? 'gap-6 border-b border-[var(--il-grayblue-100)]' : 'gap-0.5 rounded-full bg-secondary p-[3px]',
      className,
    )}
    {...props}
  />
));
TabsList.displayName = TabsPrimitive.List.displayName;

const TabsTrigger = React.forwardRef<
  React.ElementRef<typeof TabsPrimitive.Trigger>,
  React.ComponentPropsWithoutRef<typeof TabsPrimitive.Trigger> & { count?: number }
>(({ className, children, count, ...props }, ref) => (
  <TabsPrimitive.Trigger
    ref={ref}
    className={cn(
      'group inline-flex items-center gap-2 whitespace-nowrap text-sm font-semibold text-muted-foreground transition-colors duration-[120ms] disabled:pointer-events-none disabled:opacity-50',
      'hover:text-foreground data-[state=active]:text-foreground',
      // line variant
      '[&:where([data-variant=line]_*)]:h-11',
      'relative pb-3 pt-3 data-[state=active]:after:absolute data-[state=active]:after:inset-x-0 data-[state=active]:after:-bottom-px data-[state=active]:after:h-0.5 data-[state=active]:after:rounded-full data-[state=active]:after:bg-primary',
      className,
    )}
    {...props}
  >
    {children}
    {count != null && (
      <span className="rounded-full bg-secondary px-1.5 py-0.5 text-[11px] font-bold tabular-nums text-muted-foreground group-data-[state=active]:bg-info-soft group-data-[state=active]:text-info-ink">
        {count}
      </span>
    )}
  </TabsPrimitive.Trigger>
));
TabsTrigger.displayName = TabsPrimitive.Trigger.displayName;

/** Pill-flavoured trigger for segmented filters (no underline). */
const TabsPill = React.forwardRef<
  React.ElementRef<typeof TabsPrimitive.Trigger>,
  React.ComponentPropsWithoutRef<typeof TabsPrimitive.Trigger>
>(({ className, ...props }, ref) => (
  <TabsPrimitive.Trigger
    ref={ref}
    className={cn(
      'inline-flex h-7 items-center gap-1.5 rounded-full px-3.5 text-sm font-semibold text-muted-foreground transition-colors',
      'hover:text-foreground data-[state=active]:bg-card data-[state=active]:text-foreground data-[state=active]:shadow-[var(--shadow-xs)]',
      className,
    )}
    {...props}
  />
));
TabsPill.displayName = 'TabsPill';

const TabsContent = React.forwardRef<
  React.ElementRef<typeof TabsPrimitive.Content>,
  React.ComponentPropsWithoutRef<typeof TabsPrimitive.Content>
>(({ className, ...props }, ref) => (
  <TabsPrimitive.Content ref={ref} className={cn('outline-none', className)} {...props} />
));
TabsContent.displayName = TabsPrimitive.Content.displayName;

export { Tabs, TabsList, TabsTrigger, TabsPill, TabsContent };
