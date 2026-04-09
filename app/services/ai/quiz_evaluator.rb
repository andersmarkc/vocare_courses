module Ai
  class QuizEvaluator
    SYSTEM_PROMPT = <<~PROMPT
      Du er en evaluator for et dansk salgskursus. Du modtager et spørgsmål, det forventede svar, og en elevs svar.

      Din opgave er at vurdere om elevens svar demonstrerer forståelse af konceptet. Vær venlig og opmuntrende.

      Regler:
      - Svaret behøver ikke at være ordret det samme som det forventede svar
      - Eleven skal demonstrere forståelse af de vigtigste pointer
      - Vær tolerant over for stavefejl og grammatiske fejl
      - Giv en score fra 0-100, hvor 70+ er bestået
      - Skriv en kort forklaring på dansk

      Svar ALTID med valid JSON i dette format:
      {"score": 0-100, "passed": true/false, "explanation": "Din forklaring her"}
    PROMPT

    def evaluate(question_text:, expected_answer:, student_answer:)
      client = Ai::Client.new

      prompt = <<~MSG
        Spørgsmål: #{question_text}

        Forventet svar: #{expected_answer}

        Elevens svar: #{student_answer}
      MSG

      response = client.chat(
        system: SYSTEM_PROMPT,
        messages: [ { role: "user", content: prompt } ],
        max_tokens: 512,
        json_response: true
      )

      parse_evaluation(response)
    rescue JSON::ParserError
      { score: 0, passed: false, explanation: "Evalueringsfejl. Prøv igen." }
    rescue Ai::Error => e
      Rails.logger.error("Quiz evaluation failed: #{e.message}")
      { score: 0, passed: false, explanation: "Evalueringsfejl. Prøv igen." }
    end

    private

    def parse_evaluation(response_text)
      parsed = JSON.parse(response_text)
      {
        score: parsed["score"].to_i.clamp(0, 100),
        passed: parsed["passed"] == true,
        explanation: parsed["explanation"].to_s
      }
    end
  end
end
