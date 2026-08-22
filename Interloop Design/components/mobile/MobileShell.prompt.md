# Mobile components

The shop-floor kit: `PhoneFrame`, `MobileAppBar` / `MobileScreen` / `MobileTabBar` / `MobileSheet` / `MobileButton`, `MobileList` / `MobileCard`, `TallyPad` / `MobileStepper` / `MobileSegmented` / `SyncStatus` / `PhotoCapture`.

These are **not** the desktop components at a smaller size. They are built for the conditions the app is actually used in.

## The four conditions that shaped every default

1. **Gloves.** The 44px guideline assumes a bare fingertip. Rows are 64px, primary buttons 52px, tally controls 52px, and `density="glove"` takes rows to 84px. Anything an operator taps repeatedly gets the larger size.
2. **Daylight and mill lighting.** Status is never carried by colour alone — a stripe *and* a pill, an icon *and* a label. Body text starts at 16px, secondary at 13px, and **all supporting chrome — eyebrows, fact labels, tab labels, severity chips — sits at 12px minimum in `--text-secondary`** (5.9:1 on white, 5.4:1 on the page tint). The single exception is a numeric count badge in white on a solid fill, which may be 11px. Never `--text-muted` on a phone: it measures ~3.2:1 and disappears in bright light.
3. **Offline-first.** `SyncStatus` is a permanent fixture, not a toast. The operator must always be able to answer "has my work left this device?" without asking anyone.
4. **One hand, often the wrong one.** Primary actions sit at the bottom — the tab bar, the sheet footer, the card's action row. The app bar carries navigation and at most two icon actions; it is not an action surface.

## Structure

```jsx
<PhoneFrame caption="Inspection · defect capture">
  <MobileAppBar title="Lot ILP-10482" subtitle="Denim · roll 14 of 22" onBack={back}
    actions={<MobileAction icon={<Info />} label="Lot details" />} />
  <SyncStatus state="offline" pending={3} />
  <MobileScreen padded>
    <TallyPad items={defects} values={counts} onChange={setCount} criticalAt={5} />
  </MobileScreen>
  <MobileTabBar tabs={tabs} value={tab} onChange={setTab} />
</PhoneFrame>
```

`PhoneFrame` is for **presentation only** — the design-system card and design reviews. Never ship it around a real screen.

## Rules

- **One primary action per screen**, at the bottom, full width. If two actions compete, one of them is secondary.
- **`MobileList` for browsing, `MobileCard` for acting.** A list row navigates; a card carries the facts and the buttons for the job in front of you.
- **The stripe is the status.** On a scrolling list of 40 lots, the left edge colour is what gets read — the pill is confirmation, not the signal.
- **Sheets, not dialogs.** A `MobileSheet` is reachable with a thumb and dismissible by the scrim. Modal dialogs are a desktop pattern.
- **Never make a number a text field** where a `MobileStepper` or `TallyPad` will do. Keyboards are slow, wrong, and often covered by a glove.
- **Two or three segmented options, never more.** Pass / Fail / Hold is the ceiling; past that it's a list.
- Keep the tab bar to 3–5 destinations. The `fab` splits them and raises the one action people came to do.

## Don't

- Don't hide sync state behind a settings screen.
- Don't rely on hover — there isn't one. Every state must be visible at rest.
- Don't use `density="compact"` on any screen an operator uses standing up; it's for supervisor review on a tablet.
- Don't put a `DataGrid` or `SheetGrid` on a phone. Use `MobileList`, and let the tablet layout carry the grid.
