# frozen_string_literal: true

require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers

  def setup
    Warden.test_mode!
    @user = users(:michael)
    @other_user = users(:josh)
  end

  test 'login/logout links' do
    get root_path
    assert_redirected_to new_user_session_url
    follow_redirect!
    assert_select 'a[href=?]', new_user_session_path, text: I18n.t('layouts.header.log_in'), count: 1
    assert_select 'a[href=?]', destroy_user_session_path, text: I18n.t('layouts.header.log_out'), count: 0
    login_as(@user, scope: :user)
    get root_path
    assert_select 'a[href=?]', new_user_session_path, text: I18n.t('layouts.header.log_in'), count: 0
    assert_select 'a[href=?]', destroy_user_session_path, text: I18n.t('layouts.header.log_out'), count: 1
  end

  test 'users index links' do
    login_as(@user, scope: :user)
    get users_path
    users_of_first_page = User.order(:created_at, :id).page(1)
    users_of_first_page.each do |user|
      assert_select 'a[href=?]', user_path(user)
    end
  end

  test 'user show links' do
    login_as(@user, scope: :user)
    get user_path(@user)
    assert_match @user.email, response.body
    assert_match @user.postal_code, response.body
    assert_match @user.address, response.body
    assert_match @user.bio, response.body
    assert_select 'a[href=?]', edit_user_registration_path, count: 1
    assert_select 'a[href=?]', users_path, count: 1
    get user_path(@other_user)
    assert_match @other_user.email, response.body
    assert_match @other_user.postal_code, response.body
    assert_match @other_user.address, response.body
    assert_match @other_user.bio, response.body
    assert_select 'a[href=?]', edit_user_registration_path, count: 0
    assert_select 'a[href=?]', users_path, count: 1
  end
end
