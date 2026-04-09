FactoryBot.define do
  factory :course do
    title { "Vocare Salgskursus" }
    sequence(:slug) { |n| "vocare-salgskursus-#{n}" }
    description { "Lær at sælge over telefonen med Vocare" }
    position { 0 }
    published { true }
  end
end
