# Vocare Courses — Backlog

## Future Features (Not in MVP)

- Multiple courses support
- Email notifications (welcome, quiz results, reminders)
- Certificate generation on course completion
- Discussion/comments per lesson
- Mobile app (React Native)
- Payment integration (Stripe)
- User registration (email/password instead of token-only)
- Course analytics dashboard (admin)
- Video watch-time analytics
- Downloadable resources per lesson
- Bookmarking / note-taking
- A/B test different quiz prompts for better AI evaluation

## Deferred Decisions

- Whether to add ActionCable for real-time quiz result delivery (currently polling)
- Whether to add a rich text editor for admin content management (currently plain text/HTML)
- Whether customers should be able to update their profile after creation

---

## Lessons Learned

### HAML + Tailwind: colon classes break HAML parsing

Tailwind responsive/pseudo classes with colons (`md:grid-cols-3`, `hover:bg-gray-50`) are interpreted as Ruby method calls by HAML when used in the dot-notation shorthand.

```haml
-# WRONG — HAML treats colon as Ruby syntax
.grid.grid-cols-1.md:grid-cols-3.gap-6
%tr.hover\:bg-gray-50   -# Escaped colon breaks nesting

-# CORRECT — use hash attribute syntax for any class with colons
%div{ class: "grid grid-cols-1 md:grid-cols-3 gap-6" }
%tr{ class: "hover:bg-gray-50 transition-colors" }
```

**Rule:** Any HAML element with Tailwind pseudo/responsive classes (`hover:`, `md:`, `lg:`, `focus:`, `peer-checked:`) MUST use the `{ class: "..." }` hash syntax. Never use dot-notation or backslash escaping for these.

### HAML + Tailwind: decimal classes break HAML parsing

Tailwind classes with decimals (`px-3.5`, `py-2.5`, `gap-1.5`) are parsed by HAML as nested class selectors (`.5` becomes a separate class).

```haml
-# WRONG — HAML reads .5 as a separate class
%input.px-3.5.py-2.5

-# CORRECT — use hash syntax or whole numbers
%input{ class: "px-3.5 py-2.5" }
= f.email_field :email, class: "px-4 py-3"   -# better: just use whole numbers
```

**Rule:** Prefer whole-number spacing (`px-4 py-3`) in HAML. If decimals are needed, use `{ class: "..." }` or pass via the `class:` attribute on Rails helpers.

### Vite + ESM: PostCSS config must use ES module syntax

When `package.json` has `"type": "module"`, `postcss.config.js` must use `export default` not `module.exports`. Otherwise Vite build fails with "module is not defined in ES module scope".

```javascript
// WRONG
module.exports = { plugins: { ... } }

// CORRECT
export default { plugins: { ... } }
```

### Vite + esbuild: JSX requires .jsx extension

Files containing JSX (React components, context providers with JSX returns) MUST have the `.jsx` extension. The `.js` extension with JSX content causes "Unexpected JSX expression" build errors because esbuild only processes `.jsx` files for JSX syntax.

**Rule:** If a file contains `<Component>` or returns JSX, it must be `.jsx`.

### Admin layout: separate CSS entrypoint

The admin and student apps need separate CSS entrypoints to avoid theme bleeding. The student `application.css` sets dark `body` styles that override admin Tailwind classes.

- Student: `entrypoints/application.css` (dark theme with custom color variables)
- Admin: `entrypoints/admin.css` (plain Tailwind, no body overrides)
- Admin layouts use `= vite_stylesheet_tag "admin.css"` instead of `application.jsx`

### Admin design: consistent gray-900 color scheme

Admin uses a monochrome gray palette — no blue buttons. All interactive elements use `bg-gray-900` (buttons), `focus:ring-gray-900` (inputs), `rounded-2xl` (cards), `rounded-xl` (inputs/buttons). Status badges use soft pills: emerald for success, amber for warning, red for error.
