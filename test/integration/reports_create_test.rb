# frozen_string_literal: true

require 'test_helper'

class ReportsCreateTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers

  setup do
    @user = users(:michael)
    @user_report = reports(:one)
    @other_user_report = reports(:two)
  end

  test 'create' do
    login_as(@user)
    get new_report_path
    assert_template 'reports/new'
    assert_match I18n.t('views.common.title_new', name: Report.model_name.human), response.body
    assert_match I18n.t('activerecord.attributes.report.title'), response.body
    assert_select 'input[type=text]'
    assert_match I18n.t('activerecord.attributes.report.content'), response.body
    assert_select 'input[type=submit]'
    assert_select 'a[href=?]', reports_path, text: I18n.t('views.common.back')
  end
end
