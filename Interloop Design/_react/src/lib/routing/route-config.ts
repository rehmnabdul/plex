import type { LucideIcon } from 'lucide-react';
import { ClipboardCheck, LayoutDashboard, Package, Palette, Users } from 'lucide-react';

/**
 * Menu configuration, kept separate from the router so navigation can be
 * driven by ABP permissions without touching route definitions.
 */
export interface MenuEntry {
  key: string;
  /** ABP localization key. */
  labelKey: string;
  to: string;
  icon?: LucideIcon;
  badge?: number | string;
  /** Gate with `usePermissions()` once the ABP app-config call is wired. */
  permission?: string;
  section?: boolean;
}

export const mainMenu: MenuEntry[] = [
  { key: 'ops', labelKey: 'Operations', to: '', section: true },
  { key: 'dashboard', labelKey: 'LoopConsole::Menu:Dashboard', to: '/', icon: LayoutDashboard },
  { key: 'orders', labelKey: 'LoopConsole::Menu:Orders', to: '/orders', icon: Package, badge: 12, permission: 'LoopConsole.Orders' },
  { key: 'inspections', labelKey: 'LoopConsole::Menu:Inspections', to: '/inspections', icon: ClipboardCheck, permission: 'LoopConsole.Inspections' },
  { key: 'people', labelKey: 'LoopConsole::Menu:People', to: '/people', icon: Users },
  { key: 'system', labelKey: 'System', to: '', section: true },
  { key: 'design-system', labelKey: 'LoopConsole::Menu:DesignSystem', to: '/design-system', icon: Palette },
];
