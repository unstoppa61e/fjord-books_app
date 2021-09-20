# frozen_string_literal: true

require "test_helper"

class ReportsEditTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers

  setup do
    @user = users(:michael)
    @user_report = reports(:one)
  end

  test 'report edit interface' do
    login_as(@user)
    get edit_report_path(@user_report)
    assert_template 'reports/edit'
    assert_match I18n.t('views.common.title_edit', name: Report.model_name.human), response.body
    assert_match I18n.t('activerecord.attributes.report.title'), response.body
    assert_select 'input[type=text]'
    assert_match I18n.t('activerecord.attributes.report.content'), response.body
    assert_select 'textarea'
    assert_select 'input[type=submit]'
    assert_select 'a[href=?]', report_path(@user_report), text: I18n.t('views.common.show')
    assert_select 'a[href=?]', reports_path, text: I18n.t('views.common.back')
  end
end
