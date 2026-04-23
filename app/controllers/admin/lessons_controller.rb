module Admin
  class LessonsController < BaseController
    def show
      @lesson = Lesson.find(params[:id])
    end

    def new
      @section = Section.find(params[:section_id])
      next_position = (@section.lessons.maximum(:position) || 0) + 1
      @lesson = @section.lessons.build(position: next_position, content_type: "text")
    end

    def create
      @section = Section.find(params[:lesson][:section_id])
      @lesson = @section.lessons.build(lesson_params)
      if @lesson.save
        redirect_to admin_section_path(@section), notice: "Lektion oprettet"
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @lesson = Lesson.find(params[:id])
      @section = @lesson.section
    end

    def update
      @lesson = Lesson.find(params[:id])
      if @lesson.update(lesson_params)
        redirect_to admin_section_path(@lesson.section), notice: "Lektion opdateret"
      else
        @section = @lesson.section
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @lesson = Lesson.find(params[:id])
      section = @lesson.section
      @lesson.destroy!
      redirect_to admin_section_path(section), notice: "Lektion slettet"
    end

    def move
      @lesson = Lesson.find(params[:id])
      sibling = if params[:direction] == "up"
        @lesson.section.lessons.where("position < ?", @lesson.position).order(position: :desc).first
      else
        @lesson.section.lessons.where("position > ?", @lesson.position).order(:position).first
      end

      if sibling
        Lesson.transaction do
          old_pos = @lesson.position
          new_pos = sibling.position
          @lesson.update_columns(position: -1)
          sibling.update_columns(position: old_pos)
          @lesson.update_columns(position: new_pos)
        end
      end

      redirect_to admin_section_path(@lesson.section)
    end

    private

    def lesson_params
      params.require(:lesson).permit(:title, :slug, :content_type, :body, :intro, :video_url,
                                     :position, :duration_seconds, :audio_file, :section_id)
    end
  end
end
