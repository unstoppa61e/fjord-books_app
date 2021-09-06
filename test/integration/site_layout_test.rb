require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers

  def setup
    Warden.test_mode!
    @user = users(:michael)
  end

  test 'login / logout links' do
    get root_path
    assert_select 'a[href=?]', new_user_session_path, text: 'ログイン', count: 1
    assert_select 'a[href=?]', destroy_user_session_path, text: 'ログアウト', count: 0
    login_as(@user, :scope => :user)
    get root_path
    assert_select 'a[href=?]', new_user_session_path, text: 'ログイン', count: 0
    assert_select 'a[href=?]', destroy_user_session_path, text: 'ログアウト', count: 1
  end
end
