class EvaluateQuizAttemptJob < ApplicationJob
  queue_as :default

  def perform(quiz_attempt_id)
    attempt = QuizAttempt.includes(quiz_answers: :quiz_question).find(quiz_attempt_id)
    evaluator = Ai::QuizEvaluator.new

    total_score = 0
    total_points = 0

    attempt.quiz_answers.each do |answer|
      question = answer.quiz_question
      result = evaluator.evaluate(
        question_text: question.question_text,
        expected_answer: question.expected_answer,
        student_answer: answer.student_answer
      )

      answer.update!(
        ai_score: result[:score],
        ai_evaluation: result[:explanation],
        passed: result[:passed],
        evaluated_at: Time.current
      )

      total_score += result[:score] * question.points
      total_points += 100 * question.points
    end

    overall_score = total_points.zero? ? 0 : (total_score.to_f / total_points * 100).round
    passing_score = attempt.quiz.passing_score

    attempt.update!(
      score: overall_score,
      passed: overall_score >= passing_score,
      completed_at: Time.current
    )
  end
end
