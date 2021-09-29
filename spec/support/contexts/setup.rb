# frozen_string_literal: true

RSpec.shared_context 'setup' do
  let(:user) { FactoryBot.create(:user) }
  let(:report) { FactoryBot.create(:report, user: user) }
end
