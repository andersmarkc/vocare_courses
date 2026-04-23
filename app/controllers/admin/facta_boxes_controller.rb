module Admin
  class FactaBoxesController < BaseController
    before_action :set_section
    before_action :set_facta_box, only: [ :edit, :update, :destroy ]

    def new
      @facta_box = @section.facta_boxes.build
    end

    def create
      @facta_box = @section.facta_boxes.build(facta_box_params)
      if @facta_box.save
        redirect_to admin_section_path(@section), notice: "Faktaboks oprettet"
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @facta_box.update(facta_box_params)
        redirect_to admin_section_path(@section), notice: "Faktaboks opdateret"
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @facta_box.destroy!
      redirect_to admin_section_path(@section), notice: "Faktaboks slettet"
    end

    private

    def set_section
      @section = Section.find(params[:section_id])
    end

    def set_facta_box
      @facta_box = @section.facta_boxes.find(params[:id])
    end

    def facta_box_params
      params.require(:facta_box).permit(:title, :body, :position)
    end
  end
end
