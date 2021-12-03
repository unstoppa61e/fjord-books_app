# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:name) { |i| "user#{i}" }
    sequence(:email) { |i| "email#{i}@example.com" }
    postal_code { '000-0000' }
    address { 'address' }
    self_introduction { 'self introduction' }
    password { 'password' }
  end
end
