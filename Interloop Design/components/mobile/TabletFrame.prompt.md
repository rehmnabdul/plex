# Tablet — TabletFrame · TabletRail · SplitView

The 11-inch tier. Not a big phone and not a small desktop: a **supervisor's device**, usually docked at a line station in landscape or carried in portrait on a walk-around.

See `MobileShell.prompt.md` for the shop-floor conditions that still apply — daylight legibility, offline-first, colour never carried alone. What changes at 11 inches is layout and reach.

## What changes from the phone

| Phone | Tablet |
|---|---|
| Bottom tab bar | **`TabletRail`** — thumbs rest at the sides when a tablet is held, and the bottom edge is where a stand or keyboard is |
| One screen at a time | **`SplitView`** — the list stays on screen while the record is worked |
| 84px glove rows | 56–64px rows — the tablet is two-handed or docked, not held at arm's length in a glove |
| Sheets for everything | Sheets for choices, **detail pane** for work |
| `MobileList` only | `MiniTable` and `DataGrid` are legitimate here |

```jsx
<TabletFrame orientation="landscape" caption="Inspection console">
  <TabletRail items={nav} value={tab} onChange={setTab} header={<Logo variant="mark" tone="white" height={26} />} />
  <div style={{ display: 'flex', flexDirection: 'column', flex: 1, minWidth: 0 }}>
    <TabletToolbar title="ILP-10482" subtitle="Denim · roll 14 of 22" onToggleMaster={toggle}
      actions={<MobileButton>Submit verdict</MobileButton>} />
    <SplitView
      masterTitle="Today's queue" masterSubtitle="12 due"
      master={<MobileList items={queue} onItemClick={open} />}
      masterHidden={collapsed}
      detail={<SplitDetailBody>…</SplitDetailBody>}
    />
  </div>
</TabletFrame>
```

## Rules

- **Landscape is the primary orientation.** Design it first; portrait is the walk-around case and usually means collapsing the master pane.
- **The master pane never scrolls the detail away.** Both panes scroll independently — that is the whole reason to use a split.
- **Master 320–420px.** Narrower and the list rows truncate; wider and the detail pane stops being the focus.
- **Give the split an empty state.** A detail pane with nothing selected is the tablet's most common resting state, so say what to pick.
- **`onToggleMaster` for dense work.** Filling in a long form or reading a grid deserves the full width; keep it one tap away, never a mode the user can get stuck in.
- Keep the rail to 4–6 destinations. It has no room for a menu and shouldn't have one.
- `wide` rail (216px) when labels are ambiguous or the app is used by occasional operators; the 92px icon+label stack when the same six people use it every shift.

## Don't

- Don't put a bottom tab bar on a tablet — it's an unreachable corner on a docked device.
- Don't stretch a phone layout to 1194px. A single 1194px-wide column of 64px rows is a worse experience than the phone it came from.
- Don't hide the master pane by default. The list is the context; taking it away on load makes the app feel like a phone with extra whitespace.
