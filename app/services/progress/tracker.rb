module Progress
  class Tracker
    def initialize(customer)
      @customer = customer
    end

    def section_unlocked?(section)
      return true if section.position == 1

      previous = section.course.sections.find_by(position: section.position - 1)
      return true unless previous

      section_completed?(previous)
    end

    def section_completed?(section)
      all_lessons_completed?(section) && section_quiz_passed?(section)
    end

    def all_lessons_completed?(section)
      lesson_ids = section.lessons.pluck(:id)
      return true if lesson_ids.empty?

      completed_count = @customer.lesson_progresses
        .where(lesson_id: lesson_ids, completed: true)
        .count
      completed_count == lesson_ids.size
    end

    def section_quiz_passed?(section)
      quiz = section.quiz
      return true unless quiz

      @customer.quiz_attempts
        .where(quiz: quiz, passed: true)
        .exists?
    end

    def course_progress(course)
      sections = course.sections.includes(:lessons)
      total_lessons = sections.sum { |s| s.lessons.size }
      completed_lesson_ids = @customer.lesson_progresses
        .where(completed: true)
        .joins(:lesson)
        .where(lessons: { section_id: sections.pluck(:id) })
        .pluck(:lesson_id)

      {
        total_sections: sections.size,
        completed_sections: sections.count { |s| section_completed?(s) },
        total_lessons: total_lessons,
        completed_lessons: completed_lesson_ids.size,
        percentage: total_lessons.zero? ? 0 : ((completed_lesson_ids.size.to_f / total_lessons) * 100).round
      }
    end

    def section_summary(section)
      lesson_ids = section.lessons.pluck(:id)
      completed = @customer.lesson_progresses
        .where(lesson_id: lesson_ids, completed: true)
        .count

      {
        locked: !section_unlocked?(section),
        completed: section_completed?(section),
        lessons_total: lesson_ids.size,
        lessons_completed: completed
      }
    end
  end
end
