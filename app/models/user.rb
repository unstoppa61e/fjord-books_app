# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one_attached :image
  validates :image, content_type: { in: %w[image/jpg image/gif image/png], message: 'must be a valid image format' }

  def display_image
    image.variant(resize_to_limit: [200, 200])
  end
end
