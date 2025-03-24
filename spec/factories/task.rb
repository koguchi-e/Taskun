FactoryBot.define do
  factory :task do
    association :user
    title { Faker::Lorem.characters(number: 10) }
    keyword1 { Faker::Lorem.characters(number: 10) }
    keyword2 { Faker::Lorem.characters(number: 10) }
    keyword3 { Faker::Lorem.characters(number: 10) }
  end
end
