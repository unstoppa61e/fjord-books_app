FactoryBot.define do
  factory :report do
    title { 'title' }
    content { 'content' }
    association :user
  end
end
