The workhorse surface — wraps any panel of content, with an optional header and footer.

```jsx
<Card title="Active Users" subtitle="Updated 5m ago"
      actions={<IconButton label="More"><i data-lucide="more-horizontal" /></IconButton>}>
  …content…
</Card>

<Card flush>{/* table with no body padding */}</Card>
<Card elevation="raised" hover>{/* lifts on hover */}</Card>
```

- `title`/`subtitle`/`actions` render the header; `footer` renders the footer.
- `elevation`: `flat｜sm｜raised`. `flush` removes body padding. `hover` lifts on hover.
