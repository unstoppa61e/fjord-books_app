# frozen_string_literal: true

print '開発環境のデータをすべて削除して初期データを投入します。よろしいですか？[Y/n]: ' # rubocop:disable Rails/Output
unless $stdin.gets.chomp == 'Y'
  puts '中止しました。' # rubocop:disable Rails/Output
  return
end

def picture_file(name)
  File.open(Rails.root.join("db/seeds/#{name}"))
end

User.destroy_all

User.create!(
  email: 'example@fjord.com',
  password: 'password',
  postal_code: '123-4567',
  address: '東京都葛飾区亀有公園前派出所',
  bio: 'ほげほげほげほげほげほげほげほげほげほげほげほげほげほげほげほげほげほげ！ほげほげほげほげほげほげほげほげほげほげほげほげほげほげほげほげほげほげ！',
)

99.times do |n|
  User.create!(
    email: "#{n}@fjord.com",
    password: 'password',
    postal_code: '999-9999',
    address: "北海道札幌市西区西野#{n}条#{n}丁目",
    bio: "座右の銘:「#{n}度あることは#{n + 1}度ある」"
  )
end

Book.destroy_all

Book.create!(
  title: 'Ruby超入門',
  memo: 'Rubyの文法の基本をやさしくていねいに解説しています。',
  author: '五十嵐 邦明',
  picture: picture_file('cho-nyumon.jpg')
)

Book.create!(
  title: 'チェリー本',
  memo: 'プログラミング経験者のためのRuby入門書です。',
  author: '伊藤 淳一',
  picture: picture_file('cherry-book.jpg')
)

Book.create!(
  title: '楽々ERDレッスン',
  memo: '実在する帳票から本当に使えるテーブル設計を導く画期的な本！',
  author: '羽生 章洋',
  picture: picture_file('erd.jpg')
)

50.times do
  Book.create!(
    title: Faker::Book.title,
    memo: Faker::Book.genre,
    author: Faker::Book.author,
    picture: picture_file('no-image.png')
  )
end

puts '初期データの投入が完了しました。' # rubocop:disable Rails/Output
