# frozen_string_literal: true

module SessionsHelper
  def current_user?(user)
    user && user == current_user
  end
end
