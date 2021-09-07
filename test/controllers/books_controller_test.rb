# frozen_string_literal: true
#
# require 'test_helper'
#
# class BooksControllerTest < ActionDispatch::IntegrationTest
#   include Warden::Test::Helpers
#
#   setup do
#     Warden.test_mode!
#     @book = books(:one)
#   end
#
#   test 'should get index' do
#     login_as(@user)
#     get books_url
#     assert_response :success
#   end
#
#   test 'should get new' do
#     login_as(@user)
#     get new_book_url
#     assert_response :success
#   end
#
#   test 'should create book' do
#     assert_difference('Book.count') do
#       post books_url, params: { book: { memo: @book.memo, title: @book.title } }
#     end
#
#   end
#
#   test 'should show book' do
#     login_as(@user)
#     get book_url(@book)
#     assert_response :success
#   end
#
#   test 'should get edit' do
#     login_as(@user)
#     get edit_book_url(@book)
#     assert_response :success
#   end
#
#   test 'should update book' do
#     login_as(@user)
#     patch book_url(@book), params: { book: { memo: @book.memo, title: @book.title } }
#   end
#
#   test 'should destroy book' do
#     login_as(@user)
#     assert_difference('Book.count', -1) do
#       delete book_url(@book)
#     end
#
#   end
# end
