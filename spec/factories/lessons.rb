FactoryBot.define do
  factory :lesson do
    section
    title { Faker::Lorem.sentence(word_count: 3) }
    sequence(:slug) { |n| "lesson-#{n}" }
    content_type { "text" }
    body { Faker::Lorem.paragraphs(number: 3).join("\n\n") }
    sequence(:position) { |n| n }

    trait :video do
      content_type { "video" }
      video_url { "https://player.vimeo.com/video/123456789" }
      duration_seconds { 600 }
      body { nil }
    end

    trait :audio do
      content_type { "audio" }
      duration_seconds { 300 }
      body { nil }
    end
  end
end
