# frozen_string_literal: true

require 'test_helper'

class ReportsIndexTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers

  setup do
    @user = users(:michael)
    @user_report = reports(:one)
    @other_user_report = reports(:two)
  end

  test 'index' do
    login_as(@user)
    get reports_path
    assert_template 'reports/index'
    reports_of_first_page = Report.order(:id).page(1)
    reports_of_first_page.each do |report|
      assert_select 'a[href=?]', report_path(report), text: I18n.t('views.common.show')
      assert_match I18n.l(report.created_at, format: :report), response.body
      count = report.user_id == @user.id ? 1 : 0
      assert_select 'a[href=?]', edit_report_path(report), text: I18n.t('views.common.edit'), count: count
      assert_select 'a[href=?]', report_path(report), text: I18n.t('views.common.destroy'), count: count
    end

    assert_difference 'Report.count', -1 do
      delete report_path(@user_report)
    end

    assert_no_difference 'Report.count' do
      delete report_path(@other_user_report)
    end
  end
end
