require 'rails_helper'

RSpec.describe "Reports", type: :request do
  describe "#create" do
    context 'as an authenticated user' do
      before do
        @user = FactoryBot.create(:user)
      end

      it 'adds a report' do
        report_params = FactoryBot.attributes_for(:report)
        sign_in @user
        expect {
          post reports_path, params: { report: report_params }
        }.to change(@user.reports, :count).by(1)
      end
    end

    context 'as a guest' do
      it 'returns a 302 response' do
        report_params = FactoryBot.attributes_for(:report)
        post reports_path, params: { report: report_params }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe '#update' do
    context 'as an authenticated user' do
      before do
        @user = FactoryBot.create(:user)
        @report = FactoryBot.create(:report, user: @user)
      end

      it 'updates a report' do
        title = 'New Title'
        content = 'New Content'
        report_params = FactoryBot.attributes_for(:report, title: title, content: content)
        sign_in @user
        patch report_path(@report), params: { report: report_params }
        expect(@report.reload.title).to eq title
        expect(@report.reload.content).to eq content
      end
    end

    context 'as a guest' do
      before do
        @user = FactoryBot.create(:user)
        other_user = FactoryBot.create(:user)
        @old_title = 'old title'
        @old_content = 'old content'
        @other_user_report = FactoryBot.create(:report, user: other_user, title: @old_title, content: @old_content)
        title = 'New Title'
        content = 'New Content'
        @report_params = FactoryBot.attributes_for(:report, title: title, content: content)
      end

      it "doesn't update a report's title" do
        sign_in @user
        patch report_path(@other_user_report), params: { report: @report_params }
        expect(@other_user_report.reload.title).to eq @old_title
      end

      it "doesn't update a report's content" do
        sign_in @user
        patch report_path(@other_user_report), params: { report: @report_params }
        expect(@other_user_report.reload.content).to eq @old_content
      end

      it "redirects to root_path" do
        sign_in @user
        patch report_path(@other_user_report), params: { report: @report_params }
        assert_redirected_to root_path
      end
    end
  end
end
