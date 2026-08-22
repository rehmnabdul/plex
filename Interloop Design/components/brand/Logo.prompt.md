The Interloop logo lockup (insignia + wordmark) — use anywhere the brand identity appears: app headers, sidebars, auth screens, footers.

```jsx
<Logo />                              {/* full color lockup */}
<Logo variant="mark" size={32} />      {/* just the loop insignia */}
<Logo tone="inverse" />                {/* on a dark surface */}
<Logo tone="mono" style={{ color: 'var(--il-grayblue-700)' }} /> {/* single-color print */}
```

- `variant`: `full` (default, the whole lockup) · `mark` (just the interlocking looped O's) · `wordmark` (same as full)
- `tone`: `color` (default — Gray Blue letters, Just Blue loops) · `inverse` (white, for dark bg) · `mono` (inherits `currentColor`)
- `size`: lockup height in px (width scales 150:26; `mark` scales 38:26).

Uses the official Interloop wordmark artwork, rendered inline as SVG paths (portable, no asset dependency).
