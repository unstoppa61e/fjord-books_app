# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:name) { |i| "user#{i}" }
    sequence(:email) { |i| "email#{i}@example.com" }
    postal_code { '000-0000' }
    sequence(:address) { |i| "address#{i}" }
    sequence(:self_introduction) { |i| "self introduction#{i}" }
    sequence(:password) { |i| "password#{i}" }
  end
end
