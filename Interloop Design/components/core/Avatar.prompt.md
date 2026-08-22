User avatar showing a photo, or auto-colored initials when no image is set.

```jsx
<Avatar name="Kaiya Septimus" />
<Avatar src="/img/user-01.png" name="Davis Kenter" size={48} status="online" />
<Avatar name="Carla Bator" square />
```

- `src` (image) or `name` (initials + deterministic brand-palette background).
- `size` in px; `square` for rounded-square; `status` = `online｜busy｜away｜offline`; `ring` for overlapping stacks.
