Primary action button in the Interloop brand — use for any clickable command.

```jsx
<Button>Save changes</Button>
<Button variant="secondary">Cancel</Button>
<Button variant="ink" size="lg">Get started</Button>
<Button variant="danger" leadingIcon={<i data-lucide="trash-2" />}>Delete</Button>
<Button loading>Saving…</Button>
```

- `variant`: `primary` (Just Blue) · `ink` (Gray Blue) · `secondary` (outlined) · `ghost` · `danger`
- `size`: `sm` · `md` (default) · `lg`
- `block`, `loading`, `leadingIcon`, `trailingIcon`, `as` (e.g. `as="a"` for links).
