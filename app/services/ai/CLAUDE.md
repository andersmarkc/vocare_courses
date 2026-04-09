# AI Service rules (app/services/ai/)

## OpenAI Integration

- Uses OpenAI Chat Completions API via plain Faraday (no gems)
- Model configurable via `ENV['AI_MODEL']` (default: `gpt-4o`)
- API key from `Rails.application.credentials.dig(:openai, :api_key)`
- Timeout: 30 seconds (quiz evaluation should be fast)

## Quiz Evaluation

`Ai::QuizEvaluator` sends the question, expected answer, and student's answer to OpenAI. The system prompt instructs the AI to:

1. Compare the student's answer to the expected answer
2. Evaluate in Danish (questions and answers are Danish)
3. Return a JSON object: `{ "score": 0-100, "passed": true/false, "explanation": "..." }`
4. Be lenient: accept answers that demonstrate understanding even if wording differs
5. The explanation should be encouraging and in Danish

## Important Quirks

- OpenAI responses are in `choices[0].message.content` (string, must parse JSON)
- Always set `response_format: { type: "json_object" }` for structured output
- Token costs: GPT-4o is ~$5/1M input tokens. Budget for ~500 tokens per evaluation
- If AI returns invalid JSON, retry once, then mark as evaluation error

## Testing

Stub with WebMock in specs. See `spec/support/api_stubs/openai_stubs.rb`.
