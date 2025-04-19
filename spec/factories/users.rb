FactoryBot.define do
  factory :user do
    sequence(:email_address) { |n| "user#{n}@example.com" }
    password { "password123" }
    first_name { Faker::Name.first_name }
    last_name  { Faker::Name.last_name }

    trait :static_credentials do
      email_address { "brandon@example.com" }
      password { "secret123" }
    end
  end
end
