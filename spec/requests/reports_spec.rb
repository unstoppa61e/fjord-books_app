# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Reports', type: :request do # rubocop:disable Metrics/BlockLength
  include_context 'setup'

  describe '#index' do
    context 'as an authorized user' do
      it 'responds successfully' do
        sign_in user
        get reports_path
        aggregate_failures do
          expect(response).to be_successful
          expect(response).to have_http_status '200'
        end
      end
    end

    context 'as a guest' do
      it 'redirects to new user session path returning 302' do
        get reports_path
        aggregate_failures do
          expect(response).to redirect_to new_user_session_path
          expect(response).to have_http_status '302'
        end
      end
    end
  end

  describe '#show' do
    context 'as an authorized user' do
      it 'responds successfully' do
        sign_in user
        get report_path(report)
        aggregate_failures do
          expect(response).to be_successful
          expect(response).to have_http_status '200'
        end
      end
    end

    context 'as a guest' do
      it 'redirects to new user session path' do
        get report_path(report)
        aggregate_failures do
          expect(response).to redirect_to new_user_session_path
          expect(response).to have_http_status '302'
        end
      end
    end
  end

  describe '#new' do
    context 'as an authorized user' do
      it 'responds successfully' do
        sign_in user
        get new_report_path
        aggregate_failures do
          expect(response).to be_successful
          expect(response).to have_http_status '200'
        end
      end
    end

    context 'as a guest' do
      it 'redirects to new user session path returning 302' do
        get new_report_path
        aggregate_failures do
          expect(response).to redirect_to new_user_session_path
          expect(response).to have_http_status '302'
        end
      end
    end
  end

  describe '#edit' do
    context 'as an authorized user' do
      it 'responds successfully' do
        sign_in user
        get edit_report_path(report)
        aggregate_failures do
          expect(response).to be_successful
          expect(response).to have_http_status '200'
        end
      end
    end

    context 'as a guest' do
      it 'redirects to new user session path returning 302' do
        get edit_report_path(report)
        aggregate_failures do
          expect(response).to redirect_to new_user_session_path
          expect(response).to have_http_status '302'
        end
      end
    end
  end

  describe '#create' do # rubocop:disable Metrics/BlockLength
    context 'as an authenticated user' do
      context 'with valid attributes' do
        it 'adds a report' do
          report_params = FactoryBot.attributes_for(:report)
          sign_in user
          expect { post reports_path, params: { report: report_params } }.to change(user.reports, :count).by(1)
        end
      end

      context 'with invalid attributes' do
        it "doesn't add a report" do
          report_params = FactoryBot.attributes_for(:report, :invalid)
          sign_in user
          expect { post reports_path, params: { report: report_params } }.to_not change(user.reports, :count)
        end
      end
    end

    context 'as a guest' do
      before do
        @report_params = FactoryBot.attributes_for(:report)
      end

      it 'redirects to new user session path returning 302' do
        post reports_path, params: { report: @report_params }
        aggregate_failures do
          expect(response).to redirect_to new_user_session_path
          expect(response).to have_http_status '302'
        end
      end
    end
  end

  describe '#update' do # rubocop:disable Metrics/BlockLength
    context 'as an authenticated user' do
      context 'with valid attributes' do
        it 'updates a report' do
          title = 'New Title'
          content = 'New Content'
          report_params = FactoryBot.attributes_for(:report, title: title, content: content)
          sign_in user
          patch report_path(report), params: { report: report_params }
          expect(report.reload.title).to eq title
          expect(report.reload.content).to eq content
        end
      end

      context 'with invalid attributes' do
        it "doesn't update a report" do
          old_title = report.title
          old_content = report.content
          report_params = FactoryBot.attributes_for(:report, title: '', content: '')
          sign_in user
          patch report_path(report), params: { report: report_params }
          expect(report.reload.title).to eq old_title
          expect(report.reload.content).to eq old_content
        end
      end
    end

    context 'as a guest' do
      before do
        @old_title = 'old title'
        @old_content = 'old content'
        @other_user_report = FactoryBot.create(:report, title: @old_title, content: @old_content)
        title = 'New Title'
        content = 'New Content'
        @report_params = FactoryBot.attributes_for(:report, title: title, content: content)
      end

      it "doesn't update a report's title" do
        sign_in user
        patch report_path(@other_user_report), params: { report: @report_params }
        expect(@other_user_report.reload.title).to eq @old_title
      end

      it "doesn't update a report's content" do
        sign_in user
        patch report_path(@other_user_report), params: { report: @report_params }
        expect(@other_user_report.reload.content).to eq @old_content
      end

      it 'redirects to root_path returning 302' do
        sign_in user
        patch report_path(@other_user_report), params: { report: @report_params }
        aggregate_failures do
          expect(response).to redirect_to root_path
          expect(response).to have_http_status '302'
        end
      end
    end
  end

  describe '#destroy' do # rubocop:disable Metrics/BlockLength
    context 'as an authenticated user' do
      before do
        @report = FactoryBot.create(:report, user: user)
      end

      it 'deletes a report' do
        sign_in user
        expect { delete report_path(@report) }.to change(user.reports, :count).by(-1)
      end

      it 'redirects to reports_url returning 302' do
        sign_in user
        delete report_path(report)
        aggregate_failures do
          expect(response).to redirect_to reports_url
          expect(response).to have_http_status '302'
        end
      end
    end

    context 'as an unauthorized user' do
      before do
        @report = FactoryBot.create(:report)
      end

      it "doesn't delete a report" do
        sign_in user
        expect { delete report_path(@report) }.to_not change(user.reports, :count)
      end

      it 'redirects to new user session path returning 302' do
        sign_in user
        delete report_path(@report)
        aggregate_failures do
          expect(response).to redirect_to root_path
          expect(response).to have_http_status '302'
        end
      end
    end

    context 'as a guest' do
      before do
        @report = FactoryBot.create(:report)
      end

      it "doesn't delete a report" do
        expect { delete report_path(@report) }.to_not change(user.reports, :count)
      end

      it 'redirects to new user session path returning 302' do
        delete report_path(@report)
        aggregate_failures do
          expect(response).to redirect_to new_user_session_path
          expect(response).to have_http_status '302'
        end
      end
    end
  end
end
