# frozen_string_literal: true

require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers

  def setup
    Warden.test_mode!
    @user = users(:michael)
  end

  test 'unsuccessful edit' do
    login_as(@user, scope: :user)
    get edit_user_registration_path(@user)
    assert_template 'devise/registrations/edit'
    email = 'hoge@hoge.hoge'
    patch user_registration_path, params: { user: {
      email: email,
      current_password: ''
    } }
    assert_template 'devise/registrations/edit'
    assert_select 'div#error_explanation', count: 1
  end

  test 'successful edit with friendly forwarding' do
    login_as(@user, scope: :user)
    get edit_user_registration_path(@user)
    assert_template 'devise/registrations/edit'
    email = 'hoge@hoge.hoge'
    current_password = 'password'
    new_password = 'newpassword'
    postal_code = '555-5555'
    address = 'abcdefg'
    bio = 'yesyesyes'
    patch user_registration_path, params: { user: {
      email: email,
      current_password: current_password,
      password: new_password,
      password_confirmation: new_password,
      postal_code: postal_code,
      address: address,
      bio: bio
    } }
    get user_path(@user)
    assert_match email, response.body
    assert_match postal_code, response.body
    assert_match address, response.body
    assert_match bio, response.body
  end
end
