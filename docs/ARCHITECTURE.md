# Vocare Courses — Architecture

## Directory Structure

```
app/
├── controllers/
│   ├── application_controller.rb
│   ├── home_controller.rb              # Root → renders React shell
│   ├── api/v1/
│   │   ├── base_controller.rb          # Customer session auth, JSON errors
│   │   ├── auth_controller.rb          # Token login/logout/me
│   │   ├── courses_controller.rb       # Course + sections listing
│   │   ├── sections_controller.rb      # Section detail with lessons
│   │   ├── lessons_controller.rb       # Lesson content
│   │   ├── progress_controller.rb      # Track completion + summary
│   │   ├── quizzes_controller.rb       # Quiz with questions
│   │   └── quiz_attempts_controller.rb # Submit answers + get results
│   └── admin/
│       ├── base_controller.rb          # Devise admin auth
│       ├── dashboard_controller.rb     # Stats overview
│       ├── tokens_controller.rb        # CRUD + batch generate
│       ├── customers_controller.rb     # List + progress detail
│       ├── courses_controller.rb       # Course management
│       ├── sections_controller.rb      # Section management
│       ├── lessons_controller.rb       # Lesson management
│       └── quizzes_controller.rb       # Quiz + question management
├── models/
│   ├── admin_user.rb                   # Devise
│   ├── token.rb
│   ├── customer.rb
│   ├── course.rb
│   ├── section.rb
│   ├── lesson.rb
│   ├── quiz.rb
│   ├── quiz_question.rb
│   ├── quiz_attempt.rb
│   ├── quiz_answer.rb
│   ├── section_progress.rb
│   └── lesson_progress.rb
├── services/
│   ├── ai/
│   │   ├── client.rb                   # Faraday → OpenAI Chat Completions
│   │   ├── error.rb                    # Ai::Error
│   │   └── quiz_evaluator.rb           # Evaluate free-text answer (Danish)
│   ├── tokens/
│   │   ├── generator.rb               # Generate VOCARE-XXXX-XXXX codes
│   │   └── authenticator.rb           # Validate token, create/find customer
│   └── progress/
│       └── tracker.rb                  # Calculate progress, section unlock status
├── jobs/
│   ├── evaluate_quiz_attempt_job.rb    # Fan out per-answer evaluation
│   └── evaluate_quiz_answer_job.rb     # Call Ai::QuizEvaluator for one answer
├── views/
│   ├── layouts/
│   │   ├── application.html.haml       # Student shell (dark theme, loads application.css)
│   │   ├── admin.html.haml            # Admin shell (light theme, loads admin.css)
│   │   └── admin_auth.html.haml       # Admin login (minimal, loads admin.css)
│   ├── home/
│   │   └── index.html.haml            # #vocare-root div for React
│   ├── admin/                          # Server-rendered admin pages (dashboard, tokens, customers)
│   └── admin_users/sessions/           # Custom Devise login view (scoped_views)
├── controllers/
│   └── admin_users/
│       └── sessions_controller.rb      # Custom Devise sessions (admin_auth layout, redirects)
└── javascript/
    ├── entrypoints/
    │   ├── application.jsx             # React mount point (student SPA)
    │   ├── application.css             # Tailwind + dark theme variables (student)
    │   └── admin.css                   # Tailwind plain (admin — no dark overrides)
    └── vocare/
        ├── components/
        │   ├── App.jsx                 # BrowserRouter + AuthProvider + protected routes
        │   ├── Navbar.jsx              # Top nav with branding + logout
        │   ├── ProgressRing.jsx        # SVG circular progress
        │   ├── SectionCard.jsx         # Section card with lock/complete state
        │   ├── LessonSidebar.jsx       # Right sidebar with lesson list
        │   ├── Icons.jsx               # Inline SVG Heroicons
        │   └── pages/
        │       ├── LoginPage.jsx       # Token login (MasterClass-inspired hero)
        │       ├── DashboardPage.jsx   # Welcome back + progress ring
        │       ├── CoursePage.jsx      # Section grid
        │       ├── SectionPage.jsx     # Lesson list + quiz card
        │       ├── LessonPage.jsx      # Video/audio/text + sidebar
        │       └── QuizPage.jsx        # Free-text quiz + AI results
        ├── hooks/
        │   ├── useApi.js               # CSRF-aware fetch
        │   ├── useAuth.jsx             # AuthProvider context + login/logout (.jsx — contains JSX)
        │   └── useProgress.js          # Mark complete + update position
        └── lib/
            └── routes.js               # Route path constants (/kursus, /sektion, /lektion, /quiz)
```

