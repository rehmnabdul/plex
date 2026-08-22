# GanttChart

Time on the x-axis, work on the y-axis. For T&A plans, production schedules and any commitment with a date attached.

```jsx
<GanttChart
  title="Time & action · ILP-10482"
  subtitle="Ship window 20–25 Oct 2026"
  today="2026-08-04"
  tasks={[
    { id: 'mat', name: 'Materials', parentId: undefined },
    { id: 'yarn', name: 'Yarn arrival', parentId: 'mat', start: '2026-05-05', end: '2026-05-10',
      status: 'done', progress: 100, baselineStart: '2026-05-01', baselineEnd: '2026-05-08' },
    { id: 'knit', name: 'Knitting', start: '2026-06-01', end: '2026-06-28', status: 'active',
      progress: 62, dependsOn: ['yarn'], critical: true, owner: 'Line 4' },
    { id: 'fri', name: 'FRI pass', start: '2026-10-19', milestone: true, status: 'planned' },
  ]}
/>
```

## The parts, and when each earns its place

- **Bars** — a duration. Colour is status (`done` · `active` · `risk` · `late` · `planned` · `blocked`), the lighter fill inside is `progress`.
- **Milestones** — a date with no duration: a gate, a pass, a cut-off. Diamonds, never one-day bars.
- **Roll-up phases** — a task with children draws a bracket spanning them. Group by phase, not by department.
- **Baselines** — the thin grey bar underneath is the original plan. **Add it the moment a date slips**; a Gantt without a baseline cannot answer "are we later than we said?"
- **Dependencies** — finish-to-start arrows. Only draw the ones that are real constraints; a chart where everything depends on everything is a diagram of nothing.
- **Critical path** — `critical: true` reddens the row marker and its arrows. This is the chain worth a manager's attention.
- **Today line** — the reason anyone opens the chart. Never hide it.

## Rules

- **Zoom by question.** `day` for this week's floor plan, `week` for an order's T&A, `month` for a season. The toolbar switch is there because those are different questions about the same data.
- **Sort by start date within a phase.** A Gantt sorted alphabetically is a table with decoration.
- **Keep it under ~40 rows.** Past that, collapse phases and let the detail live in the record.
- **Status is a fact, not a mood.** `late` means past its finish with work outstanding; `risk` means the projection crosses the date. Don't paint amber to mean "I'm worried".
- Give short bars an `owner` — it renders beside the bar, which is the only place a two-day task has room for a label.

## Don't

- Don't use it as a task list. If nothing depends on anything and nothing has a duration, you want `MiniTable`.
- Don't encode two things in colour. Status owns the colour channel; the critical path uses the marker and the arrows.
- Don't let users drag bars unless the backend can actually reschedule — a plan that silently reverts is worse than a read-only one.
