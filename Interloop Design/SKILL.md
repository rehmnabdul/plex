---
name: interloop-design
description: Use this skill to generate well-branded interfaces and assets for Interloop (Interloop Limited — textile & apparel manufacturer), either for production or throwaway prototypes/mocks/etc. Contains essential design guidelines, colors, type, fonts, assets, and UI kit components for prototyping.
user-invocable: true
---

Read the `readme.md` file within this skill, and explore the other available files.

If creating visual artifacts (slides, mocks, throwaway prototypes, etc), copy assets out and create static HTML files for the user to view. If working on production code, you can copy assets and read the rules here to become an expert in designing with this brand.

If the user invokes this skill without any other guidance, ask them what they want to build or design, ask some questions, and act as an expert designer who outputs HTML artifacts _or_ production code, depending on the need.

## Quick map
- `readme.md` — full brand guide: sources, content fundamentals, visual foundations, **engineering target (ABP React)**, iconography, manifest, caveats.
- `styles.css` — global entry point; link this one file to inherit all tokens + fonts.
- `tokens/` — `colors.css`, `typography.css`, `spacing.css`, `base.css` (CSS custom properties).
- `assets/` — official Interloop wordmark + loops insignia, colour and white masters.
- `guidelines/` — foundation specimen cards (colors, type, spacing, brand).
- `components/` — React primitives, each with a `.jsx`, `.d.ts`, `.prompt.md` and a demo `.card.html`:
  - `brand/` — `Logo`
  - `core/` — `Button`, `IconButton`, `Badge`, `Avatar`
  - `forms/` — `Input`, `Select`, `Checkbox`, `Switch`
  - `feedback/` — `Alert`, `ProgressBar`
  - `surfaces/` — `Card`, `StatCard`
  - `navigation/` — `Tabs`, `SidebarNav`, `Wizard`
  - `data/` — `DataGrid`, `SheetGrid` (spreadsheet editor), `ActivityFeed`
  - `documents/` — `ReportDocument` (printable invoice / report)
  - `widgets/` — `Widget`, `Chart`, `DataList`, `StatTile`/`StatGrid`/`ProgressRing`, `MiniTable`
  - `mobile/` — `PhoneFrame`, `MobileShell` family, `MobileList`/`MobileCard`, `TallyPad` family
- `ui_kits/loop-console/`, `ui_kits/order-detail/` — click-through operations screens.
- `_react/` — **the production stack**: the system as a Vite + React + TypeScript SPA on the ABP Modern template (TanStack Router/Query/Table, shadcn/ui on Radix + Tailwind, Zod + RHF, Axios, i18next, Vitest). `/design-system` renders every ported component live.

## Engineering target
The consuming app is the **React SPA of an ABP.IO Modern-template solution** (https://abp.io/docs/10.4/framework/ui/react) — not a themed admin template. Shipped components follow the **shadcn/ui** API restyled with Interloop tokens; new variants extend shadcn's set rather than renaming it. See `readme.md` → ENGINEERING TARGET for the mapping and the ported/not-ported list.

## Brand in one breath
Gray Blue `#333B4A` ink + Just Blue `#30A8E0` accent on Pure White; Earth/Water/Air/Sun secondary tints. Clean humanist-geometric sans (Avenir → Mulish), bold tight headlines, calm body. Soft cool-tinted shadows, 12px card radius, quiet fast motion, no emoji. Tone: warm, responsible, transparent. Tagline cadence: "Together we succeed."

> Caveats: the logo and fonts are stand-ins (see `readme.md` → Caveats). Ask the user for official artwork and licensed font files before production use.
