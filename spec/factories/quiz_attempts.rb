FactoryBot.define do
  factory :quiz_attempt do
    quiz
    customer
    started_at { Time.current }

    trait :completed do
      score { 85 }
      passed { true }
      completed_at { Time.current }
    end

    trait :failed do
      score { 50 }
      passed { false }
      completed_at { Time.current }
    end
  end
end
