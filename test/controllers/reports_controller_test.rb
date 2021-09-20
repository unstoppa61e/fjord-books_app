# frozen_string_literal: true

require 'test_helper'

class ReportsControllerTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers

  setup do
    Warden.test_mode!
    @user = users(:michael)
    @user_no_name = users(:no_name)
    @report = reports(:one)
    @other_user_report = reports(:two)
    @report_with_comment = reports(:three)
  end

  test 'should get index' do
    login_as(@user)
    get reports_url
    assert_response :success
  end

  test 'should get new' do
    login_as(@user)
    get new_report_url
    assert_response :success
  end

  test 'should create report but only once' do
    login_as(@user)
    assert_difference('Report.count', 1) do
      post reports_url, params: { report: { title: '', content: '', user_id: @user.id } }
    end
    assert_redirected_to reports_url
    assert_no_difference('Report.count') do
      post reports_url, params: { report: { title: '', content: '', user_id: @user.id } }
    end
  end

  test 'should create report when creation date is the same as other user report' do
    login_as(@user)
    assert_difference('Report.count', 1) do
      post reports_url, params: { report: { title: '', content: '', user_id: @user.id } }
    end
    login_as(@user_no_name)
    assert_difference('Report.count', 1) do
      post reports_url, params: { report: { title: '', content: '', user_id: @user_no_name.id } }
    end
  end

  test 'should not create report' do
    assert_no_difference('Report.count') do
      post reports_url, params: { report: { title: @report.title, content: @report.content, user_id: @user.id } }
    end

    assert_redirected_to new_user_session_url
  end

  test 'should show report' do
    login_as(@user)
    get report_url(@report)
    assert_response :success
  end

  test 'should get edit' do
    login_as(@user)
    get edit_report_url(@report)
    assert_response :success
  end

  test 'should update report' do
    login_as(@user)
    patch report_url(@report), params: { report: { title: '', content: '', user_id: @user.id } }

    assert_redirected_to reports_url
  end

  test 'should update report when the updating date is the same as other report creation date' do
    login_as(@user)
    assert_difference('Report.count', 1) do
      post reports_url, params: { report: { title: '', content: '', user_id: @user.id } }
    end
    assert_redirected_to reports_url
    content = 'updated!'
    patch report_url(Report.last), params: { report: { title: '', content: content, user_id: @user.id } }
    follow_redirect!
    assert_match content, response.body
  end

  test 'should destroy report' do
    login_as(@user)
    assert_difference('Report.count', -1) do
      delete report_url(@report)
    end
  end

  test 'should not destroy other user report' do
    login_as(@user)
    assert_no_difference 'Report.count' do
      delete report_url(@other_user_report)
    end

    assert_redirected_to root_url
  end

  test 'should destroy dependent comment' do
    login_as(@user)
    assert_difference('Comment.count', -1) do
      delete report_url(@report_with_comment)
    end
  end
end
