# frozen_string_literal: true

require 'test_helper'

class BooksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @book = books(:cherry)
  end

  def add_locale_ja(url)
    "#{url}?locale=ja"
  end

  test 'should get index' do
    get books_url
    assert_response :success
  end

  test 'should get new' do
    get new_book_url
    assert_response :success
  end

  test 'should create book' do
    assert_difference('Book.count') do
      post books_url, params: { book: { memo: @book.memo, title: @book.title } }
    end

    # url = "#{book_url(Book.last)}?locale=ja"
    # url = add_locale_ja(book_url(Book.last))

    # assert_redirected_to book_url(Book.last)
    assert_redirected_to add_locale_ja(book_url(Book.last))
  end

  test 'should show book' do
    get book_url(@book)
    assert_response :success
  end

  test 'should get edit' do
    get edit_book_url(@book)
    assert_response :success
  end

  test 'should update book' do
    patch book_url(@book), params: { book: { memo: @book.memo, title: @book.title, author: @book.author } }
    # url = "#{book_url(@book)}?locale=ja"
    # assert_redirected_to book_url(@book)
    # assert_redirected_to url
    assert_redirected_to add_locale_ja(book_url(@book))
  end

  test 'should destroy book' do
    assert_difference('Book.count', -1) do
      delete book_url(@book)
    end
    # url = "#{books_url}?locale=ja"

    # assert_redirected_to books_url
    assert_redirected_to add_locale_ja(books_url)
  end
end
