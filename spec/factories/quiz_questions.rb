FactoryBot.define do
  factory :quiz_question do
    quiz
    question_text { "Hvad er det vigtigste i B2B-salg ifølge kurset?" }
    expected_answer { "At være autentisk og brænde for produktet er vigtigere end salgsteknik." }
    sequence(:position) { |n| n }
    points { 1 }
  end
end
