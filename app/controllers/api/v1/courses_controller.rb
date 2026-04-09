module Api
  module V1
    class CoursesController < BaseController
      def show
        course = Course.find_by!(slug: params[:slug], published: true)
        tracker = Progress::Tracker.new(current_customer)

        sections = course.sections.map do |section|
          summary = tracker.section_summary(section)
          {
            id: section.id,
            title: section.title,
            slug: section.slug,
            description: section.description,
            position: section.position,
            **summary,
            quiz_id: section.quiz&.id
          }
        end

        render json: {
          course: {
            id: course.id,
            title: course.title,
            slug: course.slug,
            description: course.description
          },
          sections: sections,
          progress: tracker.course_progress(course),
          final_quiz_id: course.final_quiz&.id
        }
      end
    end
  end
end
