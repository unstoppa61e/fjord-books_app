# frozen_string_literal: true

require 'test_helper'

class BooksIndexTest < ActionDispatch::IntegrationTest
  def setup
    @cherry = books(:cherry)
  end

  def add_locale(url, locale)
    "#{url}?locale=#{locale}"
  end

  test 'index including pagination' do
    get books_path, params: { page: 10 }
    assert_template 'books/index'
    assert_select 'nav.pagination', count: 1
    6.upto 11 do |n|
      next if n == 10

      assert_select 'a[href=?]', "/books?locale=ja&page=#{n}", text: n.to_s
    end
    assert_select 'a', text: '最初', count: 1
    assert_select 'a', text: '前', count: 1
    assert_select 'span', text: '...', count: 1
    assert_select 'a', text: '次', count: 1
    assert_select 'a', text: '最後', count: 1
    get books_path, params: { page: 10, locale: :en }
    assert_select 'a', text: 'First', count: 1
    assert_select 'a', text: 'Previous', count: 1
    assert_select 'span', text: 'Truncate', count: 1
    assert_select 'a', text: 'Next', count: 1
    assert_select 'a', text: 'Last', count: 1
  end

  test 'index including toggling language' do
    get books_path
    assert_select 'a[href=?]', add_locale(books_path, 'en'), text: 'English'
    get books_path, params: { locale: :ja }
    assert_select 'a[href=?]', add_locale(books_path, 'en'), text: 'English'
    get books_path, params: { locale: :en }
    assert_select 'a[href=?]', add_locale(books_path, 'ja'), text: '日本語'
  end
end
