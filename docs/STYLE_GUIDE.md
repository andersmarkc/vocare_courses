# Vocare Courses — Style Guide

## Design Inspiration

MasterClass: dark, cinematic, premium feel. Clean typography. Full-bleed video. Minimal chrome.

---

## Color System

### Student App (Dark Theme)
```
Background:      #0A0A0A  (near black)
Surface:         #1A1A1A  (cards, sidebar)
Surface Light:   #2A2A2A  (hover states, borders)
Accent/Gold:     #E5A04B  (CTAs, progress indicators, active states)
Accent Hover:    #D4903A  (button hover)
Text Primary:    #FFFFFF  (headings, body)
Text Secondary:  #A0A0A0  (descriptions, timestamps)
Text Muted:      #666666  (disabled states)
Success:         #4ADE80  (completed sections, passed quizzes)
Error:           #EF4444  (failed quizzes, errors)
Locked:          #525252  (locked sections, disabled buttons)
```

### Admin Dashboard (Light Theme — monochrome gray)
```
Background:      gray-50   (page background)
Surface:         white     (cards, tables)
Borders:         gray-200  (card borders, input borders)
Buttons:         gray-900  (primary), hover: gray-800
Input Focus:     ring-gray-900, border-gray-900
Text Primary:    gray-900
Text Secondary:  gray-500
Text Muted:      gray-400
Labels:          gray-400 uppercase tracking-wider text-xs
Success badge:   emerald-50/emerald-600 rounded-full pill
Warning badge:   amber-50/amber-600 rounded-full pill
Error badge:     red-50/red-600 rounded-full pill
Card radius:     rounded-2xl
Input radius:    rounded-xl
```
**No blue anywhere in admin.** All buttons, focus rings, and accents use gray-900.
Admin uses its own CSS entrypoint (`admin.css`) — never loads student dark theme.

---

## Typography

### Fonts
- **Headings:** Playfair Display (serif) — premium, editorial feel
- **Body:** Inter (sans-serif) — clean, readable
- Load via Google Fonts in the HAML layout `<head>`

### Scale (Student App)
```
Hero heading:    text-5xl font-serif font-bold    (login page only)
Page heading:    text-3xl font-serif font-bold
Section heading: text-xl font-semibold
Body:            text-base
Small/Meta:      text-sm text-secondary
Caption:         text-xs text-muted
```

---

## Component Patterns

### Cards (Section/Lesson)
- Dark surface background (`#1A1A1A`)
- Subtle border (`border border-white/10`)
- Rounded corners (`rounded-xl`)
- Hover: slight brightness increase or border glow

### Buttons
- Primary: gold background, dark text (`bg-accent text-black font-semibold rounded-lg px-6 py-3`)
- Secondary: transparent with white border (`border border-white/20 text-white`)
- Disabled: gray background, muted text

### Progress Indicators
- Circular progress: gold stroke on dark background (dashboard)
- Linear bar: gold fill (`bg-accent`) on dark track (`bg-surface-light`)
- Fraction display: `15/38` style (like MasterClass)

### Video Player Area
- Full-width, 16:9 aspect ratio
- Dark background behind player
- No visible chrome when playing (minimal controls)

### Sidebar (Lesson Page)
- Fixed width, dark surface background
- Lesson list with completion checkmarks (green) or lock icons (gray)
- Current lesson highlighted with gold accent border

---

## Spacing

- Page padding: `px-6 md:px-12 lg:px-24`
- Section gaps: `space-y-8` or `gap-8`
- Card padding: `p-6`
- Compact spacing: `space-y-2` or `gap-2`

---

## Responsive Breakpoints

- Mobile: `< 768px` — single column, no sidebar, stacked layout
- Tablet: `768px - 1024px` — sidebar collapses to overlay
- Desktop: `> 1024px` — full layout with sidebar

---

## Icons

Use Heroicons (outline style) via inline SVG in React components. Keep icons small (`w-5 h-5`).

- Completed: `CheckCircleIcon` (green)
- Locked: `LockClosedIcon` (gray)
- Video: `PlayCircleIcon`
- Audio: `MusicalNoteIcon`
- Text: `DocumentTextIcon`
- Quiz: `AcademicCapIcon`

---

## Animation

Minimal animations. No flashy transitions.
- Page transitions: subtle fade (`opacity` transition, 150ms)
- Progress updates: smooth width transition on bars (300ms ease)
- Card hover: `transition-colors duration-150`

---

## HAML Tailwind Gotchas

**CRITICAL:** Tailwind classes with colons or decimals break HAML dot-notation syntax.

```haml
-# NEVER do this:
.md:grid-cols-3           -# HAML reads colon as Ruby
%tr.hover\:bg-gray-50     -# Escaped colon breaks nesting
%input.px-3.5             -# HAML reads .5 as a class

-# ALWAYS do this instead:
%div{ class: "md:grid-cols-3" }
%tr{ class: "hover:bg-gray-50" }
%input{ class: "px-3.5" }     -# or just use px-4
```

Use `{ class: "..." }` hash syntax for ANY class containing `:` or `.` followed by a number.
