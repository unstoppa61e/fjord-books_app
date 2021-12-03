# frozen_string_literal: true

require 'test_helper'

class CommentsInterfaceTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers

  setup do
    Warden.test_mode!
    @user = users(:michael)
    @report = reports(:two)
    @no_name_user = users(:no_name)
    @no_comments_report = reports(:report15)
    @other_user_comment = comments(:other_user_comment)
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

  test 'comment author name or email display' do
    login_as(@no_name_user)
    get report_path(@report)
    users = @report.comments.map { |comment| User.find(comment.user_id) }
    users.each do |user|
      assert_match user.name, response.body
      assert_no_match user.email, response.body
    end
    body = 'comment by no name user'
    post report_comments_path(params: { comment: { body: body } }, report_id: @report.id)
    get report_path(@report)
    assert_no_match @no_name_user.name, response.body
    assert_match @no_name_user.email, response.body
  end

  test 'comment message when no comments posted' do
    login_as(@user)
    get report_path(@no_comments_report)
    assert_match I18n.t('comments.comments.no_comments'), response.body
    body = 'first comment to the report'
    post report_comments_path(params: { comment: { body: body } }, report_id: @no_comments_report.id)
    get report_path(@no_comments_report)
    assert_no_match I18n.t('comments.comments.no_comments'), response.body
  end

  test 'comment user name change after the account deleted' do
    login_as(@user)
    commented_report = Report.find(@other_user_comment.commentable_id)
    get report_path(commented_report)
    assert_no_match I18n.t('comments.comments.deleted_user'), response.body
    assert_difference('User.count', -1) do
      User.find(@other_user_comment.user_id).destroy
    end
    get report_path(commented_report)
    assert_match I18n.t('comments.comments.deleted_user'), response.body
  end
end
