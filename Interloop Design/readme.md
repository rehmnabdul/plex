# Interloop Design System

A brand-faithful design system for **Interloop Limited** — a vertically-integrated, multi-category textile & apparel manufacturer (hosiery, denim, knitted apparel, seamless activewear, yarns) headquartered in Faisalabad, Pakistan, with a global footprint across the USA, Netherlands, China, Japan and Sri Lanka.

This system translates Interloop's **2023 Brand Guidelines** into reusable web foundations, components, admin/operations UI kits and a shop-floor mobile kit.

**Engineering target: the ABP.IO Modern template's React UI** (https://abp.io/docs/10.4/framework/ui/react) — Vite, React + TypeScript, TanStack Router / Query / Table, **shadcn/ui on Radix UI + Tailwind CSS**, Zod + React Hook Form, Axios, i18next with ABP localization keys, Vitest, OIDC PKCE. The reference implementation of this system on that stack lives in [`_react/`](_react/README.md). Component APIs follow **shadcn/ui**, restyled with Interloop tokens — not a third-party admin theme.

---

## Sources

| Source | What it gave us | Access |
|---|---|---|
| `uploads/brand manual.pdf` | Interloop Brand Guidelines 2023 (44 pp) — about, tone of voice, logo, insignia, color palette, typography, brand pattern, iconography, stationery. **Primary source of truth.** | In project |
| `uploads/colors.pdf`, `uploads/colors2.pdf` | Color reference sheets — **image-only PDFs, no extractable text.** All color values were taken from the brand manual (Section A05) instead. | In project |
| https://interloop-pk.com/ | Public brand site — logo, tone, imagery direction. | Public web |
| https://abp.io/docs/10.4/framework/ui/react | **ABP React (Modern template)** — the engineering target: stack, source-owned shadcn/ui components, API modules, routing, localization, testing conventions. | Public web |
| https://ui.shadcn.com | shadcn/ui — the component API this system conforms to (variant names, composition, Radix primitives). | Public web |

> ⚠️ **Logo & fonts are stand-ins.** The official Interloop logo artwork (EPS/AI/PNG/SVG) and the licensed typefaces (Avenir, Brandon Grotesque, Novecento, Baskerville MT) live with Interloop Corporate Communications and could not be embedded here. See **Caveats** at the bottom.

---

## About the brand (from the manual)

> "Our identity is the visual and verbal expression of our brand… elements [that] express a brand that is human, conscious, and deeply connected to the world around it whilst reflecting a sense of responsibility and trust."

- **What they do:** multi-category manufacturer of hosiery, denim, knitted apparel and seamless products; "Full Family Clothing" partner of choice.
- **Mission:** "To be an agent of positive change for the stakeholders and community by pursuing an ethical and sustainable business."
- **Approach:** triple-bottom-line sustainability — **People, Planet, Prosperity.**
- **Values — ICARE:** Integrity, Care, Accountability, Respect & Excellence.
- **The logo story:** captures the company's origin in *circular knitting and the interlooping of yarn*; the insignia's "Looped O's" symbolise the links formed between each business venture.

---

## CONTENT FUNDAMENTALS

How Interloop writes and speaks.

**Tone of voice (manual, Section A02).** The brand's defined character / tone words: *Inspiring, Warm, Responsible, Transparent, Efficient, Honest, Inclusive, Approachable, Conscious.* Its three purpose verbs: **Engage, Inform, Lead by example.** Everything should "sound like it's coming from the same place."

**Person & address.** Corporate, collective **"we / our"** when speaking as Interloop ("Our commitment to sustainability…"). Addresses stakeholders and partners directly as **"you"** in relational contexts. Warm but professional — never slangy, never hype.

**Casing.**
- Headlines & section titles: **Title Case** or sentence case; section dividers in the manual use ALL-CAPS labels (e.g. `COLOR PALETTE`, `LOGO USAGE`) as eyebrows above a Title-Case heading.
- Body: sentence case.
- All-caps is reserved for short eyebrows/labels and the wordmark context — never for long body copy.

