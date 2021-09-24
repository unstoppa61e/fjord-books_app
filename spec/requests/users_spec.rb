require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'GET /index' do
    it 'responds successfully returns a 200 response' do
      user = FactoryBot.create(:user)
      sign_in user
      get users_path
      expect(response).to be_successful
      expect(response).to have_http_status '200'
    end
  end

  describe 'GET /show' do
    it 'responds successfully returns a 200 response' do
      user = FactoryBot.create(:user)
      sign_in user
      get user_path(user)
      expect(response).to be_successful
      expect(response).to have_http_status '200'
    end
  end
end
