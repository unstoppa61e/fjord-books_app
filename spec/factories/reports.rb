FactoryBot.define do
  factory :report do
    title { 'title' }
    content { 'content' }
    association :user

    trait :invalid do
      title { nil }
      content { nil }
    end
  end
end