**Vocabulary & themes.** Leans on sustainability and partnership language: *responsible manufacturing, traceability, transparency, value chain, stakeholders, partner of choice, agility, digital transformation, ethical, efficiency.* Avoids jargon overload — "puts the message across without being overbearing."

**Emoji:** **Not used.** The brand is corporate-industrial; communication is clean and word/figure-driven. Do not introduce emoji.

**Examples (manual voice):**
- *"We are moving forward with strength and dynamism."*
- *"Whether it's the people or the planet, our goal is to ensure that our stakeholders… are respectful and caring."*
- *"Interloop is the sum of all the little efforts you have made, day in and day out. Together we succeed."*
- Sign-off / tagline cadence: **"Together we succeed."**

**For product/admin UI copy** (the UI kit): keep it plain, instructional and quiet — "Active Users", "Monthly Goal", "Due in 1 week". Numbers and labels do the talking; no exclamation marks, no marketing fluff inside operational tools.

---

## VISUAL FOUNDATIONS

The visual DNA of the Interloop brand, as applied to screen/UI.

### Color
- **Primary anchors:** **Gray Blue `#333B4A`** (the corporate ink — used for primary text, dark surfaces, the wordmark) and **Just Blue `#30A8E0`** (the single primary accent — links, primary buttons, active states), on **Pure White `#FFFFFF`**.
- **Secondary "elements" palette** — four nature-coded tints meant for *graphic elements, highlights and gradients*, each conceived as a **gradient to white**: **Earth** (green `#AED250`), **Water** (light blue `#66C8F2`), **Air** (teal `#6DB7B7`), **Sun** (warm peach `#F9A571`). Flat variants exist for solid fills (`#C6DB72 / #7FD3F1 / #6DB7B7 / #F6B997`).
- **Mapping to status:** Earth→success, Just Blue/Water→info, Sun→warning. The manual has **no red**, so a harmonious danger red `#E2574C` is **derived** (flagged) for destructive UI states only.
- **Derived ramps:** the manual gives single anchor swatches; the 50–950 Gray Blue and Blue ramps in `tokens/colors.css` are interpolated (oklch-tuned) from those anchors for UI needs (borders, hovers, surfaces). Anchor steps (`-700` blue-ink, `-500` blue) match the manual exactly.
- **Vibe of imagery:** the brand pairs cool blues/teals with warm peach/green accents — **clean, optimistic, daylight, slightly cool.** Photography is human + industrial (mills, workers, yarn, sustainability). Not moody, not high-grain.

### Typography
- **Primary:** **Avenir** — Black for headlines, Medium for body. Clean, modern humanist-geometric sans. → substituted with **Mulish**.
- **Emphasis:** **Brandon Grotesque Bold Italic** for subheads / emphasis. → substituted with **Montserrat** (bold italic).
- **Logotype:** **Novecento Bold** (geometric caps) for sub-brand/division lockups.
- **Formal documents:** **Baskerville MT Std** (serif) for letterheads/admin docs. → substituted with **Libre Baskerville**.
- **Declared fallback:** Segoe UI Bold / Regular for external recipients without the licensed faces.
- Headlines are **bold/black & tight**; body is calm and readable. All-caps used only for short eyebrows (wide tracking).

### Spacing & layout
- **4px base grid.** Generous white space — the manual is airy and uncluttered.
- **Logo placement rules:** logo sits top-left or bottom-right of a canvas (center only in special cases), with clear space = the height of the "E" in the logo on all sides. Reflected in our layout: brand mark anchors the sidebar top-left.
- **Containers** max ~1320px; admin shell is a fixed 264px sidebar + 64px topbar.

### Surfaces, cards & elevation
- **Cards:** white, **12px radius**, hairline `#E9EBEF` border, **soft low-contrast cool-tinted shadow** (shadows are tinted with the Gray Blue `51,59,74` rather than pure black). No heavy drop shadows.
- **Page background:** very light cool gray `#F4F5F8` (not pure white) so white cards lift off it.
- **Corner radii:** 8px buttons/inputs, 12px cards, 16px large panels, pill for badges/avatars.

