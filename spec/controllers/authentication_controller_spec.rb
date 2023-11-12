# spec/controllers/authentication_controller_spec.rb

require 'rails_helper'

RSpec.describe AuthenticationController, type: :controller do
  describe 'POST #create' do
    context 'with valid credentials' do
      it 'returns a token' do
        post :create, params: { username: 'admin', password: 'admin' }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['token']).to be_present
      end
    end

    context 'with invalid credentials' do
      it 'returns an unauthorized status' do
        post :create, params: { username: 'admin', password: 'wrong' }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
