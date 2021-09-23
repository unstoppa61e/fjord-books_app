require 'rails_helper'

RSpec.describe Report, type: :model do
  # it 'is valid with a title and a content' do
  #   report = Report.new(
  #     title: 'title',
  #     content: 'content',
  #     user_id: 1
  #   )
  #   expect(report).to be_valid
  # end

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
end
