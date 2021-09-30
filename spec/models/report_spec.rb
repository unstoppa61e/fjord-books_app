# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Report, type: :model do
  describe 'report validity' do
    context 'with a title and a content' do
      it 'is valid' do
        report = FactoryBot.build_stubbed(:report)
        expect(report).to be_valid
      end
    end

    context 'without a title' do
      it 'is invalid' do
        report = FactoryBot.build_stubbed(:report, title: nil)
        report.valid?
        expect(report.errors[:title]).to include(I18n.t('errors.messages.blank'))
      end
    end

    context 'without a content' do
      it 'is invalid' do
        report = FactoryBot.build_stubbed(:report, content: nil)
        report.valid?
        expect(report.errors[:content]).to include(I18n.t('errors.messages.blank'))
      end
    end
  end

  describe '#editable?' do
    let!(:report) { FactoryBot.create(:report) }

    context 'for the author of a report' do
      it 'is editable' do
        expect(report.editable?(User.find(report.user_id))).to eq(true)
      end
    end

    context 'for a user who is not the author of a report' do
      it 'is not editable' do
        user = FactoryBot.create(:user)
        expect(report.editable?(user)).to eq(false)
      end
    end
  end

  describe '#created_on' do
    it "returns a report's creation date" do
      report = FactoryBot.create(:report)
      expect(report.created_on).to eq report.created_at.to_date
    end
  end
end
