# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'should follow and unfollow a user' do
    michael = users(:michael)
    josh = users(:josh)
    assert_not michael.following?(josh)
    michael.follow(josh)
    assert michael.following?(josh)
    assert josh.followers.include?(michael)
    michael.unfollow(josh)
    assert_not michael.following?(josh)
  end
end
