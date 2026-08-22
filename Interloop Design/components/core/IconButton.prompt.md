Icon-only square button — toolbar/table/topbar actions where a label would be redundant.

```jsx
<IconButton label="Search"><i data-lucide="search" /></IconButton>
<IconButton variant="solid" label="Add"><i data-lucide="plus" /></IconButton>
<IconButton variant="outline" size="sm" label="More"><i data-lucide="more-horizontal" /></IconButton>
```

- `variant`: `ghost` (default) · `solid` (Just Blue) · `outline`
- `size`: `sm` · `md` · `lg`
- Always pass `label` for accessibility. Put a Lucide `<i data-lucide>` or `<svg>` inside.