### Borders, dividers
- Hairlines in `#E9EBEF`/`#D4D8DF`. Borders are subtle; structure comes from spacing and elevation more than lines.

### Motion
- **Quiet and functional.** Fast (120–200ms) ease-out transitions for hover/press; gentle fades and small translateY rises for entrances. **No bounce, no flashy decorative loops.** Reflects "efficient, responsible."

### Hover / press states
- **Hover:** primary buttons darken one step (`#30A8E0`→`#2492C8`); ghost/secondary get a faint `#F4F5F8` surface fill; links go to `#2492C8`.
- **Press:** darken a further step + subtle scale-down (`transform: scale(0.98)`); no color inversion.
- **Focus:** 3px Just-Blue glow ring (`--ring`), never a hard outline.

### Brand pattern & texture
- The manual defines a **brand pattern** built from the interlooping-loop motif — "created to reflect Interloop's growth… how each of its separate units work together." Used as space-holders / to add weight to a region, rendered in any brand color. In UI, treat as an optional decorative texture on hero/empty/auth surfaces — sparingly, low-opacity, never behind dense text. (Not bundled as an asset here; recreate from the loop motif if needed.)

### Transparency & blur
- Used lightly — soft overlays on modals (`rgba(51,59,74,.45)`), occasional tint washes (`*-soft` tokens) behind badges and status chips. No heavy glassmorphism.

---

## ENGINEERING TARGET — ABP React (Modern template)

The consuming application is the **React SPA of an ABP.IO Modern-template solution**, not a themed admin template. That decides the API of everything here.

| Concern | Technology |
|---|---|
| Build | Vite |
| UI | React + TypeScript (strict) |
| Routing | TanStack Router — `src/routes/router.tsx`, `beforeLoad` guards |
| Server state | TanStack Query — queries + mutation invalidation |
| Components | **shadcn/ui** primitives on Radix UI + Tailwind CSS, source-owned in `src/components/ui/` |
| Tables | TanStack Table + TanStack Virtual |
| Forms | React Hook Form + Zod (`zodResolver`, `z.infer`) |
| HTTP | Axios — one shared instance, endpoints written without the `/api` prefix |
| Localization | i18next with ABP resource keys (`Resource::Key`) |
| Auth | OIDC Authorization Code + PKCE |
| Testing | Vitest + Testing Library |

