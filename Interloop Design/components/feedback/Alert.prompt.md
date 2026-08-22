Inline contextual banner for confirmations, warnings and errors.

```jsx
<Alert variant="success" title="Saved" onClose={() => {}}>
  Your changes have been published.
</Alert>
<Alert variant="warning">Your certification expires in 30 days.</Alert>
<Alert variant="danger" title="Upload failed">Check the file format and retry.</Alert>
```

- `variant`: `info` (default) · `success` · `warning` · `danger` (each has its own icon).
- `title` optional; pass the message as children. `onClose` adds a dismiss button.
