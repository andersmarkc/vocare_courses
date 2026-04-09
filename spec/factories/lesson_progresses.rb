FactoryBot.define do
  factory :lesson_progress do
    customer
    lesson
    completed { false }
    last_position_seconds { 0 }

    trait :completed do
      completed { true }
      completed_at { Time.current }
    end
  end
end
