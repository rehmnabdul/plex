Labeled text input with hint/error states and optional inline icons.

```jsx
<Input label="Email" type="email" placeholder="name@interloop.com.pk" required />
<Input label="Search orders" leadingIcon={<i data-lucide="search" />} />
<Input label="Password" type="password" error="Must be at least 8 characters" />
```

- `label`, `hint`, `error` (red state), `required`.
- `leadingIcon` / `trailingIcon` accept Lucide `<i data-lucide>` or `<svg>`.
- Forwards all native `<input>` props.
