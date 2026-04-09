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

**Phase 6: Integration Testing & Bug Fixes** — Code is written but not yet validated end-to-end in browser.

### Completed (code written & compiles)
- [x] Phase 1: Foundation — CLAUDE.md structure (root + 4 subdirectory + 7 docs), Vite + React + Tailwind, RSpec + FactoryBot + WebMock, 12 DB tables, seed data (8 sections, 19 lessons, 21 quiz questions)
- [x] Phase 2: Authentication — `Tokens::Generator`, `Tokens::Authenticator`, Student API auth (login/logout/me), Admin Devise with custom sessions controller
- [x] Phase 3: Course Content API — 8 API controllers (auth, courses, sections, lessons, progress, quizzes, quiz_attempts), `Progress::Tracker` with section unlock logic
- [x] Phase 3b: Admin Dashboard — Dashboard stats, Token CRUD + batch generate, Customer list + detail with progress view. Consistent gray-900 monochrome design, separate `admin.css` entrypoint
- [x] Phase 4: AI services — `Ai::Client` (Faraday → OpenAI), `Ai::QuizEvaluator` (Danish prompts, JSON response), `EvaluateQuizAttemptJob`
- [x] Phase 5: React Frontend (code written, compiles, NOT browser-tested):
  - 6 pages: LoginPage, DashboardPage, CoursePage, SectionPage, LessonPage, QuizPage
  - 5 shared: Navbar, ProgressRing, SectionCard, LessonSidebar, Icons
  - 3 hooks: useAuth.jsx (AuthProvider context), useProgress.js, useApi.js
  - React Router with protected routes, Danish URLs (/kursus, /sektion, /lektion, /quiz)
- [x] 35 backend specs passing, 0 rubocop offenses, 0 brakeman warnings
- [x] Documentation updated with HAML+Tailwind lessons learned

### NOT yet validated
- [ ] Full student flow in browser: login → dashboard → course → section → lesson → mark complete → quiz → AI evaluation → section unlock
- [ ] API response shapes match what React components expect (likely bugs here)
- [ ] Quiz submission + OpenAI evaluation works end-to-end (needs API key in credentials)
- [ ] Progress tracking actually updates UI after marking lessons complete
- [ ] Section lock/unlock visually works after passing quiz
- [ ] Responsive design on mobile/tablet
- [ ] Admin flow: create token → customer uses it → admin sees customer progress

### Next session: start here
1. **`bin/dev`** — run the app and test the student flow manually in browser
2. **Fix API/React mismatches** — likely response shape bugs between controllers and components
3. **Add OpenAI API key** — `bin/rails credentials:edit` → add `openai.api_key` for quiz evaluation
4. **Test quiz flow** — submit answers → verify async evaluation → verify results display
5. **Test admin flow** — generate token → use it as customer → check admin sees progress

### Phase 7 (after testing is green)
- Danish i18n for remaining strings
- Error states & empty states in React
- Responsive design pass (mobile sidebar, form layouts)
- GitHub Actions CI/CD pipeline
- Loading skeleton states
- Final `bin/ci` pass + commit
