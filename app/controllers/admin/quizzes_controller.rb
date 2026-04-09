module Admin
  class QuizzesController < BaseController
    def show
      @quiz = Quiz.find(params[:id])
      @questions = @quiz.quiz_questions.order(:position)
    end

    def new
      if params[:section_id]
        @quizzable = Section.find(params[:section_id])
      elsif params[:course_id]
        @quizzable = Course.find(params[:course_id])
      end
      @quiz = Quiz.new(quizzable: @quizzable, passing_score: 70)
    end

    def create
      @quiz = Quiz.new(quiz_params)
      if @quiz.save
        redirect_to admin_quiz_path(@quiz), notice: "Quiz oprettet"
      else
        @quizzable = @quiz.quizzable
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @quiz = Quiz.find(params[:id])
    end

    def update
      @quiz = Quiz.find(params[:id])
      if @quiz.update(quiz_params)
        redirect_to admin_quiz_path(@quiz), notice: "Quiz opdateret"
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def quiz_params
      params.require(:quiz).permit(:title, :description, :passing_score,
                                   :quizzable_type, :quizzable_id)
    end
  end
end
