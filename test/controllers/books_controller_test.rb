# frozen_string_literal: true

require 'test_helper'

class BooksControllerTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers

  setup do
    Warden.test_mode!
    @book = books(:one)
    @user = users(:michael)
  end

  test 'should get index' do
    login_as(@user)
    get books_url
    assert_response :success
  end

  test 'should redirect index when not logged in' do
    get books_url
    assert_redirected_to new_user_session_url
  end

  test 'should get new' do
    login_as(@user)
    get new_book_url
    assert_response :success
  end

  test 'should redirect new when not logged in' do
    get new_book_url
    assert_redirected_to new_user_session_url
  end

  test 'should create book' do
    login_as(@user)
    assert_difference('Book.count') do
      post books_url, params: { book: { memo: @book.memo, title: @book.title } }
    end

    assert_redirected_to book_url(Book.last)
  end

  test 'should not create book' do
    assert_no_difference('Book.count') do
      post books_url, params: { book: { memo: @book.memo, title: @book.title } }
    end

    assert_redirected_to new_user_session_url
  end

  test 'should show book' do
    login_as(@user)
    get book_url(@book)
    assert_response :success
  end

  test 'should redirect show when not logged in' do
    get book_url(@book)
    assert_redirected_to new_user_session_url
  end

  test 'should get edit' do
    login_as(@user)
    get edit_book_url(@book)
    assert_response :success
  end

  test 'should redirect edit when not logged in' do
    get edit_book_url(@book)
    assert_redirected_to new_user_session_url
  end

  test 'should update book' do
    login_as(@user)
    patch book_url(@book), params: { book: { memo: @book.memo, title: @book.title } }
    assert_redirected_to book_url(@book)
  end

  test 'should not update book' do
    patch book_url(@book), params: { book: { memo: @book.memo, title: @book.title } }

    assert_redirected_to new_user_session_url
  end

  test 'should destroy book' do
    login_as(@user)
    assert_difference('Book.count', -1) do
      delete book_url(@book)
    end

    assert_redirected_to books_url
  end

  test 'should not destroy book' do
    assert_no_difference 'Book.count' do
      delete book_url(@book)
    end

    assert_redirected_to new_user_session_url
  end
end
