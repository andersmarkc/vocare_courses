# Vocare Courses — Testing

## Stack

| Gem | Purpose |
|---|---|
| `rspec-rails` ~> 7.0 | Test framework |
| `factory_bot_rails` | Test data |
| `faker` | Realistic fake data |
| `shoulda-matchers` | Validation + association matchers |
| `database_cleaner-active_record` | Test isolation |
| `webmock` | Stub ALL external HTTP — no real API calls |

---

## Commands

```bash
bundle exec rspec                                   # full suite
bundle exec rspec spec/models                       # by folder
bundle exec rspec spec/services/ai                  # by namespace
bundle exec rspec spec/models/customer_spec.rb      # single file
bundle exec rspec spec/models/customer_spec.rb:42   # single example
```

---

## Spec Structure

Mirrors `app/` exactly.

```
spec/
├── models/
│   ├── token_spec.rb
│   ├── customer_spec.rb
│   ├── course_spec.rb
│   ├── section_spec.rb
│   ├── lesson_spec.rb
│   ├── quiz_spec.rb
│   └── ...
├── requests/
│   ├── api/v1/
│   │   ├── auth_spec.rb
│   │   ├── courses_spec.rb
│   │   ├── lessons_spec.rb
│   │   ├── quizzes_spec.rb
│   │   └── quiz_attempts_spec.rb
│   └── admin/
│       ├── tokens_spec.rb
│       ├── customers_spec.rb
│       └── ...
├── services/
│   ├── ai/
│   │   ├── client_spec.rb
│   │   └── quiz_evaluator_spec.rb
│   ├── tokens/
│   │   ├── generator_spec.rb
│   │   └── authenticator_spec.rb
│   └── progress/
│       └── tracker_spec.rb
├── jobs/
│   ├── evaluate_quiz_attempt_job_spec.rb
│   └── evaluate_quiz_answer_job_spec.rb
├── factories/
│   ├── admin_users.rb
│   ├── tokens.rb
│   ├── customers.rb
│   ├── courses.rb
│   ├── sections.rb
│   ├── lessons.rb
│   ├── quizzes.rb
│   ├── quiz_questions.rb
│   ├── quiz_attempts.rb
│   └── quiz_answers.rb
└── support/
    ├── factory_bot.rb
    ├── shoulda_matchers.rb
    ├── webmock.rb
    └── api_stubs/
        └── openai_stubs.rb
```

---

## WebMock Stubs for OpenAI

```ruby
# spec/support/api_stubs/openai_stubs.rb
module OpenaiStubs
  def stub_openai_evaluation(score: 85, passed: true, explanation: "Godt svar.")
    stub_request(:post, "https://api.openai.com/v1/chat/completions")
      .to_return(
        status: 200,
        body: {
          choices: [{
            message: {
              role: "assistant",
              content: { score: score, passed: passed, explanation: explanation }.to_json
            }
          }],
          model: "gpt-4o",
          usage: { prompt_tokens: 200, completion_tokens: 100 }
        }.to_json,
        headers: { "Content-Type" => "application/json" }
      )
  end
end
```

---

## Factory Conventions

- Every model has a factory in `spec/factories/`
- Use `sequence` for unique fields: `sequence(:code) { |n| "VOCARE-#{format('%04d', n)}-TEST" }`
- Use traits for states: `trait :activated`, `trait :expired`, `trait :revoked`
- Factories should create minimal valid records — no optional fields unless needed
