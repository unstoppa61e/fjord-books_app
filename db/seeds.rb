# frozen_string_literal: true

print '開発環境のデータをすべて削除して初期データを投入します。よろしいですか？[Y/n]: ' # rubocop:disable Rails/Output
unless $stdin.gets.chomp == 'Y'
  puts '中止しました。' # rubocop:disable Rails/Output
  return
end

def picture_file(name)
  File.open(Rails.root.join("db/seeds/#{name}"))
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

99.times do |n|
  title = (n % 4).zero? ? nil : Faker::Book.title
  memo = (n % 3).zero? ? nil : Faker::Lorem.sentence(word_count: 0, random_words_to_add: 5)
  author = (n % 5).zero? ? nil : Faker::Name.name
  picture = n.even? ? nil : picture_file('cherry-book.jpg')
  Book.create!(
    title: title,
    memo: memo,
    author: author,
    picture: picture
  )
end


puts '初期データの投入が完了しました。' # rubocop:disable Rails/Output
