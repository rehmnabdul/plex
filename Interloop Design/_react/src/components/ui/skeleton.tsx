import { cn } from '@/lib/utils';

/** Loading placeholder — same radius vocabulary as the component it stands in for. */
export function Skeleton({ className, ...props }: React.HTMLAttributes<HTMLDivElement>) {
  return (
    <div
      className={cn('animate-pulse rounded-md bg-[var(--il-grayblue-100)]', className)}
      aria-hidden
      {...props}
    />
  );
}
