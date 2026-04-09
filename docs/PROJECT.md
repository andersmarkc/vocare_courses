# Vocare Courses — Project Brief

> Read this at the start of every session.
>
> Business context + course philosophy → @docs/BUSINESS.md
> Business concepts + data model → @docs/DOMAIN.md
> Technical structure → @docs/ARCHITECTURE.md
> Visual design → @docs/STYLE_GUIDE.md
> Testing patterns → @docs/TESTING.md

---

## What We're Building

A MasterClass-inspired course platform for Vocare's Danish B2B phone sales training. One course, eight sections, each with video/audio/text lessons and an AI-graded quiz. Dark cinematic design. Token-based access (no passwords, no payment in-system).

---

## MVP Scope

### In scope
- Token-based login (VOCARE-XXXX-XXXX format)
- Customer profiles (name, email, company — extensible)
- Single course with 8 sections, ordered lessons (video/audio/text)
- Linear progression: complete section → pass quiz → unlock next
- AI-powered free-text quizzes (OpenAI evaluation, async via Solid Queue)
- Final comprehensive quiz covering all sections
- Progress tracking (lesson completion, quiz scores, video resume position)
- Admin dashboard: token management, customer progress, content management
- MasterClass-inspired dark theme, responsive design
- Danish UI throughout

### Out of scope (Phase 1)
- Payment processing
- Multiple courses
- User registration (all access via tokens)
- Email notifications
- Certificate generation
- Discussion/community features
- Mobile app

---

## Current Phase

**Phase 7: Polish** — App is deployed and functional. Remaining work is polish and browser testing.

### Completed
- [x] Phase 1: Foundation — CLAUDE.md structure (root + 4 subdirectory + 7 docs), Vite + React + Tailwind, RSpec + FactoryBot + WebMock, 12 DB tables, seed data (8 sections, 19 lessons, 21 quiz questions)
- [x] Phase 2: Authentication — `Tokens::Generator`, `Tokens::Authenticator`, Student API auth (login/logout/me), Admin Devise with custom sessions controller
- [x] Phase 3: Course Content API — 8 API controllers (auth, courses, sections, lessons, progress, quizzes, quiz_attempts), `Progress::Tracker` with section unlock logic
- [x] Phase 3b: Admin Dashboard — Dashboard stats, Token CRUD + batch generate, Customer list + detail with progress view. Consistent gray-900 monochrome design, separate `admin.css` entrypoint
- [x] Phase 4: AI services — `Ai::Client` (Faraday → OpenAI), `Ai::QuizEvaluator` (Danish prompts, JSON response), `EvaluateQuizAttemptJob`
- [x] Phase 5: React Frontend — 6 pages, 5 shared components, 3 hooks, React Router with Danish URLs
- [x] Phase 6: Integration Testing & Bug Fixes
  - Fixed missing Active Storage migration
  - Fixed lesson API missing `section.position` for LessonSidebar
  - Fixed CI script (removed importmap, switched to RSpec)
  - Verified all API response shapes match React components via curl
  - OpenAI API key added to credentials, real quiz evaluation verified
  - 35 backend specs passing, 0 rubocop offenses, 0 brakeman warnings
- [x] Phase 6b: Production Deployment
  - Server: bowser-stack (Ubuntu 24.04), user: `vocare`
  - Live at: https://kursus.vocare.dk/
  - GitHub Actions CI/CD: push to `main` → auto-deploy via git bare repo + post-receive hook
  - Puma (5 workers) + Solid Queue (quiz evaluation) as systemd services
  - Nginx reverse proxy + Let's Encrypt SSL
  - PostgreSQL with credentials-based password
  - fnm + Node 23 for Vite asset compilation

### NOT yet validated
- [ ] Full student flow in browser: login → dashboard → course → section → lesson → mark complete → quiz → AI evaluation → section unlock
- [ ] Progress tracking actually updates UI after marking lessons complete
- [ ] Section lock/unlock visually works after passing quiz
- [ ] Responsive design on mobile/tablet

### Phase 7: Polish (current)
- [ ] Browser testing of full student + admin flows
- [ ] Error states & empty states in React
- [ ] Responsive design pass (mobile sidebar, form layouts)
- [ ] Loading skeleton states
- [ ] Remaining Danish i18n for hardcoded strings
