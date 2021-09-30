# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :request do # rubocop:disable Metrics/BlockLength
  describe '#index' do
    context 'as an authenticated user' do
      it 'responds successfully' do
        user = FactoryBot.create(:user)
        sign_in user
        get users_path
        expect(response).to be_successful
        expect(response).to have_http_status '200'
      end
    end

    context 'as a guest' do
      it 'redirects to the sign-in page returning 302' do
        get users_path
        expect(response).to redirect_to new_user_session_path
        expect(response).to have_http_status '302'
      end
    end
  end

  describe '#show' do
    let!(:user) { FactoryBot.create(:user) }

    context 'as an authenticated user' do
      it 'responds successfully' do
        sign_in user
        get user_path(user)
        expect(response).to be_successful
        expect(response).to have_http_status '200'
      end

      context 'as a guest' do
        it 'redirects to the sign-in page returning 302' do
          get user_path(user)
          expect(response).to have_http_status '302'
          expect(response).to redirect_to new_user_session_path
        end
      end
    end
  end
end
