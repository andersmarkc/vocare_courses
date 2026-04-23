FactoryBot.define do
  factory :facta_box do
    section
    sequence(:title) { |n| "Faktaboks #{n}" }
    body { "<p>Et nyttigt tip.</p>" }
    sequence(:position) { |n| n }
  end
end
