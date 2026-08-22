import { Bell, HelpCircle, PanelLeft, Search } from 'lucide-react';
import { Input } from '@/components/ui/input';
import { IconButton } from '@/components/ui/icon-button';
import { UserAvatar } from '@/components/ui/avatar';
import { Separator } from '@/components/ui/separator';

export interface AppHeaderProps {
  title: string;
  onToggleSidebar: () => void;
}

/** AUTH SEAM: swap the hard-coded user for `useAuth().user` once OIDC is wired. */
const CURRENT_USER = { name: 'Ayesha Khan', role: 'Quality Manager' };

export function AppHeader({ title, onToggleSidebar }: AppHeaderProps) {
  return (
    <header className="sticky top-0 z-40 flex h-16 shrink-0 items-center gap-3 border-b border-border bg-card px-5">
      <IconButton variant="ghost" size="sm" aria-label="Toggle navigation" onClick={onToggleSidebar}>
        <PanelLeft />
      </IconButton>
      <h1 className="text-lg font-bold tracking-tight">{title}</h1>

      <div className="ml-auto flex items-center gap-2">
        <Input
          placeholder="Search orders, lots, people…"
          aria-label="Global search"
          startAdornment={<Search />}
          className="hidden h-9 w-[280px] md:flex"
        />
        <IconButton variant="ghost" size="sm" aria-label="Help"><HelpCircle /></IconButton>
        <IconButton variant="ghost" size="sm" aria-label="Notifications" badge={3}><Bell /></IconButton>
        <Separator orientation="vertical" className="mx-1 h-7" />
        <button type="button" className="flex items-center gap-2.5 rounded-md px-1.5 py-1 text-left hover:bg-muted">
          <UserAvatar name={CURRENT_USER.name} size={32} status="online" />
          <span className="hidden flex-col leading-tight sm:flex">
            <span className="text-sm font-bold">{CURRENT_USER.name}</span>
            <span className="text-xs text-muted-foreground">{CURRENT_USER.role}</span>
          </span>
        </button>
      </div>
    </header>
  );
}
