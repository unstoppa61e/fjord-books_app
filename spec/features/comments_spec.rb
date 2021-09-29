require 'rails_helper'

RSpec.feature "Comments", type: :feature do
  scenario 'user creates a comment for a report' do
    user = FactoryBot.create(:user)
    report = FactoryBot.create(:report)

    visit
  end
end
