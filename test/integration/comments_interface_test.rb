# frozen_string_literal: true

require 'test_helper'

class CommentsInterfaceTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers

  setup do
    Warden.test_mode!
    @user = users(:michael)
    @report = reports(:two)
  end

  test 'default comment interface' do
    login_as(@user)
    get report_path(@report)
    assert_select 'textarea[required=required]'
    assert_select 'input[type=submit]'
    assert_select 'a[href=?]', user_path(@user), text: @user.name, count: 0
    assert_select 'a', text: I18n.t('views.common.edit'), count: 0
    assert_select 'a', text: I18n.t('views.common.destroy'), count: 0
  end

  test 'comment interface' do
    login_as(@user)
    get report_path(@report)
    # 無効な送信
    post report_comments_path(params: { comment: { body: '' } }, report_id: @report.id)
    assert_redirected_to report_path(@report)
    follow_redirect!
    assert_select 'p#alert'
    # 有効な送信
    body = 'creating comment success'
    post report_comments_path(params: { comment: { body: body } }, report_id: @report.id)
    assert_redirected_to report_path(@report)
    follow_redirect!
    assert_match body, response.body
    comment_id = @report.comments.last.id
    assert_select 'a[href=?]', edit_report_comment_path(report_id: @report.id, id: comment_id), text: I18n.t('views.common.edit'), count: 1
    assert_select 'a[href=?]', report_comment_path(report_id: @report.id, id: comment_id), text: I18n.t('views.common.destroy'), count: 1
    # 投稿を削除する
    delete report_comment_path(id: comment_id, report_id: @report.id)
  end
end
