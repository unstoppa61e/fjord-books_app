# frozen_string_literal: true

require 'test_helper'

class ReportsControllerTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers

  setup do
    Warden.test_mode!
    @report = reports(:one)
    @user = users(:michael)
  end

  test 'should get index' do
    login_as(@user)
    get reports_url
    assert_response :success
  end

  test 'should redirect index when not logged in' do
    get reports_url
    assert_redirected_to new_user_session_url
  end

  test 'should get new' do
    login_as(@user)
    get new_report_url
    assert_response :success
  end

  test 'should redirect new when not logged in' do
    get new_report_url
    assert_redirected_to new_user_session_url
  end

  test 'should create report' do
    login_as(@user)
    assert_difference('report.count') do
      post reports_url, params: { report: { memo: @report.memo, title: @report.title } }
    end

    assert_redirected_to report_url(report.last)
  end

  test 'should not create report' do
    assert_no_difference('report.count') do
      post reports_url, params: { report: { memo: @report.memo, title: @report.title } }
    end

    assert_redirected_to new_user_session_url
  end

  test 'should show report' do
    login_as(@user)
    get report_url(@report)
    assert_response :success
  end

  test 'should redirect show when not logged in' do
    get report_url(@report)
    assert_redirected_to new_user_session_url
  end

  test 'should get edit' do
    login_as(@user)
    get edit_report_url(@report)
    assert_response :success
  end

  test 'should redirect edit when not logged in' do
    get edit_report_url(@report)
    assert_redirected_to new_user_session_url
  end

  test 'should update report' do
    login_as(@user)
    patch report_url(@report), params: { report: { memo: @report.memo, title: @report.title } }
    assert_redirected_to report_url(@report)
  end

  test 'should not update report' do
    patch report_url(@report), params: { report: { memo: @report.memo, title: @report.title } }

    assert_redirected_to new_user_session_url
  end

  test 'should destroy report' do
    login_as(@user)
    assert_difference('report.count', -1) do
      delete report_url(@report)
    end

    assert_redirected_to reports_url
  end

  test 'should not destroy report' do
    assert_no_difference 'report.count' do
      delete report_url(@report)
    end

    assert_redirected_to new_user_session_url
  end
end
