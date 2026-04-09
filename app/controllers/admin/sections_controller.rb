module Admin
  class SectionsController < BaseController
    def show
      @section = Section.find(params[:id])
      @lessons = @section.lessons.order(:position)
      @quiz = @section.quiz
    end

    def new
      @course = Course.find(params[:course_id])
      next_position = (@course.sections.maximum(:position) || 0) + 1
      @section = @course.sections.build(position: next_position)
    end

    def create
      @course = Course.find(params[:section][:course_id])
      @section = @course.sections.build(section_params)
      if @section.save
        redirect_to admin_section_path(@section), notice: "Sektion oprettet"
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @section = Section.find(params[:id])
      @course = @section.course
    end

    def update
      @section = Section.find(params[:id])
      if @section.update(section_params)
        redirect_to admin_section_path(@section), notice: "Sektion opdateret"
      else
        @course = @section.course
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @section = Section.find(params[:id])
      course = @section.course
      @section.destroy!
      redirect_to admin_course_path(course), notice: "Sektion slettet"
    end

    def move
      @section = Section.find(params[:id])
      sibling = if params[:direction] == "up"
        @section.course.sections.where("position < ?", @section.position).order(position: :desc).first
      else
        @section.course.sections.where("position > ?", @section.position).order(:position).first
      end

      if sibling
        Section.transaction do
          old_pos = @section.position
          new_pos = sibling.position
          @section.update_columns(position: -1)
          sibling.update_columns(position: old_pos)
          @section.update_columns(position: new_pos)
        end
      end

      redirect_to admin_course_path(@section.course)
    end

    private

    def section_params
      params.require(:section).permit(:title, :slug, :description, :position, :course_id)
    end
  end
end
