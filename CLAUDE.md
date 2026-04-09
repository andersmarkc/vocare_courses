# Vocare Courses

Danish B2B phone sales training platform. MasterClass-inspired design. Token-based student access, AI-graded quizzes.

Run `/start` at the beginning of every session before writing any code.

---

## Quick reference

| What | Where |
|---|---|
| What we're building, current phase | @docs/PROJECT.md |
| Business context + course philosophy | @docs/BUSINESS.md |
| Business concepts + data model | @docs/DOMAIN.md |
| Directory structure + service patterns | @docs/ARCHITECTURE.md |
| Visual design + dark theme specs | @docs/STYLE_GUIDE.md |
| Testing patterns + WebMock stubs | @docs/TESTING.md |
| Future items + deferred decisions | @docs/BACKLOG.md |

Subdirectory CLAUDE.md files load automatically when you work in those directories:
- `app/javascript/vocare/CLAUDE.md` — React, Vite, Tailwind dark theme rules
- `app/services/CLAUDE.md` — service client pattern, Faraday wrappers
- `app/services/ai/CLAUDE.md` — OpenAI quiz evaluation, Danish prompts
- `app/models/CLAUDE.md` — model conventions, enum patterns, progression logic

---

## Commands

```bash
bin/dev          # start all processes (Rails + Vite via Foreman)
bin/ci           # MUST pass before every commit — rubocop, brakeman, bundler-audit, rspec
bin/rubocop -a   # auto-fix style (also runs automatically via hook on every .rb edit)
bundle exec rspec spec/path/to/file_spec.rb
```

---

## Stack

- **Rails 8.1.3** — full stack, not API-only. PostgreSQL
- **Solid Queue** — background jobs (quiz AI evaluation)
- **React + Vite** — student-facing SPA in `app/javascript/vocare/`
- **Tailwind CSS v4** — dark theme, MasterClass-inspired
- **Devise** — admin auth only. Students use token-based login (no Devise)
- **Faraday** — OpenAI API client. No AI gems
- **Active Storage** — MP3 audio files. Video via Vimeo embeds
- **HAML** — all server-rendered views (admin dashboard, React shell)
- **RSpec + FactoryBot + WebMock** — testing

---

## Hard rules (universal — apply everywhere)

- Run `bin/ci` after every task. Do not proceed until it passes.
- No ERB. Server views use HAML. Student UI is React JSX only.
- All UI text in Danish. Use `t('.key')` in HAML, React gets translations via `data-translations` on `#vocare-root`.
- No gem for OpenAI. Use `Ai::Client` — plain Faraday wrapper. Model via `ENV['AI_MODEL']`. See `app/services/ai/CLAUDE.md`.
- Stub ALL external HTTP in tests with WebMock. Zero real API calls in specs.
- String enums only — never integer enums. `enum :status, { active: "active" }`.
- Students are called "customers" in code (`Customer` model, not `Student`).
- Section progression is linear: must complete all lessons + pass quiz to unlock next section.

## HAML + Tailwind rules (CRITICAL — read before editing any .haml file)

- **Colon classes** (`hover:`, `md:`, `lg:`, `focus:`): NEVER use dot-notation. Always use `%div{ class: "md:grid-cols-3 hover:bg-gray-50" }`.
- **Decimal classes** (`px-3.5`, `gap-1.5`): HAML parses `.5` as a class. Use whole numbers (`px-4`, `gap-2`) or `{ class: "px-3.5" }`.
- **JSX files**: Any file with JSX must be `.jsx`, not `.js`. esbuild only processes `.jsx` for JSX syntax.
- **Two CSS entrypoints**: Student uses `application.css` (dark theme). Admin uses `admin.css` (plain Tailwind). Never mix them.
- See @docs/BACKLOG.md lessons section for full details and examples.

---

## Real API testing (OpenAI)

After implementing or changing quiz evaluation:
1. Test against real OpenAI API using `bin/rails runner`
2. Verify Danish-language evaluation works correctly
3. Check edge cases: empty answers, very long answers, partially correct answers
4. Document any quirks in `app/services/ai/CLAUDE.md`

---

## When you make a mistake

Add a rule to @docs/BACKLOG.md lessons section immediately. Do not skip this step.
