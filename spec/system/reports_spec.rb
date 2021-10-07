# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Reports', type: :system do
  it 'creates a new report' do
    user = create(:user)
    sign_in_as user
    visit root_path
    click_link Report.model_name.human
    click_link I18n.t('views.common.new')
    title = 'title'
    content = 'content'
    expect do
      fill_in 'report_title', with: title
      fill_in 'report_content', with: content
      find('input[type=submit]').click
    end.to change(user.reports, :count).by(1)

    expect(page).to have_content I18n.t('views.common.title_show', name: Report.model_name.human)
    expect(page).to have_content I18n.t('controllers.common.notice_create', name: Report.model_name.human)
    expect(page).to have_content "#{Report.human_attribute_name(:title)}: #{title}"
    expect(page).to have_content "#{Report.human_attribute_name(:content)}:"
    expect(page).to have_content content
    expect(page).to have_content "#{Report.human_attribute_name(:user)}: "
    expect(page).to have_link user.name, href: user_path(user)
    expect(page).to have_content "#{Report.human_attribute_name(:created_on)}: #{I18n.l(Report.last.created_on)}"
    expect(page).to have_content "#{Comment.model_name.human}: （コメントがありません）"
  end
end
