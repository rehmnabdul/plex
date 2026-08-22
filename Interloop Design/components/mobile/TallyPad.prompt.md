# TallyPad · MobileStepper · MobileSegmented · SyncStatus · PhotoCapture

The data-entry controls. See `MobileShell.prompt.md` for the system rules.

**Never make a number a text field where one of these will do.** A keyboard on the floor is slow, error-prone, and half-covered by a glove.

```jsx
<TallyPad
  items={[
    { key: 'skew', label: 'Skewness', severity: 'Major' },
    { key: 'slub', label: 'Slub / neps', severity: 'Minor' },
  ]}
  values={counts}
  onChange={(key, value, all) => setCounts(all)}
  criticalAt={5}
/>
```

- `criticalAt` turns a tile red once the count reaches the limit — the operator sees the lot failing as it happens, not at sign-off.
- `MobileStepper` for a single quantity; `TallyPad` when several codes are counted together.
- `MobileSegmented` for the verdict. `kind: 'pass' | 'fail' | 'hold'` supplies the icon and the semantic colour, so the choice reads without colour vision.

```jsx
<MobileSegmented
  value={verdict} onChange={setVerdict}
  options={[
    { value: 'pass', label: 'Pass', kind: 'pass' },
    { value: 'hold', label: 'Hold', kind: 'hold' },
    { value: 'fail', label: 'Fail', kind: 'fail' },
  ]}
/>
```

`SyncStatus` is permanent, directly under the app bar: `synced` · `syncing` · `offline` · `error`, with the outbox depth. `PhotoCapture` gives fixed evidence slots so the required photo count is visible before the operator starts, not enforced after.
