# ActivityFeed

The audit trail, made readable. Every record in Loop Console — an order, a lot, a CAPA, a person — accumulates history; this is how that history is shown.

## When to use

- **Record history**: what happened to this order/inspection/CAPA and who did it.
- **Person profile**: what this user has been doing (paired with a profile panel on the left).
- **Workspace stream**: a "recent activity" column on a dashboard, `dense` and height-capped.

Not for notifications (that's a dropdown with read/unread state) and not for chat (turn-taking, composer, delivery states).

## Anatomy

Title + filter tabs → sticky day header (`Today` / `Yesterday` / `Thu, Sep 18`) with a hairline rule and a count → entries on a connected rail → `Load earlier activity`.

Each entry is one line of prose — **actor** + action + *target* + timestamp — plus an optional payload: a quote block, a `from → to` status change, a metric readout, file chips, tags, or inline buttons.

```jsx
<ActivityFeed
  title="Activity"
  maxHeight={620}
  tabs={[
    { id: 'all', label: 'All' },
    { id: 'quality', label: 'Quality', types: ['flag', 'alert', 'approval', 'rejected'] },
    { id: 'files', label: 'Files', types: ['upload'] },
  ]}
  items={[
    { id: '1', type: 'flag', actor: { name: 'Sana Iqbal', role: 'QA Lead' },
      action: 'raised a defect on', target: 'ILP-10482', targetHref: '#',
      time: '2026-08-02T09:12:00', tags: ['Skewness', 'AQL 2.5'],
      body: 'Third roll in the lot shows the same bowing. Holding the pallet.' },
    { id: '2', type: 'status', actor: { name: 'Bilal Raza' },
      action: 'moved', target: 'CAPA-338', time: '2026-08-02T08:40:00',
      from: 'Containment', to: 'Root cause', toTone: 'info' },
  ]}
/>
```

## Rules

- **Write the `action` as a verb phrase in past tense** — "approved", "uploaded 3 files to", "moved". The component supplies the actor name and the target; don't repeat them in the string.
- **Set `maxHeight`** whenever the feed lives in a card or a column. Sticky day headers only stick inside a scroll container.
- **One payload per entry.** A comment *or* a status change *or* files. Stacking all of them turns the timeline into a wall.
- Use `actor.src` for human actions (the avatar lands on the rail) and let system events keep their icon — the mixed rail is how a reader separates "someone did this" from "the system did this".
- Cap the initial page at 20–30 entries and page with `hasMore` + `onLoadMore`.
- `dense` for sidebars and dashboard columns; default spacing for a full-width history tab.

## Don't

- Don't use `tone: 'danger'` for routine events — red on the rail means something needs a human.
- Don't put more than 3–4 filter tabs up top; more belongs in a filter control.
- Don't render raw diff JSON in `body`. Summarise the change, or use `from`/`to`.
