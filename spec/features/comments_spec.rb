# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Comments', type: :feature do
  include_context 'setup'

  scenario 'user creates a comment for a report' do
    sign_in report.user
    visit report_path(report)
    expect do
      content = 'comment content'
      fill_in 'comment_content', with: content
      find('input[type=submit]').click
      expect(page).to have_content content
      expect(page).to have_link report.user.name, href: user_path(report.user)
      expect(page).to have_content I18n.l(report.comments.last.created_at, format: :short)
    end.to change(report.comments, :count).by(1)
  end
end
