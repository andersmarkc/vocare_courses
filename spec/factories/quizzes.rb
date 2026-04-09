FactoryBot.define do
  factory :quiz do
    association :quizzable, factory: :section
    title { "Sektionsquiz" }
    passing_score { 70 }

    trait :for_course do
      association :quizzable, factory: :course
      title { "Afsluttende quiz" }
    end
  end
end
