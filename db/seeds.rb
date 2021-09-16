# frozen_string_literal: true

require 'open-uri'

# queue_adapterを変更している理由とtransactionを使っている理由は下記URLを参照
# https://bootcamp.fjord.jp/questions/779#answer_2262
ActiveStorage::AnalyzeJob.queue_adapter = :inline

print '開発環境のデータをすべて削除して初期データを投入します。よろしいですか？[Y/n]: ' # rubocop:disable Rails/Output
unless $stdin.gets.chomp == 'Y'
  puts '中止しました。' # rubocop:disable Rails/Output
  return
end

def picture_file(name)
  File.open(Rails.root.join("db/seeds/#{name}"))
end

puts '実行中です。しばらくお待ちください...' # rubocop:disable Rails/Output

User.destroy_all

User.transaction do
  55.times do |n|
    name = Faker::Name.name
    User.create!(
      email: "sample-#{n}@example.com",
      password: 'password',
      name: name,
      postal_code: "123-#{n.to_s.rjust(4, '0')}",
      address: Faker::Address.full_address,
      self_introduction: "こんにちは、#{name}です。"
    )
  end
end

User.order(:id).each do |user|
  image_url = Faker::Avatar.image(slug: user.email, size: '150x150')
  user.avatar.attach(io: URI.parse(image_url).open, filename: 'avatar.png')
end

# User.destroy_all で全件削除されているはずだが念のため
Relationship.destroy_all

# 後輩が先輩を全員フォローする
User.order(id: :desc).each do |user|
  User.where('id < ?', user.id).each do |other|
    user.follow(other)
  end
end

Book.destroy_all

Book.transaction do # rubocop:disable Metrics/BlockLength
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

  55.times do
    Book.create!(
      title: Faker::Book.title,
      memo: Faker::Book.genre,
      author: Faker::Book.author,
      picture: picture_file('no-image.png')
    )
  end
end

Report.destroy_all

Report.transaction do # rubocop:disable Metrics/BlockLength
  Report.create!(
    title: '１日目',
    content: 'いい感じ',
    user_id: 1,
    created_at: Time.zone.now - 1.day
  )

  Report.create!(
    title: '２日目',
    content: '超々いいかんじ',
    user_id: 1,
    created_at: Time.zone.now - 2.days
  )

  Report.create!(
    title: '３日目',
    content: '超々々々いいカンジ',
    user_id: 1,
    created_at: Time.zone.now - 3.days
  )

  55.times do |n|
    Report.create!(
      title: Faker::Lorem.word,
      content: Faker::Lorem.sentence,
      user_id: n % 5 + 1,
      created_at: Time.zone.now - (n + 4).days
    )
  end
end

Comment.destroy_all

Comment.transaction do # rubocop:disable Metrics/BlockLength
  Comment.create!(
    body: 'body1',
    commentable: Book.first,
    user_id: 1
  )

  Comment.create!(
    body: 'body2',
    commentable: Book.first,
    user_id: 2
  )

  Comment.create!(
    body: 'body3',
    commentable: Report.first,
    user_id: 1
  )

  Comment.create!(
    body: 'body4',
    commentable: Report.first,
    user_id: 3
  )

  20.times do |n|
    Comment.create!(
      body: Faker::Lorem.sentence,
      commentable: Book.all[n % 3],
      user_id: n % 4 + 1
    )
  end

  20.times do |n|
    Comment.create!(
      body: Faker::Lorem.sentence,
      commentable: Report.all[n % 4],
      user_id: n % 3 + 1
    )
  end
end

puts '初期データの投入が完了しました。' # rubocop:disable Rails/Output
