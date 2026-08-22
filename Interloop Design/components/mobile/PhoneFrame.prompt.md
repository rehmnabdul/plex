# PhoneFrame

Device shell for showing a mobile screen in context — design-system cards, design reviews, handoff docs. **Presentation only; never ship it around a real screen.** See `MobileShell.prompt.md` for the mobile system's rules.

```jsx
<PhoneFrame caption="Inspection queue" captionNote="Offline, 3 queued" scale={0.8}>
  …app bar, screen, tab bar…
</PhoneFrame>
```

- Defaults to 390×844 (iPhone-class). Pass `width` / `height` for a tablet or a rugged handheld.
- `scale` renders smaller so several phones fit one page, and reserves the right space so the layout doesn't collapse.
- `flat` drops the bezel and notch for a plain rounded viewport — better in dense documentation.
- `dark` for the low-light floor theme.
