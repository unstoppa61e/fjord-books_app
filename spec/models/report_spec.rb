# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Report, type: :model do # rubocop:disable Metrics/BlockLength
  it 'is valid with a title and a content' do
    report = FactoryBot.build_stubbed(:report)
    expect(report).to be_valid
  end

  it 'is invalid without a title' do
    report = FactoryBot.build_stubbed(:report, title: nil)
    report.valid?
    expect(report.errors[:title]).to include(I18n.t('errors.messages.blank'))
  end

  it 'is invalid without a content' do
    report = FactoryBot.build_stubbed(:report, content: nil)
    report.valid?
    expect(report.errors[:content]).to include(I18n.t('errors.messages.blank'))
  end

  it 'is possible for the author of a report to edit it' do
    report = FactoryBot.create(:report)
    expect(report.editable?(User.find(report.user_id))).to eq(true)
  end

  it "is impossible for a user edit an other user's report" do
    user = FactoryBot.create(:user)
    report = FactoryBot.create(:report)
    expect(report.editable?(user)).to eq(false)
  end

  it "returns a report's creation date" do
    report = FactoryBot.create(:report)
    expect(report.created_on).to eq report.created_at.to_date
  end
end
