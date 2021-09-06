require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers

  def setup
    Warden.test_mode!
    @user = users(:michael)
  end

  test 'login/logout links' do
    get root_path
    assert_select 'a[href=?]', new_user_session_path, text: 'ログイン', count: 1
    assert_select 'a[href=?]', destroy_user_session_path, text: 'ログアウト', count: 0
    login_as(@user, scope: :user)
    get root_path
    assert_select 'a[href=?]', new_user_session_path, text: 'ログイン', count: 0
    assert_select 'a[href=?]', destroy_user_session_path, text: 'ログアウト', count: 1
  end

  test 'users index links' do
    login_as(@user, scope: :user)
    get users_path
    users_of_first_page = User.order(:created_at, :id).page(1)
    users_of_first_page.each do |user|
      assert_select 'a[href=?]', user_path(user)
    end
  end
end
