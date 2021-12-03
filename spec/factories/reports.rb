# frozen_string_literal: true

FactoryBot.define do
  factory :report do
    sequence(:title) { |i| "title#{i}" }
    sequence(:content) { |i| "content#{i}" }
    association :user

    trait :invalid do
      title { nil }
      content { nil }
    end
  end
end
