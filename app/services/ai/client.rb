module Ai
  class Client
    BASE_URL = "https://api.openai.com/v1"
    MODEL = ENV.fetch("AI_MODEL", "gpt-4o")

    def chat(messages:, system: nil, max_tokens: 1024, json_response: false)
      openai_messages = []
      openai_messages << { role: "system", content: system } if system
      openai_messages += messages

      payload = {
        model: MODEL,
        max_tokens: max_tokens,
        messages: openai_messages
      }
      payload[:response_format] = { type: "json_object" } if json_response

      response = connection.post("/v1/chat/completions") do |req|
        req.body = payload.to_json
      end

      handle_response(response)
    end

    private

    def connection
      @connection ||= Faraday.new(BASE_URL) do |f|
        f.headers["Authorization"] = "Bearer #{credentials[:api_key] || 'missing'}"
        f.headers["Content-Type"] = "application/json"
        f.options.open_timeout = 10
        f.options.timeout = 30
      end
    end

    def credentials
      Rails.application.credentials.openai || {}
    end

    def handle_response(response)
      parsed = JSON.parse(response.body)

      unless response.success?
        error = parsed["error"] || {}
        raise Ai::Error.new(
          error["message"] || "HTTP #{response.status}: #{response.body}",
          status: response.status,
          type: error["type"]
        )
      end

      content = parsed.dig("choices", 0, "message", "content").to_s
      content
    end
  end
end
