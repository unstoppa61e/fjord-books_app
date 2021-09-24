FactoryBot.define do
  factory :user do
    name { 'user' }
    sequence(:email) { |n| "tester#{n}@example.com" }
    postal_code { '123-4567' }
    address { 'address' }
    self_introduction { 'self introduction' }
    password { 'password' }

    trait :with_reports do
      after(:create) { |user| create_list(:report, 5, user: user) }
    end
  end
end

