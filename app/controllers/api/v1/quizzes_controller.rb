module Api
  module V1
    class QuizzesController < BaseController
      def show
        quiz = Quiz.includes(:quiz_questions).find(params[:id])

        questions = quiz.quiz_questions.map do |q|
          {
            id: q.id,
            question_text: q.question_text,
            position: q.position,
            points: q.points
          }
        end

        render json: {
          quiz: {
            id: quiz.id,
            title: quiz.title,
            description: quiz.description,
            passing_score: quiz.passing_score,
            question_count: questions.size
          },
          questions: questions
        }
      end
    end
  end
end
