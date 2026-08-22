import * as React from 'react';
import { cn } from '@/lib/utils';

export interface InputProps extends React.InputHTMLAttributes<HTMLInputElement> {
  /** Renders the field in its error state and wires aria-invalid. */
  invalid?: boolean;
  /** Node pinned inside the left edge (an icon). */
  startAdornment?: React.ReactNode;
}

const Input = React.forwardRef<HTMLInputElement, InputProps>(
  ({ className, type = 'text', invalid, startAdornment, ...props }, ref) => {
    const field = (
      <input
        type={type}
        ref={ref}
        aria-invalid={invalid || undefined}
        className={cn(
          'flex h-10 w-full rounded-md border border-input bg-card px-3 py-2 text-sm text-foreground transition-[border-color,box-shadow] duration-[120ms]',
          'placeholder:text-muted-foreground/70 file:border-0 file:bg-transparent file:text-sm file:font-bold',
          'focus-visible:border-ring disabled:cursor-not-allowed disabled:bg-muted disabled:opacity-60',
          'aria-[invalid=true]:border-destructive aria-[invalid=true]:focus-visible:shadow-[0_0_0_3px_color-mix(in_srgb,var(--destructive)_28%,transparent)]',
          startAdornment && 'pl-9',
          className,
        )}
        {...props}
      />
    );
    if (!startAdornment) return field;
    return (
      <div className="relative flex items-center">
        <span className="pointer-events-none absolute left-3 flex text-muted-foreground [&_svg]:size-4">{startAdornment}</span>
        {field}
      </div>
    );
  },
);
Input.displayName = 'Input';

export { Input };
