# ReportDocument

One printable sheet, many documents. Commercial invoice, inspection report, packing list, credit note, certificate of compliance — they share a masthead, a meta strip, party blocks, a line-item table, a total and a sign-off. This component is that skeleton.

## Anatomy

Screen-only action bar (hidden on print) → sheet:

1. **Masthead** — logo + issuer address on the left, document kind / number / status stamp on the right, closed by a 2px Gray Blue rule.
2. **Meta strip** — dates and references. 3–5 items; more turns into noise.
3. **Parties** — Issued by / Issued to (/ Ship to).
4. **Line items** — dark header row, optional banding via `groupBy`, `row.note` for a caption under the description.
5. **Summary + notes** — terms on the left, subtotal lines and the emphasised total on the right.
6. **Fact blocks** — payment details, shipment, inspection scope.
7. **Signatures** — rule + name + role.
8. **Sheet footer** — small print.

```jsx
<ReportDocument
  kind="Commercial Invoice"
  number="ILP-INV-24817"
  status={{ label: 'Approved', tone: 'success' }}
  logo={<img src="assets/interloop-logo.svg" alt="Interloop" />}
  issuer={{ name: 'Interloop Limited', lines: ['7-KM Khurrianwala–Jaranwala Road', 'Faisalabad 37610, Pakistan'] }}
  meta={[
    { label: 'Issue date', value: '02 Aug 2026' },
    { label: 'Due date', value: '01 Sep 2026', hint: 'Net 30' },
    { label: 'Order ref', value: 'ILP-10482' },
  ]}
  parties={[
    { label: 'Issued to', name: 'Nordstrom Inc.', address: '1617 Sixth Avenue\nSeattle, WA 98101, USA' },
    { label: 'Issued by', name: 'Interloop Limited — Denim', address: 'Plant 4, Faisalabad, Pakistan' },
  ]}
  columns={[
    { key: 'desc', header: 'Description', width: '46%' },
    { key: 'qty', header: 'Qty', type: 'number' },
    { key: 'rate', header: 'Rate', type: 'number' },
    { key: 'amount', header: 'Amount', type: 'number' },
  ]}
  items={rows}
  summary={[{ label: 'Subtotal', value: '$482,900.00' }, { label: 'Freight', value: '$6,400.00', rule: true }]}
  total={{ label: 'Total due', value: '$489,300.00', note: 'Payable in USD' }}
/>
```

## Rules

- **The number is the headline.** Keep `kind` short ("Commercial Invoice", "Final Inspection Report") — it's the eyebrow, not the title.
- **Money and quantities use `type: 'number'`** so they right-align on tabular figures. A column of amounts that doesn't line up reads as amateur.
- **Pre-format values.** The component doesn't do currency or locale — pass `"$482,900.00"`, or a `format` on the column.
- **Status tone means something**: `success` approved/passed, `warning` pending, `danger` rejected/overdue, `info` in progress. Don't decorate.
- Keep to `a4` unless the audience is US-only (`letter`). `fluid` is for embedding inside an app panel, not for printing.
- Test the print view before shipping a new document type — `Print / PDF` is the real deliverable, the screen sheet is a preview.

## Don't

- Don't put interactive controls (inputs, dropdowns, pagination) inside the sheet. It's a document, not a screen — put actions in `actions` on the bar.
- Don't stack more than ~3 `notes` and ~4 `blocks`; past that, split into a second document.
- Don't fake a handwritten signature for a signature that hasn't happened. Leave `mark` empty and let the line be signed.
