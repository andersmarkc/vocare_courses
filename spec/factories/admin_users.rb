FactoryBot.define do
  factory :admin_user do
    sequence(:email) { |n| "admin#{n}@vocare.dk" }
    password { "password123" }
    name { Faker::Name.name }
  end
end
