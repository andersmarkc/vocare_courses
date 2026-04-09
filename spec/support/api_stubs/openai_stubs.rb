module OpenaiStubs
  def stub_openai_evaluation(score: 85, passed: true, explanation: "Godt svar. Du har forstået konceptet.")
    stub_request(:post, "https://api.openai.com/v1/chat/completions")
      .to_return(
        status: 200,
        body: {
          choices: [ {
            message: {
              role: "assistant",
              content: { score: score, passed: passed, explanation: explanation }.to_json
            }
          } ],
          model: "gpt-4o",
          usage: { prompt_tokens: 200, completion_tokens: 100 }
        }.to_json,
        headers: { "Content-Type" => "application/json" }
      )
  end
end

RSpec.configure do |config|
  config.include OpenaiStubs
end
