# frozen_string_literal: true

require 'test_helper'

class CommentsControllerTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers

  setup do
    Warden.test_mode!
    @user = users(:michael)
    @report = reports(:two)
    @user_comment = comments(:one)
    @other_user_comment = comments(:other_user_comment)
  end

  test 'should create comment' do
    login_as(@user)
    body = 'creating comment success'
    assert_difference 'Comment.count', 1 do
      post report_comments_path(params: { comment: { body: body } }, report_id: @report.id)
    end
    assert_redirected_to report_path(@report)
  end

  test 'should not create comment' do
    login_as(@user)
    assert_no_difference 'Comment.count' do
      post report_comments_path(params: { comment: { body: '' } }, report_id: @report.id)
    end
    assert_redirected_to report_path(@report)
  end

  test 'should destroy comment' do
    login_as(@user)
    assert_difference 'Comment.count', -1 do
      delete report_comment_path(id: @user_comment.id, report_id: @user_comment.commentable_id)
    end
  end

  test 'should not destroy other user comment' do
    login_as(@user)
    assert_no_difference 'Comment.count' do
      delete report_comment_path(id: @other_user_comment.id, report_id: @other_user_comment.commentable_id)
    end
    assert_redirected_to root_url
  end
end
