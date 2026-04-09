FactoryBot.define do
  factory :customer do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    locale { "da" }

    trait :with_company do
      company { Faker::Company.name }
      phone { Faker::PhoneNumber.phone_number }
    end
  end
end
