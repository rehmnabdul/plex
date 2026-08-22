import * as React from 'react';
import * as SwitchPrimitive from '@radix-ui/react-switch';
import { cn } from '@/lib/utils';

const Switch = React.forwardRef<
  React.ElementRef<typeof SwitchPrimitive.Root>,
  React.ComponentPropsWithoutRef<typeof SwitchPrimitive.Root> & { size?: 'sm' | 'default' }
>(({ className, size = 'default', ...props }, ref) => (
  <SwitchPrimitive.Root
    ref={ref}
    className={cn(
      'peer inline-flex shrink-0 cursor-pointer items-center rounded-full border-2 border-transparent transition-colors duration-[120ms]',
      'data-[state=checked]:bg-primary data-[state=unchecked]:bg-[var(--il-grayblue-200)]',
      'disabled:cursor-not-allowed disabled:opacity-50',
      size === 'sm' ? 'h-4 w-7' : 'h-5 w-9',
      className,
    )}
    {...props}
  >
    <SwitchPrimitive.Thumb
      className={cn(
        'pointer-events-none block rounded-full bg-white shadow-[var(--shadow-xs)] ring-0 transition-transform duration-[120ms]',
        size === 'sm' ? 'size-3 data-[state=checked]:translate-x-3' : 'size-4 data-[state=checked]:translate-x-4',
        'data-[state=unchecked]:translate-x-0',
      )}
    />
  </SwitchPrimitive.Root>
));
Switch.displayName = SwitchPrimitive.Root.displayName;

export function SwitchField({
  label, description, id, className, ...props
}: React.ComponentPropsWithoutRef<typeof Switch> & { label: string; description?: string }) {
  const auto = React.useId();
  const inputId = id ?? auto;
  return (
    <div className={cn('flex items-center gap-3', className)}>
      <Switch id={inputId} {...props} />
      <div className="grid gap-0.5 leading-none">
        <label htmlFor={inputId} className="cursor-pointer text-sm font-semibold text-foreground">{label}</label>
        {description && <span className="text-xs text-muted-foreground">{description}</span>}
      </div>
    </div>
  );
}

export { Switch };
