# frozen_string_literal: true

require 'test_helper'

class UsersInterfaceTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers

  def setup
    Warden.test_mode!
    @user = users(:michael)
  end

  test 'user interface' do
    login_as(@user, scope: :user)
    get edit_user_registration_path
    assert_select 'input[type="file"]'
    # 無効な送信
    assert_no_difference 'User.count' do
      patch user_registration_path, params: { user: { current_password: '' } }
    end
    assert_select 'div#error_explanation'
    # # 有効な送信
    image = fixture_file_upload('test/fixtures/kitten.jpg', 'image/jpeg')
    password = 'password'
    patch user_registration_path, params: { user:
                                      { current_password: password, image: image } }
    assert assigns(:user).image.attached?
  end
end
