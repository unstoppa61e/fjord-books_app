# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  validates :created_at, created_at: true
  has_many :comments, as: :commentable, dependent: :destroy
end
