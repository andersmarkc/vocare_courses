module Api
  module V1
    class QuizAttemptsController < BaseController
      def create
        quiz = Quiz.find(params[:quiz_id])

        attempt = current_customer.quiz_attempts.create!(
          quiz: quiz,
          started_at: Time.current
        )

        render json: { attempt: attempt_json(attempt) }, status: :created
      end

      def show
        attempt = current_customer.quiz_attempts
          .includes(quiz_answers: :quiz_question)
          .find(params[:id])

        answers = attempt.quiz_answers.map do |a|
          {
            id: a.id,
            question_id: a.quiz_question_id,
            question_text: a.quiz_question.question_text,
            student_answer: a.student_answer,
            ai_score: a.ai_score,
            ai_evaluation: a.ai_evaluation,
            passed: a.passed,
            evaluated: a.evaluated?
          }
        end

        render json: {
          attempt: attempt_json(attempt),
          answers: answers
        }
      end

      def update
        attempt = current_customer.quiz_attempts.find(params[:id])

        if attempt.completed?
          return render_error("Denne quiz er allerede afsluttet", :unprocessable_entity)
        end

        answers_params = params.require(:answers)
        answers_params.each do |answer_param|
          attempt.quiz_answers.create!(
            quiz_question_id: answer_param[:question_id],
            student_answer: answer_param[:answer]
          )
        end

        EvaluateQuizAttemptJob.perform_later(attempt.id)

        render json: { attempt: attempt_json(attempt.reload) }
      end

      private

      def attempt_json(attempt)
        {
          id: attempt.id,
          quiz_id: attempt.quiz_id,
          score: attempt.score,
          passed: attempt.passed,
          started_at: attempt.started_at,
          completed_at: attempt.completed_at,
          evaluating: attempt.evaluating?
        }
      end
    end
  end
end
