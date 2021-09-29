require 'rails_helper'

RSpec.feature "Reports", type: :feature do
  scenario 'user creates a new report' do
    user = FactoryBot.create(:user)

    visit new_user_session_path
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password
    find('input[type=submit]').click
    click_link Report.model_name.human

    expect {
      title = 'title'
      content = 'content'
      click_link I18n.t('views.common.new')
      fill_in 'report_title', with: title
      fill_in 'report_content', with: content
      find('input[type=submit]').click
      expect(page).to have_content I18n.t('views.common.title_show', name: Report.model_name.human)
      expect(page).to have_content I18n.t('controllers.common.notice_create', name: Report.model_name.human)
      expect(page).to have_content "#{Report.human_attribute_name(:title)}: #{title}"
      expect(page).to have_content "#{Report.human_attribute_name(:content)}:"
      expect(page).to have_content content
      expect(page).to have_content "#{Report.human_attribute_name(:user)}: "
      expect(page).to have_link user.name, href: user_path(user)
      expect(page).to have_content "#{Report.human_attribute_name(:created_on)}: #{I18n.l(Report.last.created_on)}"
      expect(page).to have_content "#{Comment.model_name.human}: （コメントがありません）"
    }.to change(user.reports, :count).by(1)
  end
end
