FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { "password" }

    trait :guest do
      email { "guest@example.com" }
    end
  end
end
