# MobileList · MobileCard

See `MobileShell.prompt.md` for the mobile system and its sizing rules. This file covers the API.

**`MobileList` navigates. `MobileCard` acts.** A row takes you somewhere; a card holds the facts and the buttons for the job in front of you.

```jsx
<MobileList
  density="glove"
  onItemClick={(it) => open(it.id)}
  items={[
    { id: 'ILP-10482', title: 'ILP-10482', subtitle: 'Denim · 18,200 m · Faisalabad II',
      stripe: 'warning', status: 'QC hold', statusTone: 'warning',
      meta: [{ label: 'Due today' }, { label: 'AQL 2.5' }], value: '3', valueLabel: 'defects' },
  ]}
/>
```

- **`stripe` is the status signal** on a scrolling list; the pill only confirms it.
- `density`: `compact` (tablet review) · `default` 64px · `comfortable` 72px · `glove` 84px.
- `checkable` swaps the chevron for a 26px checkbox — use for multi-select, not for a to-do.
- `meta` takes 2–3 short facts. More than that and the row stops scanning.

```jsx
<MobileCard
  eyebrow="Next inspection" title="ILP-10482" subtitle="Final random · AQL 2.5 / 4.0"
  stripe="info" status="Due 14:00" statusTone="warning"
  facts={[{ label: 'Lot', value: '18,200' }, { label: 'Sample', value: '200' }]}
  actions={<><MobileButton variant="secondary">Details</MobileButton><MobileButton>Start</MobileButton></>}
/>
```

Two actions maximum on a card, and the right-hand one is the primary.
