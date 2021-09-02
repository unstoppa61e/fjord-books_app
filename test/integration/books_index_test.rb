require "test_helper"

class BooksIndexTest < ActionDispatch::IntegrationTest
  def setup
    @cherry = books(:cherry)
  end

  test 'index including pagination and delete links' do
    get books_path
    assert_template 'books/index'
    assert_select 'nav.pagination', count: 1
    2.upto 5 do |n|
      assert_select 'a[href=?]', "/books?locale=ja&page=#{n}", text: "#{n}"
    end
  end

end
