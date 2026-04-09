# Frontend rules (app/javascript/vocare/)

Applies when working on any file in this directory.

## Vite + React

- Do NOT add `@vitejs/plugin-react` — use esbuild JSX transform (via vite-plugin-ruby)
- **Any file containing JSX must be `.jsx`** — esbuild ignores JSX in `.js` files. This includes hooks that return JSX (e.g. context providers).
- Never `.tsx` — project uses plain `.jsx`
- Import React explicitly in every component file: `import React from 'react'`
- Use `useApi.js` hook for all fetch calls — handles CSRF tokens automatically
- Use React Router (`react-router-dom`) for client-side routing
- `postcss.config.js` uses `export default` (ES module), NOT `module.exports` — package.json has `"type": "module"`

## Tailwind (Dark Theme)

- Background: `bg-[#0A0A0A]` or use CSS custom properties
- All text defaults to white. Use `text-[#A0A0A0]` for secondary text
- Gold accent: `text-[#E5A04B]` or `bg-[#E5A04B]` for CTAs
- No `dark:` variants needed — the entire app is dark
- Only use Tailwind core utility classes — no custom CSS unless unavoidable

## Component Rules

- All components are functional with hooks. No class components
- Danish UI text. Hardcoded Danish strings are OK for MVP (i18n later)
- Font: Inter for body, Playfair Display for headings (loaded via Google Fonts in layout)
- Keep components focused: one component per file, one concern per component

## MasterClass-Inspired Design

- Full-bleed video player (no surrounding chrome)
- Dark backgrounds everywhere
- Gold accent for primary actions and progress
- Serif font for headings gives editorial/premium feel
- Minimal animations — subtle fades and transitions only
