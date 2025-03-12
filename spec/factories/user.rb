FactoryBot.define do
    factory :user do
        name { Faker::Lorem.characters(number: 10) }
        email { Faker::Internet.email }
        password { 'password' }
        password_confirmation { 'password' }

        trait :guest do
            email { "guest@example.com" }
        end
    end
end