**Reference implementation:** [`_react/`](_react/README.md) — the whole system running on that stack, with `/design-system` rendering every ported component live. (The leading underscore keeps the folder out of this design system's compiler; rename it to `react/` in the target repo.)

### Two surfaces, one system

| Surface | What it is | API |
|---|---|---|
| `components/`, `ui_kits/` (this project) | Design source of truth — specimens, states, usage prompts | House JSX API |
| `_react/src/components/` | What engineering ships | **shadcn/ui API**, restyled with Interloop tokens |

Tokens are the contract between them. `_react/src/styles/globals.css` maps Interloop's `--il-*` ramps onto shadcn's own variable names (`--primary`, `--muted-foreground`, `--border`…), so `npx shadcn@latest add <component>` arrives already wearing Interloop's clothes — no manual restyling, no drift.

### Where the APIs differ

Ported components keep **shadcn's** prop names; the house API is the specimen, shadcn is the shipped contract.

| This project | `_react/` | Note |
|---|---|---|
| `<Badge color="success">` | `<Badge variant="success">` | shadcn uses `variant` throughout |
| `<Button variant="primary">` | `<Button variant="default">` | `ink`, `success`, `warning` are Interloop extensions, added not substituted |
| `<Alert variant="danger">` | `<Alert variant="destructive">` | shadcn's semantic name |
| `<ProgressBar>` | `<Progress>` | Radix primitive name |
| `<DataGrid columns rows>` | `<DataGrid columns data>` on TanStack Table | `ColumnDef` + `meta` replace the house column object |

### Ported vs. not

**Ported to `_react/`:** Logo, Button, IconButton, Badge, Avatar, Card, StatCard, Input, Select, Checkbox, Switch, Alert, Progress, Tabs, SidebarNav, Separator, Skeleton, Popover, DropdownMenu, DataGrid, ActivityFeed, ReportDocument, plus the Orders and Order Detail screens and a `/design-system` gallery.

**Design-only so far** — specimens exist here, no TSX yet: `Wizard`, `SheetGrid`, the widget kit (`Widget`, `Chart`, `DataList`, `StatTile`/`StatGrid`/`ProgressRing`, `MiniTable`) and the mobile kit (`PhoneFrame`, `MobileShell` family, `MobileList`/`MobileCard`, `TallyPad` family).

### Rules for new components

1. **Check shadcn/ui first.** If a primitive exists there, adopt its API and restyle it — do not invent a parallel one.
2. **Extend, don't substitute.** New variants are additions to shadcn's set (`ink`, `success`, `warning`), never renames of it.
3. **Radix underneath** anything with interaction semantics — menus, dialogs, tabs, selects, checkboxes.
4. **Tokens, never literals.** Style through the CSS variables in `globals.css`; a hex in a component is a bug.
5. **Ship the pair.** A component is done when the specimen here and the TSX in `_react/` agree, with Vitest coverage.

---

## ICONOGRAPHY

Interloop uses **two distinct icon registers**:

1. **Brand / thematic icons (marketing).** The manual (Section A08) defines a set of *concept* icons — Leadership, Eco Footprint, Traceability, Sustainability, Equality/Equity, Teamwork, Waste Recycling, Partnership, Water Saving, Solar Energy, Organic Cotton, Value-added Services, Time Management, etc. These are **line-style, single-weight, conceptual** symbols used to "convey big ideas without a single word" across the website and marketing collateral. They are illustrative, not UI controls.

2. **UI icons (product / admin).** For interface controls the design system uses **Lucide** (https://lucide.dev) — a clean, consistent **1.75–2px stroke, rounded-join** open-source set that matches the brand's clean-modern feel and the Lepton-X reference. Loaded from CDN in the UI kit and component cards:
   ```html
   <script src="https://unpkg.com/lucide@latest"></script>
   <script>lucide.createIcons();</script>
   ```
   > **Substitution flag:** Lucide stands in for Interloop's bespoke thematic icon set, which is not distributed in vector form here. Match its single-weight line style if you commission brand icons.

**Emoji / unicode as icons:** not used. **No emoji anywhere.** Stick to Lucide line icons for UI and the loop insignia for brand moments.

**Assets present** (`assets/`):
- `interloop-logo.svg` / `interloop-logo-white.svg` — official "INTERLOOP" wordmark lockup (original colors / inverse).
- `interloop-mark.svg` / `interloop-mark-white.svg` — the interlocking looped-O insignia, cropped from the official wordmark.
- The `Logo` component renders this artwork inline, tone-aware (`color` / `inverse` / `mono`).

---

## INDEX / MANIFEST

**Root**
- `styles.css` — global entry point (imports only). Consumers link this.
- `readme.md` — this guide.
- `SKILL.md` — Agent-Skill front-matter wrapper for use in Claude Code.

**`tokens/`** — `colors.css`, `typography.css`, `spacing.css`, `base.css`.

**`assets/`** — logo/insignia SVGs.

**`guidelines/`** — foundation specimen cards (Design System tab): colors, type, spacing, elevation, brand.

**`components/`** — reusable React primitives (each: `.jsx`, `.d.ts`, `.prompt.md`, one `@dsCard` html):
- `brand/` — `Logo`
- `core/` — `Button`, `IconButton`, `Badge`, `Avatar`, `Card`, `StatCard`
- `forms/` — `Input`, `Select`, `Checkbox`, `Switch`; enterprise controls: `Combobox` (searchable), `MultiSelect`, `TagInput`, `DateField` (date · datetime · time), `DateRangeField`, `LookupField` (grid picker), `RangeSlider`, `SplitButton`
- `feedback/` — `Alert`, `ProgressBar`
- `navigation/` — `Tabs` (+ `TabPanel`) — ARIA keyboard tabs, line/pill/enclosed/vertical, overflow scrolling; `SidebarNav` — nested groups, collapsible rail with flyouts, filter; `Wizard` (+ `WizardStepHeader`, `WizardOptions`, `WizardOptionCard`, `WizardDone`) — horizontal & vertical multi-step forms
- `mobile/` — shop-floor kit: `PhoneFrame`, `MobileShell` (app root) + `MobileAppBar` / `MobileAction` / `MobileScreen` / `MobileSectionLabel` / `MobileTabBar` / `MobileSheet` / `MobileButton`, `MobileList` / `MobileCard`, `TallyPad` / `MobileStepper` / `MobileSegmented` / `SyncStatus` / `PhotoCapture` — sized for gloves, built offline-first. Tablet tier: `TabletFrame`, `TabletRail`, `TabletToolbar`, `SplitView` / `SplitDetailBody` — the 11-inch master–detail console
- `data/` — `DataGrid` (grouping, column filters, show/hide, pinning, virtualised rows, server-side paging), `SheetGrid` (spreadsheet editor — typed cell editors, frozen columns, copy/paste, fill, undo, validation), `ActivityFeed` (date-grouped audit timeline)
- `widgets/` — dashboard kit: `Widget` (shell), `Chart` (enterprise-BI marks: line · area · bar · stacked · 100% · hbar · combo dual-axis · scatter · bullet · heatmap · trellis · donut · pie · radial · spark, with reference lines and bands), `DataList` (ranked / people / icon / swatch / check), `StatTile` + `StatGrid` + `ProgressRing`, `MiniTable` (+ `TableStatus`, `TableIdentity`, `TableBar`), `GanttChart` (roll-up phases, dependencies, baselines, milestones, critical path), `Calendar` (month · week · day · agenda scheduling)
- `documents/` — `ReportDocument` (printable invoice / inspection-report sheet)

**`ui_kits/loop-console/`** — "Loop Console", an Interloop-branded operations/admin dashboard (login → dashboard → data table flow). `index.html` + screen JSX.

**`ui_kits/order-detail/`** — Order detail (Time &amp; Action) screen: PO facts, grouped product grid, production-stage matrix, milestone tracker, activities rail.

**`_react/`** — the whole system as a runnable **Vite + React + TypeScript SPA** on the ABP Modern template stack (TanStack Router/Query/Table, shadcn/ui on Radix + Tailwind v4, Zod + React Hook Form, Axios, i18next with ABP keys, Vitest). Tokens live in `_react/src/styles/globals.css`; `/design-system` renders every component live. The leading underscore keeps the folder out of this design system's compiler — see `_react/README.md`.

See the **Design System** tab for all rendered specimen & component cards.

---

## CAVEATS  →  please help us make this perfect

1. **✅ Logo — official wordmark now in.** The Interloop "INTERLOOP" wordmark (with the interlocking looped O's) was provided and is wired into `assets/` (`interloop-logo.svg` original colors, `interloop-logo-white.svg` inverse) and the `Logo` component (inline, tone-aware). The loops-only insignia (`interloop-mark*.svg`) is cropped from the same artwork. *Note: only the white master was supplied — the "original colors" version (Gray Blue letters + Just Blue loops) is my reconstruction of the brand colors; confirm against the official color master, and send the division-logo variants if you need them.*
2. **🔴 Licensed fonts substituted.** Avenir→Mulish, Brandon Grotesque→Montserrat, Baskerville MT→Libre Baskerville (all Google Fonts, CDN-loaded). **Please provide the licensed `.woff2`/`.ttf` files** and I'll add real `@font-face` rules and bundle them.
3. **Danger red is derived.** `#E2574C` isn't in the manual; confirm or replace.
4. **Brand pattern** is described but not provided as an asset — let me know if you want it recreated from the loop motif.
5. **UI-kit product is interpreted.** "Loop Console" is a plausible internal ops tool. If you have a real Interloop product (traceability portal, HRIS, etc.) with screenshots or code, share it and I'll recreate it faithfully.
