# frozen_string_literal: true

require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers

  def setup
    Warden.test_mode!
    @user = users(:michael)
    @other = users(:josh)
    login_as(@user)
  end

  test 'following page' do
    get followings_user_path(@user)
    assert_not @user.followings.empty?
    assert_match @user.followings.count.to_s, response.body
    @user.followings.each do |user|
      assert_select 'a[href=?]', user_path(user)
    end
  end

  test 'followers page' do
    get followers_user_path(@user)
    assert_not @user.followers.empty?
    assert_match @user.followers.count.to_s, response.body
    @user.followers.each do |user|
      assert_select 'a[href=?]', user_path(user)
    end
  end

  test 'should follow a user the standard way' do
    assert_difference '@user.followings.count', 1 do
      post relationships_path, params: { followed_id: @other.id }
    end
  end

  test 'should follow a user with Ajax' do
    assert_difference '@user.followings.count', 1 do
      post relationships_path, xhr: true, params: { followed_id: @other.id }
    end
  end

  test 'should unfollow a user the standard way' do
    @user.follow(@other)
    relationship = @user.active_relationships.find_by(followed_id: @other.id)
    assert_difference '@user.followings.count', -1 do
      delete relationship_path(relationship)
    end
  end

  test 'should unfollow a user with Ajax' do
    @user.follow(@other)
    relationship = @user.active_relationships.find_by(followed_id: @other.id)
    assert_difference '@user.followings.count', -1 do
      delete relationship_path(relationship), xhr: true
    end
  end
end
