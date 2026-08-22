import React from 'react';

export type DocumentTone = 'neutral' | 'info' | 'success' | 'warning' | 'danger';

export interface DocumentColumn {
  /** Field on the item row. */
  key: string;
  header: string;
  /** Right-aligns and applies tabular figures when "number". */
  type?: 'text' | 'number';
  align?: 'left' | 'center' | 'right';
  /** CSS width for the column, e.g. "18%" or 120. */
  width?: string | number;
  format?: (value: any, row: any) => React.ReactNode;
  render?: (value: any, row: any) => React.ReactNode;
}

export interface DocumentParty {
  /** Eyebrow above the block — "Issued to", "Issued by", "Ship to". */
  label: string;
  name: string;
  /** Multi-line address. Newlines are preserved. */
  address?: string;
  /** Extra facts under the address (VAT no., contact, terms). */
  rows?: Array<{ label: string; value: React.ReactNode }>;
}

/**
 * Printable business document: commercial invoice, inspection report,
 * packing list, credit note, certificate of compliance.
 *
 * Renders an on-screen sheet with a print bar, and paginates cleanly to PDF —
 * the bar is hidden, page colours are preserved, and rows, fact blocks and
 * signature lines avoid breaking across pages.
 */
export interface ReportDocumentProps extends React.HTMLAttributes<HTMLElement> {
  /** Document class, printed as an eyebrow. @default "Invoice" */
  kind?: string;
  /** Document number — the largest thing on the masthead. */
  number?: string;
  /** Status stamp under the number. */
  status?: { label: string; tone?: DocumentTone };
  /** Brand mark node — an `<img>` or the `Logo` component. */
  logo?: React.ReactNode;
  /** The issuing entity, printed under the logo. */
  issuer?: { name: string; lines?: string[] };
  /** Party blocks (issued by / issued to / ship to). Two or three read best. */
  parties?: DocumentParty[];
  /** Dates and references in the strip under the masthead. */
  meta?: Array<{ label: string; value: React.ReactNode; hint?: string }>;
  /** Line-item table columns. Omit to skip the table. */
  columns?: DocumentColumn[];
  /** Line items. `row.note` renders as a caption under the first cell. */
  items?: any[];
  /** Field on the items to band the table by (e.g. "section"). */
  groupBy?: string | null;
  /** Subtotal / tax / discount lines above the total. `rule` adds a divider. */
  summary?: Array<{ label: string; value: React.ReactNode; rule?: boolean }>;
  /** The emphasised total block. */
  total?: { label?: string; value: React.ReactNode; note?: string };
  /** Prose blocks left of the summary — terms, remarks, method statement. */
  notes?: Array<{ title: string; body: React.ReactNode }>;
  /** Fact blocks below the total — payment details, shipment, inspection scope. */
  blocks?: Array<{ title: string; rows: Array<{ label: string; value: React.ReactNode }> }>;
  /** Sign-off lines. `mark` prints a signature-style name above the rule. */
  signatures?: Array<{ role: string; name?: string; date?: string; mark?: string }>;
  /** Small print at the foot of the sheet. */
  footerNote?: React.ReactNode;
  footerRight?: React.ReactNode;
  /** Sheet width. @default "a4" */
  paper?: 'a4' | 'letter' | 'fluid';
  /** Heading in the screen-only action bar. */
  toolbarTitle?: string;
  /** Extra buttons in the action bar (screen only). */
  actions?: React.ReactNode;
  /** Show the built-in Print / PDF button. @default true */
  showPrint?: boolean;
}

export function ReportDocument(props: ReportDocumentProps): JSX.Element;
