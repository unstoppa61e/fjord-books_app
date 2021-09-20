# frozen_string_literal: true

require 'test_helper'

class ReportsControllerTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers

  setup do
    Warden.test_mode!
    @report = reports(:one)
  end

  test 'should redirect index when not logged in' do
    get reports_url
    assert_redirected_to new_user_session_url
  end

  test 'should redirect new when not logged in' do
    get new_report_url
    assert_redirected_to new_user_session_url
  end

  test 'should redirect show when not logged in' do
    get report_url(@report)
    assert_redirected_to new_user_session_url
  end

  test 'should redirect edit when not logged in' do
    get edit_report_url(@report)
    assert_redirected_to new_user_session_url
  end

  test 'should not update report when not logged in' do
    patch report_url(@report), params: { report: { title: @report.title, content: @report.content } }

    assert_redirected_to new_user_session_url
  end

  test 'should not destroy report when not logged in' do
    assert_no_difference 'Report.count' do
      delete report_url(@report)
    end

    assert_redirected_to new_user_session_url
  end
end
