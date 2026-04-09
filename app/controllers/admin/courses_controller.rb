module Admin
  class CoursesController < BaseController
    def index
      @courses = Course.includes(:sections).order(:position)
    end

    def show
      @course = Course.find(params[:id])
      @sections = @course.sections.includes(:lessons, :quiz).order(:position)
    end

    def edit
      @course = Course.find(params[:id])
    end

    def update
      @course = Course.find(params[:id])
      if @course.update(course_params)
        redirect_to admin_course_path(@course), notice: "Kursus opdateret"
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def course_params
      params.require(:course).permit(:title, :slug, :description, :published)
    end
  end
end
