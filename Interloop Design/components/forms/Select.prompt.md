Styled native `<select>` with the brand chevron.

```jsx
<Select label="Division" placeholder="Choose…"
  options={['Hosiery', 'Denim', 'Apparel', 'Yarns']} />

<Select label="Status" options={[
  { value: 'active', label: 'Active' },
  { value: 'paused', label: 'Paused' },
]} />
```

- Pass `options` (strings or `{value,label}`) or your own `<option>` children.
- `label`, `placeholder`, plus all native `<select>` props.
