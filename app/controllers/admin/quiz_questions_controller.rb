module Admin
  class QuizQuestionsController < BaseController
    def new
      @quiz = Quiz.find(params[:quiz_id])
      next_position = (@quiz.quiz_questions.maximum(:position) || 0) + 1
      @question = @quiz.quiz_questions.build(position: next_position, points: 1)
    end

    def create
      @quiz = Quiz.find(params[:quiz_question][:quiz_id])
      @question = @quiz.quiz_questions.build(question_params)
      if @question.save
        redirect_to admin_quiz_path(@quiz), notice: "Spørgsmål oprettet"
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @question = QuizQuestion.find(params[:id])
      @quiz = @question.quiz
    end

    def update
      @question = QuizQuestion.find(params[:id])
      if @question.update(question_params)
        redirect_to admin_quiz_path(@question.quiz), notice: "Spørgsmål opdateret"
      else
        @quiz = @question.quiz
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @question = QuizQuestion.find(params[:id])
      quiz = @question.quiz
      @question.destroy!
      redirect_to admin_quiz_path(quiz), notice: "Spørgsmål slettet"
    end

    private

    def question_params
      params.require(:quiz_question).permit(:question_text, :expected_answer, :position, :points, :quiz_id)
    end
  end
end
