# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Comments', type: :system do
  it 'creates a comment for a report' do
    report = create(:report)
    user = create(:user)
    sign_in user
    visit report_path(report)
    content = 'comment content'
    expect do
      fill_in 'comment_content', with: content
      find('input[type=submit]').click
    end.to change(report.comments, :count).by(1)

    expect(page).to have_content content
    expect(page).to have_link user.name, href: user_path(user)
    expect(page).to have_content I18n.l(report.comments.last.created_at, format: :short)
  end
end
