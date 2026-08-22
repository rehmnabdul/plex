# Wizard

A long form, broken into steps someone can finish. Used for setup flows that can't be a single screen: new inspection plan, vendor onboarding, order intake, CAPA creation.

## Which orientation

- **Horizontal** — 3–5 steps with short names, and the step body is the focus. Reads as a progress bar you can name.
- **Vertical** — steps need a sentence of explanation, or there are more than five. The rail doubles as a table of contents and survives long forms without the header eating the page.

Same component, same children, one prop.

## Anatomy

Rail (numbered badge → check when done, title, subtitle) → step panel → footer (Back · optional extras · "Step 2 of 5" · Next / Finish).

```jsx
const steps = [
  { key: 'type', title: 'Inspection type', subtitle: 'What is being checked' },
  { key: 'scope', title: 'Scope & sampling', subtitle: 'Lot size and AQL' },
  { key: 'done', title: 'Review', subtitle: 'Confirm and schedule' },
];

<Wizard
  steps={steps}
  orientation="vertical"
  current={step}
  onStepChange={setStep}
  onFinish={submit}
  finishLabel="Schedule inspection"
  canAdvance={isStepValid}
  errorSteps={invalidSteps}
>
  <TypeStep />
  <ScopeStep />
  <ReviewStep />
</Wizard>
```

Supporting parts: `WizardStepHeader` (title + description + help link), `WizardOptions` / `WizardOptionCard` (the big selectable cards), `WizardDone` (terminal success panel).

## Rules

- **The rail is a promise.** Every step listed must be reachable in this session — don't show steps that only appear conditionally. Branching means two wizards, or a single step that changes shape.
- **Name steps as nouns, not verbs** — "Scope & sampling", not "Choose your scope". The verb lives in the step's own heading.
- **Subtitles are one short line.** They orient; they don't instruct. Instruction belongs in the panel.
- **Validate per step, not at the end.** Set `canAdvance={false}` while the current step is invalid and pass `errorSteps` for steps the user has already left in a bad state.
- **Keep `linear` on** unless the steps are genuinely independent. Free jumping through a dependent form produces half-filled records.
- **One decision per step where possible.** A step that scrolls twice should be two steps.
- Give the wizard a fixed `height` when it lives inside a modal or a fixed panel, so the footer stays put and the panel scrolls.

## Don't

- Don't use a wizard for fewer than three steps — that's a form with sections.
- Don't put a wizard inside a wizard.
- Don't hide the Back button. If a step is irreversible, say so in the panel and confirm on Finish.
- Don't let the last step be a form. It should be a review or a confirmation — the user has already made every decision.
