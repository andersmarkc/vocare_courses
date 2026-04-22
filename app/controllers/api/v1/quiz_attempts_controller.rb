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
          .includes(:quiz, quiz_answers: :quiz_question)
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
          answers: answers,
          next_target: next_target_for(attempt.quiz)
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

      def next_target_for(quiz)
        quizzable = quiz.quizzable
        case quizzable
        when Section
          next_section = quizzable.course.sections.where("position > ?", quizzable.position).order(:position).first
          if next_section
            first_lesson = next_section.lessons.order(:position).first
            if first_lesson
              return {
                type: "lesson",
                id: first_lesson.id,
                title: first_lesson.title,
                section_title: next_section.title
              }
            end
            return { type: "section", id: next_section.id, title: next_section.title }
          end
          if (final_quiz = quizzable.course.final_quiz)
            return { type: "quiz", id: final_quiz.id, title: "Afsluttende quiz" }
          end
          nil
        else
          nil
        end
      end

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
