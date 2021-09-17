# frozen_string_literal: true

require 'test_helper'

class CommentsEditInterfaceTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers

  setup do
    @user = users(:michael)
    @book = books(:one)
    @comment = comments(:one)
  end

  test 'comment edit interface' do
    login_as(@user)
    get edit_book_comment_path(book_id: @book.id, id: @comment.id)
    assert_select 'textarea[required=required]'
    assert_select 'input[type=submit]'
    assert_select 'a[href=?]', book_path(@book), count: 1
    # 無効な送信
    patch book_comment_path(params: { comment: { body: '' } }, book_id: @book.id, id: @comment.id)
    assert_redirected_to [:edit, @book, @comment]
    follow_redirect!
    assert_select 'p#alert'
    # 有効な送信
    body = 'updating comment success'
    patch book_comment_path(params: { comment: { body: body } }, book_id: @book.id, id: @comment.id)
    assert_redirected_to book_path(@book)
    follow_redirect!
    assert_match body, response.body
  end
end
