# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Report, type: :model do # rubocop:disable Metrics/BlockLength
  describe 'report validity' do
    context 'with a title and a content' do
      it 'is valid' do
        report = FactoryBot.build_stubbed(:report)
        expect(report).to be_valid
      end
    end

    it { is_expected.to validate_presence_of :title }
    it { is_expected.to validate_presence_of :content }
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
