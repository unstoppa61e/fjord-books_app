# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :request do # rubocop:disable Metrics/BlockLength
  include_context 'setup'

  describe '#index' do
    context 'as an authenticated user' do
      it 'responds successfully' do
        sign_in user
        get users_path
        expect(response).to be_successful
      end

      it 'returns a 200 response' do
        sign_in user
        get users_path
        expect(response).to have_http_status '200'
      end
    end

    context 'as a guest' do
      it 'returns a 302 response' do
        get users_path
        expect(response).to have_http_status '302'
      end

      it 'redirects to the sign-in page' do
        get users_path
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe '#show' do
    context 'as an authenticated user' do
      it 'responds successfully' do
        sign_in user
        get user_path(user)
        expect(response).to be_successful
      end

      it 'returns a 200 response' do
        sign_in user
        get user_path(user)
        expect(response).to have_http_status '200'
      end
    end
  end
end
