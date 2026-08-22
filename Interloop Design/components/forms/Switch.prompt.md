Toggle switch for instant on/off settings (autosave, notifications, dark mode).

```jsx
<Switch label="Email notifications" defaultChecked />
<Switch label="Compact rows" size="sm" />
```

- `size`: `sm` · `md` (default). Forwards native checkbox props (`checked`, `onChange`, …).
- Use for settings that apply immediately; use `Checkbox` for form selections that submit.
