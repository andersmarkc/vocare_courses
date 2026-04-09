# Services rules (app/services/)

Applies when working on any file in this directory.

## The one rule that matters

**Never call Faraday directly from a model, job, controller, or another service outside the `ai/` namespace.** Every external HTTP call goes through `Ai::Client` in `app/services/ai/client.rb`.

## Client Pattern

```ruby
module Ai
  class Client
    BASE_URL = "https://api.openai.com/v1"

    def initialize
      @api_key = Rails.application.credentials.dig(:openai, :api_key)
    end

    def chat(messages:, system: nil, max_tokens: 1024)
      # POST /chat/completions with Faraday
      # Returns parsed response hash
    end
  end
end
```

## Error Handling

Services raise namespaced errors: `Ai::Error`. Controllers rescue and return appropriate JSON.

## Namespacing

Directory structure mirrors module namespacing:
- `app/services/ai/client.rb` → `Ai::Client`
- `app/services/tokens/generator.rb` → `Tokens::Generator`
- `app/services/progress/tracker.rb` → `Progress::Tracker`
