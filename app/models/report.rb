class Report < ApplicationRecord
  belongs_to :user
  validates :created_at, created_at: true
end
