import * as React from 'react';
import * as LabelPrimitive from '@radix-ui/react-label';
import { cn } from '@/lib/utils';

const Label = React.forwardRef<
  React.ElementRef<typeof LabelPrimitive.Root>,
  React.ComponentPropsWithoutRef<typeof LabelPrimitive.Root> & { required?: boolean }
>(({ className, required, children, ...props }, ref) => (
  <LabelPrimitive.Root
    ref={ref}
    className={cn('text-sm font-bold text-foreground peer-disabled:opacity-60', className)}
    {...props}
  >
    {children}
    {required && <span className="ml-0.5 text-destructive" aria-hidden>*</span>}
  </LabelPrimitive.Root>
));
Label.displayName = LabelPrimitive.Root.displayName;

/** Field wrapper: label + control + hint/error, spaced consistently. */
export function Field({
  label, hint, error, required, htmlFor, children, className,
}: {
  label?: string; hint?: string; error?: string; required?: boolean;
  htmlFor?: string; children: React.ReactNode; className?: string;
}) {
  return (
    <div className={cn('flex flex-col gap-1.5', className)}>
      {label && <Label htmlFor={htmlFor} required={required}>{label}</Label>}
      {children}
      {error ? (
        <p className="text-xs font-semibold text-danger-ink" role="alert">{error}</p>
      ) : hint ? (
        <p className="text-xs text-muted-foreground">{hint}</p>
      ) : null}
    </div>
  );
}

export { Label };
