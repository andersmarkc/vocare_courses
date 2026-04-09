module Api
  module V1
    class SectionsController < BaseController
      def show
        section = Section.includes(:lessons).find(params[:id])
        tracker = Progress::Tracker.new(current_customer)

        unless tracker.section_unlocked?(section)
          return render_error("Denne sektion er låst", :forbidden)
        end

        lessons = section.lessons.map do |lesson|
          progress = current_customer.lesson_progresses.find_by(lesson: lesson)
          {
            id: lesson.id,
            title: lesson.title,
            slug: lesson.slug,
            content_type: lesson.content_type,
            position: lesson.position,
            duration_seconds: lesson.duration_seconds,
            completed: progress&.completed || false
          }
        end

        render json: {
          section: {
            id: section.id,
            title: section.title,
            slug: section.slug,
            description: section.description,
            position: section.position
          },
          lessons: lessons,
          quiz_id: section.quiz&.id
        }
      end
    end
  end
end
