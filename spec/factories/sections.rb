FactoryBot.define do
  factory :section do
    course
    title { Faker::Lorem.sentence(word_count: 3) }
    sequence(:slug) { |n| "section-#{n}" }
    description { Faker::Lorem.paragraph }
    sequence(:position) { |n| n }
  end
end
