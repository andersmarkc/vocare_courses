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

**Phase 7: Polish & Deploy** — All core features built. Final polish needed.

### Completed
- [x] Phase 1: Foundation — CLAUDE.md, Vite, React, Tailwind, RSpec, 12 DB tables, seed data
- [x] Phase 2: Authentication — Token services (Generator, Authenticator), Student API auth, Admin Devise
- [x] Phase 3: Course Content API — Courses, Sections, Lessons, Progress tracking, Quiz endpoints, section unlock logic
- [x] Phase 3b: Admin Dashboard — Dashboard stats, Token CRUD + batch generate, Customer list + progress detail
- [x] Phase 4: AI services — Ai::Client, Ai::QuizEvaluator, EvaluateQuizAttemptJob (async via Solid Queue)
- [x] Phase 5: React Frontend — MasterClass-inspired dark design:
  - LoginPage: bold serif heading, gold accent, token input with first-use name fields
  - DashboardPage: "Velkommen tilbage", progress ring (SVG), section mini-overview
  - CoursePage: section grid with lock/unlock/complete cards
  - SectionPage: lesson list with icons + quiz card
  - LessonPage: video/audio/text player + sidebar navigation (MasterClass layout)
  - QuizPage: free-text questions, AI evaluation polling, score results, retry
  - Navbar, ProgressRing, SectionCard, LessonSidebar, Icons (shared components)
  - useAuth (context provider), useProgress, useApi hooks
  - React Router with protected routes
- [x] 35 specs passing, 0 rubocop offenses, 0 brakeman warnings

### Next
- Phase 7: Polish (Danish i18n, error states, loading states, responsive pass, deploy config)
