require 'rails_helper'

RSpec.describe Report, type: :model do
  before do
    @user1 = User.create(
      name: 'user1',
      email: "hoge@example.com",
      password: "password"
    )
    @user1_report = @user1.reports.create(
      title: 'title',
      content: 'content'
    )
  end

  it 'is valid with a title and a content' do
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
    expect(@user1_report.editable?(@user1)).to eq(true)
  end

  it "is impossible for a user edit an other user's report" do
    user2 = User.create(
      email: "fuga@example.com",
      password: "password"
    )
    expect(@user1_report.editable?(user2)).to eq(false)
  end

  it "returns a report's creation date" do
    expect(@user1_report.created_on).to eq @user1_report.created_at.to_date
  end
end
