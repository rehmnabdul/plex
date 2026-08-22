import * as React from 'react';
import * as AvatarPrimitive from '@radix-ui/react-avatar';
import { cn } from '@/lib/utils';

const Avatar = React.forwardRef<
  React.ElementRef<typeof AvatarPrimitive.Root>,
  React.ComponentPropsWithoutRef<typeof AvatarPrimitive.Root>
>(({ className, ...props }, ref) => (
  <AvatarPrimitive.Root
    ref={ref}
    className={cn('relative flex size-10 shrink-0 overflow-hidden rounded-full', className)}
    {...props}
  />
));
Avatar.displayName = AvatarPrimitive.Root.displayName;

const AvatarImage = React.forwardRef<
  React.ElementRef<typeof AvatarPrimitive.Image>,
  React.ComponentPropsWithoutRef<typeof AvatarPrimitive.Image>
>(({ className, ...props }, ref) => (
  <AvatarPrimitive.Image ref={ref} className={cn('aspect-square size-full object-cover', className)} {...props} />
));
AvatarImage.displayName = AvatarPrimitive.Image.displayName;

const AvatarFallback = React.forwardRef<
  React.ElementRef<typeof AvatarPrimitive.Fallback>,
  React.ComponentPropsWithoutRef<typeof AvatarPrimitive.Fallback>
>(({ className, ...props }, ref) => (
  <AvatarPrimitive.Fallback
    ref={ref}
    className={cn('flex size-full items-center justify-center rounded-full font-bold text-white', className)}
    {...props}
  />
));
AvatarFallback.displayName = AvatarPrimitive.Fallback.displayName;

/** Brand palette, picked deterministically from the name. */
const TINTS = ['var(--il-blue-500)', 'var(--il-air)', 'var(--il-sun)', 'var(--il-earth)', 'var(--il-grayblue-500)'];

export const initialsOf = (name: string) =>
  name.trim().split(/\s+/).slice(0, 2).map((p) => p[0]?.toUpperCase() ?? '').join('');

export const tintFor = (name: string) =>
  TINTS[[...name].reduce((a, c) => a + c.charCodeAt(0), 0) % TINTS.length];

export interface UserAvatarProps extends React.ComponentPropsWithoutRef<typeof Avatar> {
  name: string;
  src?: string;
  size?: number;
  status?: 'online' | 'busy' | 'away' | 'offline';
}

const STATUS: Record<string, string> = {
  online: 'var(--il-earth)', busy: 'var(--il-red)',
  away: 'var(--il-sun)', offline: 'var(--il-grayblue-300)',
};

/** Convenience wrapper: initials fallback, auto tint, presence dot. */
export function UserAvatar({ name, src, size = 40, status, className, ...props }: UserAvatarProps) {
  return (
    <span className="relative inline-flex shrink-0">
      <Avatar className={className} style={{ width: size, height: size }} {...props}>
        {src && <AvatarImage src={src} alt={name} />}
        <AvatarFallback style={{ background: tintFor(name), fontSize: Math.max(10, size * 0.38) }}>
          {initialsOf(name)}
        </AvatarFallback>
      </Avatar>
      {status && (
        <span
          aria-label={status}
          className="absolute bottom-0 right-0 rounded-full border-2 border-card"
          style={{ background: STATUS[status], width: Math.max(8, size * 0.28), height: Math.max(8, size * 0.28) }}
        />
      )}
    </span>
  );
}

export { Avatar, AvatarImage, AvatarFallback };