---

## API Design

All student-facing endpoints return JSON. Auth via session cookie set during token login.

### Authentication
```
POST   /api/v1/auth/login    { code, name, email }  → { customer, token }
DELETE /api/v1/auth/logout                           → 204
GET    /api/v1/auth/me                               → { customer, progress }
```

### Course Content
```
GET    /api/v1/courses/:slug                         → { course, sections[] with lock status }
GET    /api/v1/sections/:id                          → { section, lessons[] } (403 if locked)
GET    /api/v1/lessons/:id                           → { lesson content } (403 if locked)
POST   /api/v1/lessons/:id/progress  { completed, position_seconds }
GET    /api/v1/progress/summary                      → { total, completed, percentage }
```

### Quizzes
```
GET    /api/v1/quizzes/:id                           → { quiz, questions[] } (no expected answers)
POST   /api/v1/quizzes/:id/attempts                  → { attempt } (starts attempt)
PATCH  /api/v1/quiz_attempts/:id   { answers[] }     → { attempt } (submits, triggers async eval)
GET    /api/v1/quiz_attempts/:id                     → { attempt, answers[] with AI feedback }
```

---

## Service Pattern

All external API calls go through service classes in `app/services/`. Never call Faraday directly from controllers or jobs.

```
Controller → Service → Faraday (HTTP)
Job → Service → Faraday (HTTP)
```

Only one external API: OpenAI (for quiz evaluation). The `Ai::Client` is a Faraday wrapper following the same pattern as store_os.

---

## Background Job Flow (Quiz Evaluation)

1. Student submits quiz answers → `PATCH /api/v1/quiz_attempts/:id`
2. Controller creates `QuizAnswer` records (unevaluated)
3. `EvaluateQuizAttemptJob.perform_later(quiz_attempt_id)` enqueued
4. Job evaluates each answer via `Ai::QuizEvaluator`
5. Each answer gets `ai_score`, `ai_evaluation`, `passed`
6. Overall `quiz_attempt.score` and `quiz_attempt.passed` calculated
7. `quiz_attempt.completed_at` set
8. Frontend polls `GET /api/v1/quiz_attempts/:id` until `completed_at` present

Note: `evaluate_quiz_answer_job.rb` does not exist — all evaluation is done inline within `EvaluateQuizAttemptJob`.

---

## Production Infrastructure

```
GitHub (main) → GitHub Actions → git push → bare repo (post-receive hook)
                                                ↓
                                         ~/vocare_courses/
                                                ↓
                              bundle install + npm install + assets:precompile + db:migrate
                                                ↓
                                    systemctl restart puma + solid_queue
```

- **Server:** bowser-stack (188.34.142.134), Ubuntu 24.04
- **User:** `vocare` (shared with existing vocare.dk app)
- **Ruby:** 3.4.3 via rbenv
- **Node:** 23 via fnm (for Vite asset compilation)
- **Database:** PostgreSQL (`vocare_courses_production`), password via credentials
- **App server:** Puma (5 workers, unix socket)
- **Background jobs:** Solid Queue (systemd service)
- **Reverse proxy:** Nginx → unix socket
- **SSL:** Let's Encrypt via certbot
- **Domain:** kursus.vocare.dk
