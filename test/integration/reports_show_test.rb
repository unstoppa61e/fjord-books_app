# frozen_string_literal: true

require 'test_helper'

class ReportsShowTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers

  setup do
    @user = users(:michael)
    @user_report = reports(:one)
    @other_user_report = reports(:two)
  end

  test 'user report show' do
    login_as(@user)
    get report_path(@user_report)
    assert_template 'reports/show'
    assert_match @user_report.title, response.body
    assert_match @user_report.content, response.body
    assert_select 'a[href=?]', edit_report_path(@user_report), text: I18n.t('views.common.edit'), count: 1
    assert_select 'textarea'
    assert_select 'input[type=submit]'
    assert_select 'a[href=?]', reports_path, text: I18n.t('views.common.back')
  end

  test 'other user report show' do
    login_as(@user)
    get report_path(@other_user_report)
    assert_template 'reports/show'
    assert_match @other_user_report.title, response.body
    assert_match @other_user_report.content, response.body
    assert_select 'a', text: I18n.t('views.common.edit'), count: 0
    assert_select 'textarea'
    assert_select 'input[type=submit]'
    assert_select 'a[href=?]', reports_path, text: I18n.t('views.common.back')
  end
end
