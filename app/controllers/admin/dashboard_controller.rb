module Admin
  class DashboardController < BaseController
    def index
      @stats = {
        total_tokens: Token.count,
        unused_tokens: Token.unused.count,
        active_tokens: Token.active.count,
        total_customers: Customer.count,
        total_quiz_attempts: QuizAttempt.count,
        passed_quiz_attempts: QuizAttempt.where(passed: true).count
      }
    end
  end
end
