Horizontal progress / completion bar for goals, capacity and uploads.

```jsx
<ProgressBar value={68} label="Monthly goal" showValue tone="earth" />
<ProgressBar value={45} size="sm" />
<ProgressBar value={92} tone="danger" label="Storage used" showValue />
```

- `value`/`max` set fill; `label` + `showValue` add the header row.
- `size`: `sm｜md｜lg`. `tone`: `blue｜earth｜air｜sun｜danger`.
