# Calendar

Month, week, day and agenda over one event list. For **scheduling work** — inspections, audits, line bookings, shipment windows. For picking a date into a form, use `DateField`; that is a different job.

```jsx
<Calendar
  events={inspections}
  view="week"
  today={new Date('2026-08-04')}
  dayStart={6} dayEnd={20}
  onEventClick={open}
  onSelectSlot={(d) => book(d)}
  actions={<Button size="sm">Schedule</Button>}
/>
```

## Which view answers which question

| Question | View |
|---|---|
| How busy is the month? | `month` |
| What does the shift look like? | `week` / `day` — a real time grid with a now line |
| What is coming next? | `agenda` — the only view that scans in one pass |

Open on `week` for anyone working a shift; `month` is a planning view, not an operating one. `showWeekends={false}` gives a five-column working week where Saturday and Sunday would only be dead space.

## Moving work around

`editable` turns on dragging: an event can be dropped on another day in month view, or on an hour in the time views (snapped to `snapMinutes`), and its bottom edge dragged to change duration. Clicking any event opens a **detail card** with its time, meta and status, plus Edit and Delete when you supply those handlers.

```jsx
<Calendar
  events={events} editable view="week"
  onEventDrop={(e, start, end) => reschedule(e.id, start, end)}
  onEventResize={(e, start, end) => reschedule(e.id, start, end)}
  onEventEdit={openForm}
  onEventDelete={confirmDelete}
/>
```

Dropping a month event keeps its clock time and changes only the date — a 07:30 inspection moved to Thursday is still at 07:30.

**The component never mutates `events`.** It reports the intent; you persist and feed the new list back. A calendar that moves a block optimistically and then silently reverts is worse than one that cannot drag at all — so leave `editable` off wherever the backend can't actually reschedule.

## Rules

- **Tone is status, not category.** `success` passed, `warning` at risk, `danger` failed or blocked, `neutral` informational. Don't colour by division — you will run out of meanings.
- **`maxPerDay` then "+n more".** A month cell that lists nine events is unreadable; the overflow link jumps to that day, which is where nine events belong.
- **The now line is the point of the time grid.** Keep `today` accurate; it is what makes "am I behind?" answerable at a glance.
- **`onSelectSlot` only when creating is real.** A grid that responds to clicks and then does nothing teaches people not to click.
- `dayStart` / `dayEnd` should match the actual shift. A 24-hour grid for a 06:00–20:00 operation wastes 40% of the screen.
- **Concurrent events split into side-by-side lanes** in the time views — a double-booking looks like a double-booking, never like one event that vanished. Dragging into an occupied hour is normal; the calendar shows the clash rather than hiding it.
- Use `meta` for the one fact that decides whether to open the event — the lot, the vendor, the line.

## Don't

- Don't use a calendar for a task list with due dates; that is a `DataGrid` sorted by date.
- Don't put a schedule spanning months in `month` view — a `GanttChart` shows duration and dependency, which a calendar cannot.
- Don't render more than ~200 events in one view; filter first.
