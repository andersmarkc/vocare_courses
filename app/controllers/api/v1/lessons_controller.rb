module Api
  module V1
    class LessonsController < BaseController
      def show
        lesson = Lesson.includes(section: :course).find(params[:id])
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
            intro: lesson.intro,
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
          },
          next_target: next_target_for(lesson)
        }
      end

      private

      def next_target_for(lesson)
        section = lesson.section
        next_lesson = section.lessons.where("position > ?", lesson.position).order(:position).first
        return { type: "lesson", id: next_lesson.id, title: next_lesson.title } if next_lesson

        if section.quiz
          return { type: "quiz", id: section.quiz.id, title: "Sektionsquiz" }
        end

        next_section = section.course.sections.where("position > ?", section.position).order(:position).first
        return { type: "section", id: next_section.id, title: next_section.title } if next_section

        if (final_quiz = section.course.final_quiz)
          return { type: "quiz", id: final_quiz.id, title: "Afsluttende quiz" }
        end

        nil
      end
    end
  end
end
