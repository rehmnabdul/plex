import i18n from 'i18next';
import { initReactI18next } from 'react-i18next';

/**
 * ABP localization keys, namespaced by resource. In a wired ABP app these come
 * from `/api/abp/application-localization`; the bundled copy below is the
 * fallback so the SPA renders before that call resolves.
 */
export const resources = {
  en: {
    translation: {
      'LoopConsole::Menu:Dashboard': 'Dashboard',
      'LoopConsole::Menu:Orders': 'Orders',
      'LoopConsole::Menu:Inspections': 'Inspections',
      'LoopConsole::Menu:People': 'People',
      'LoopConsole::Menu:DesignSystem': 'Design system',
      'LoopConsole::Orders': 'Orders',
      'LoopConsole::Orders:Title': 'Production orders',
      'LoopConsole::Orders:Subtitle': 'Live from the planning system',
      'LoopConsole::Orders:New': 'New order',
      'LoopConsole::Order:BackToList': 'Back to T&A management',
      'LoopConsole::Order:Split': 'Split T&A',
      'LoopConsole::Order:UpdateStatus': 'Update status',
      'LoopConsole::Order:Tab:Information': 'Order information',
      'LoopConsole::Order:Tab:Stakeholders': 'Stakeholders',
      'LoopConsole::Order:Tab:Production': 'Production status',
      'LoopConsole::Order:PurchaseOrderInformation': 'Purchase order information',
      'LoopConsole::Order:ProductInformation': 'Product information',
      'LoopConsole::Order:TimeAndAction': 'Time & action',
      'LoopConsole::Order:Activities': 'Activities',
      'LoopConsole::Order:BulkComplete': 'Bulk complete on planned date',
      'LoopConsole::Common:Complete': 'Complete',
      'LoopConsole::Common:Search': 'Search…',
      'LoopConsole::Common:Filters': 'Filters',
      'LoopConsole::Common:Columns': 'Columns',
      'LoopConsole::Common:Group': 'Group',
      'LoopConsole::Common:Export': 'Export',
      'LoopConsole::Common:Rows': 'Rows',
      'LoopConsole::Common:NoData': 'No rows to show',
      'LoopConsole::Common:NoDataHint': 'Try clearing a filter or widening your search.',
      'AbpUi::Save': 'Save',
      'AbpUi::Cancel': 'Cancel',
      'AbpUi::Edit': 'Edit',
      'AbpUi::Delete': 'Delete',
      'AbpUi::PagerNext': 'Next',
      'AbpUi::PagerPrevious': 'Previous',
    },
  },
} as const;

void i18n.use(initReactI18next).init({
  resources: resources as unknown as Record<string, Record<string, Record<string, string>>>,
  lng: localStorage.getItem('lang') ?? 'en',
  fallbackLng: 'en',
  interpolation: { escapeValue: false },
  // ABP keys contain "::" and ":" — neither is a nesting/namespace separator here.
  keySeparator: false,
  nsSeparator: false,
});

export default i18n;
