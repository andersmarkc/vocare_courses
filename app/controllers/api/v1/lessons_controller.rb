module Api
  module V1
    class LessonsController < BaseController
      def show
        lesson = Lesson.includes(:section).find(params[:id])
        tracker = Progress::Tracker.new(current_customer)

        unless tracker.section_unlocked?(lesson.section)
          return render_error("Denne lektion er låst", :forbidden)
        end

        progress = current_customer.lesson_progresses.find_by(lesson: lesson)

        render json: {
          lesson: {
            id: lesson.id,
            title: lesson.title,
            slug: lesson.slug,
            content_type: lesson.content_type,
            body: lesson.body,
            video_url: lesson.video_url,
            duration_seconds: lesson.duration_seconds,
            position: lesson.position,
            audio_url: lesson.audio_file.attached? ? url_for(lesson.audio_file) : nil
          },
          progress: {
            completed: progress&.completed || false,
            last_position_seconds: progress&.last_position_seconds || 0
          },
          section: {
            id: lesson.section.id,
            title: lesson.section.title,
            position: lesson.section.position
          }
        }
      end
    end
  end
end
