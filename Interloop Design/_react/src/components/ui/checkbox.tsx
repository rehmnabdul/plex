import * as React from 'react';
import * as CheckboxPrimitive from '@radix-ui/react-checkbox';
import { Check, Minus } from 'lucide-react';
import { cn } from '@/lib/utils';

const Checkbox = React.forwardRef<
  React.ElementRef<typeof CheckboxPrimitive.Root>,
  React.ComponentPropsWithoutRef<typeof CheckboxPrimitive.Root>
>(({ className, ...props }, ref) => (
  <CheckboxPrimitive.Root
    ref={ref}
    className={cn(
      'peer size-4 shrink-0 rounded-xs border-[1.5px] border-[var(--il-grayblue-300)] bg-card transition-colors duration-[120ms]',
      'data-[state=checked]:border-primary data-[state=checked]:bg-primary data-[state=checked]:text-primary-foreground',
      'data-[state=indeterminate]:border-primary data-[state=indeterminate]:bg-primary data-[state=indeterminate]:text-primary-foreground',
      'disabled:cursor-not-allowed disabled:opacity-50',
      className,
    )}
    {...props}
  >
    <CheckboxPrimitive.Indicator className="flex items-center justify-center text-current">
      {props.checked === 'indeterminate' ? <Minus className="size-3" strokeWidth={3} /> : <Check className="size-3" strokeWidth={3.5} />}
    </CheckboxPrimitive.Indicator>
  </CheckboxPrimitive.Root>
));
Checkbox.displayName = CheckboxPrimitive.Root.displayName;

/** Checkbox with a label and optional description, spaced to the 4px grid. */
export function CheckboxField({
  label, description, id, className, ...props
}: React.ComponentPropsWithoutRef<typeof Checkbox> & { label: string; description?: string }) {
  const auto = React.useId();
  const inputId = id ?? auto;
  return (
    <div className={cn('flex items-start gap-2.5', className)}>
      <Checkbox id={inputId} className="mt-0.5" {...props} />
      <div className="grid gap-0.5 leading-none">
        <label htmlFor={inputId} className="cursor-pointer text-sm font-semibold text-foreground">{label}</label>
        {description && <span className="text-xs text-muted-foreground">{description}</span>}
      </div>
    </div>
  );
}

export { Checkbox };
