FactoryBot.define do
  factory :quiz_answer do
    quiz_attempt
    quiz_question
    student_answer { "Autenticitet er det vigtigste - man skal virkelig tro på produktet." }

    trait :evaluated do
      ai_score { 85 }
      ai_evaluation { "Godt svar. Du har forstået konceptet om autenticitet i salg." }
      passed { true }
      evaluated_at { Time.current }
    end

    trait :failed_evaluation do
      ai_score { 30 }
      ai_evaluation { "Dit svar mangler de vigtigste punkter om autenticitet." }
      passed { false }
      evaluated_at { Time.current }
    end
  end
end
