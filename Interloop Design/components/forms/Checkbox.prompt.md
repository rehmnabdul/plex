Checkbox or radio with label and optional description text.

```jsx
<Checkbox label="Email me weekly reports" defaultChecked />
<Checkbox label="Select all" indeterminate />
<Checkbox radio name="plan" label="Annual" description="Save 20%" />
<Checkbox radio name="plan" label="Monthly" />
```

- `radio` switches to a radio button (group with a shared `name`).
- `label`, `description`, `indeterminate`, plus native input props.
