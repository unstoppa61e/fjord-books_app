require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get users_path
    assert_response :success
  end

  test "should get show" do
    get user_path(id: 1)
    assert_response :success
  end
end
