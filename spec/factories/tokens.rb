FactoryBot.define do
  factory :token do
    sequence(:code) { |n| format("VOCARE-%04d-%04d", n / 10000, n % 10000) }
    created_by factory: :admin_user

    trait :activated do
      customer
      activated_at { 1.day.ago }
    end

    trait :expired do
      expires_at { 1.day.ago }
    end

    trait :revoked do
      revoked_at { 1.hour.ago }
    end
  end
end
