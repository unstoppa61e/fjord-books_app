require 'rails_helper'

RSpec.describe Report, type: :model do
  it 'is valid with a title and a content' do
    User.create(
      email: 'hoge@example.com',
      password: 'password'
    )
    report = Report.new(
      title: 'title',
      content: 'content',
      user_id: 1
    )
    expect(report).to be_valid
  end

  it 'is invalid without a title' do
    report = Report.new(title: nil)
    report.valid?
    expect(report.errors[:title]).to include(I18n.t('errors.messages.blank'))
  end

  it 'is invalid without a content' do
    report = Report.new(content: nil)
    report.valid?
    expect(report.errors[:content]).to include(I18n.t('errors.messages.blank'))
  end

  it "is possible for the author of a report to edit it" do
    user = User.create(
      email: 'hoge@example.com',
      password: 'password'
    )
    report = user.reports.create(
      title: 'title',
      content: 'content'
    )
    expect(report.editable?(user)).to eq(true)
  end

  it "is impossible for a user edit an other user's report" do
    user1 = User.create(
      email: 'hoge@example.com',
      password: 'password'
    )
    user2 = User.create(
      email: 'fuga@example.com',
      password: 'password'
    )
    report = user1.reports.create(
      title: 'title',
      content: 'content'
    )
    expect(report.editable?(user2)).to eq(false)
  end

  it "returns a report's creation date" do
    User.create(
      email: 'hoge@example.com',
      password: 'password'
    )
    report = Report.create(
      title: 'title',
      content: 'content',
      user_id: 1
    )
    expect(report.created_on).to eq report.created_at.to_date
  end
end
