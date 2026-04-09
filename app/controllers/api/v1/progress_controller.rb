module Api
  module V1
    class ProgressController < BaseController
      def create
        lesson = Lesson.find(params[:lesson_id])

        progress = current_customer.lesson_progresses.find_or_initialize_by(lesson: lesson)
        progress.completed = params[:completed] if params.key?(:completed)
        progress.completed_at = Time.current if progress.completed && progress.completed_at.nil?
        progress.last_position_seconds = params[:position_seconds].to_i if params.key?(:position_seconds)
        progress.save!

        render json: {
          completed: progress.completed,
          last_position_seconds: progress.last_position_seconds
        }
      end

      def summary
        course = Course.find_by!(published: true)
        tracker = Progress::Tracker.new(current_customer)

        render json: tracker.course_progress(course)
      end
    end
  end
end
