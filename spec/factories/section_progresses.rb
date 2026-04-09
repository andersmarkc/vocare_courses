FactoryBot.define do
  factory :section_progress do
    customer
    section
    completed { false }

    trait :completed do
      completed { true }
      completed_at { Time.current }
    end
  end
end
