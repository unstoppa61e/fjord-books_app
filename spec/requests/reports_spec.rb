# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Reports', type: :request do # rubocop:disable Metrics/BlockLength
  describe '#index' do
    context 'as an authenticated user' do
      it 'responds successfully' do
        user = create(:user)
        sign_in user
        get reports_path
        expect(response).to be_successful
      end
    end

    context 'as a guest' do
      it 'redirects to new user session path returning 302' do
        get reports_path
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe '#show' do
    let!(:report) { create(:report) }

    context 'as an authenticated user' do
      context 'when the report corresponding to param exists' do
        it 'responds successfully' do
          sign_in report.user
          get report_path(report)
          expect(response).to be_successful
        end
      end

      context 'when the report corresponding to param does not exist' do
        it 'returns 404 not found' do
          sign_in report.user
          get report_path(id: Report.last.id + 1)
          expect(response).to have_http_status :not_found
        end
      end
    end

    context 'as a guest' do
      it 'redirects to new user session path' do
        get report_path(report)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe '#new' do
    context 'as an authenticated user' do
      it 'responds successfully' do
        user = create(:user)
        sign_in user
        get new_report_path
        expect(response).to be_successful
      end
    end

    context 'as a guest' do
      it 'redirects to new user session path returning 302' do
        get new_report_path
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe '#edit' do
    let!(:report) { create(:report) }

    context 'as an authenticated user' do
      it 'responds successfully' do
        sign_in report.user
        get edit_report_path(report)
        expect(response).to be_successful
      end
    end

    context 'as a guest' do
      it 'redirects to new user session path returning 302' do
        get edit_report_path(report)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe '#create' do
    context 'as an authenticated user' do
      let!(:user) { create(:user) }

      context 'with valid attributes' do
        it 'adds a report' do
          sign_in user
          report_params = attributes_for(:report)
          expect { post reports_path, params: { report: report_params } }.to change(user.reports, :count).by(1)
        end
      end

      context 'with invalid attributes' do
        it "doesn't add a report" do
          sign_in user
          report_params = attributes_for(:report, :invalid)
          expect { post reports_path, params: { report: report_params } }.to_not change(user.reports, :count)
        end
      end
    end

    context 'as a guest' do
      it 'redirects to new user session path returning 302' do
        report_params = attributes_for(:report)
        post reports_path, params: { report: report_params }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe '#update' do # rubocop:disable Metrics/BlockLength
    let(:report) { create(:report) }

    context 'as an authenticated user' do # rubocop:disable Metrics/BlockLength
      context 'with valid attributes' do
        it 'updates a report' do
          title = 'New Title'
          content = 'New Content'
          report_params = attributes_for(:report, title: title, content: content)
          sign_in report.user
          patch report_path(report), params: { report: report_params }
          expect(report.reload.title).to eq title
          expect(report.reload.content).to eq content
        end
      end

      context 'with invalid attributes' do
        context 'without a title' do
          it "doesn't update the title" do
            old_title = report.title
            report_params = attributes_for(:report, title: '')
            sign_in report.user
            patch report_path(report), params: { report: report_params }
            expect(report.reload.title).to eq old_title
          end
        end

        context 'without a content' do
          it "doesn't update the content" do
            old_content = report.content
            report_params = attributes_for(:report, content: '')
            sign_in report.user
            patch report_path(report), params: { report: report_params }
            expect(report.reload.content).to eq old_content
          end
        end
      end
    end

    context 'as an unauthenticated user' do
      let(:user) { create(:user) }
      let(:report_params) { attributes_for(:report) }

      it "doesn't update a report's title" do
        sign_in user
        old_title = 'old title'
        report = create(:report, title: old_title)
        patch report_path(report), params: { report: report_params }
        expect(report.reload.title).to eq old_title
      end

      it "doesn't update a report's content" do
        sign_in user
        old_content = 'old content'
        report = create(:report, content: old_content)
        patch report_path(report), params: { report: report_params }
        expect(report.reload.content).to eq old_content
      end

      it 'returns 404 not found' do
        sign_in user
        report = create(:report)
        patch report_path(report), params: { report: report_params }
        expect(response).to have_http_status :not_found
      end
    end
  end

  describe '#destroy' do # rubocop:disable Metrics/BlockLength
    let!(:report) { create(:report) }

    context 'as an authenticated user' do
      it 'deletes a report' do
        sign_in report.user
        expect { delete report_path(report) }.to change(report.user.reports, :count).by(-1)
      end

      it 'redirects to reports_url returning 302' do
        sign_in report.user
        delete report_path(report)
        expect(response).to redirect_to reports_url
      end
    end

    context 'as an unauthenticated user' do
      let!(:user) { create(:user) }

      it "doesn't delete a report" do
        sign_in user
        expect { delete report_path(report) }.to_not change(user.reports, :count)
      end

      it 'returns 404 not found' do
        sign_in user
        delete report_path(report)
        expect(response).to have_http_status :not_found
      end
    end

    context 'as a guest' do
      it "doesn't delete a report" do
        expect { delete report_path(report) }.to_not change(report.user.reports, :count)
      end

      it 'redirects to new user session path returning 302' do
        delete report_path(report)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
