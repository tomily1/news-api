# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { create(:user) }
  let(:access_token) do
    JsonWebToken.encode(sub: user.id)
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      let(:params) do
        {
          email: 'test@test.com',
          password: 'Testpassword1!'
        }
      end

      before do
        post :create, params: params
      end

      it 'returns a 200 response' do
        expect(response.status).to eq(200)
      end
    end

    context 'with invalid email' do
      let(:params) do
        {
          email: 'test@test',
          password: 'Testpassword1!'
        }
      end

      before { post :create, params: params }

      it 'returns a 422 response' do
        body = JSON.parse(response.body)
        expect(response.status).to eq(422)
        expect(body['error']['email']).to eq(['is not a valid email address'])
      end
    end

    context 'with email already in use' do
      before do
        post :create, params: { email: user.email, password: user.password }
      end

      it 'returns a 422 response' do
        body = JSON.parse(response.body)
        expect(response.status).to eq(422)
        expect(body['error']['email']).to eq(['has already been taken'])
      end
    end

    context 'with password < 6 characters' do
      let(:params) do
        {
          email: 'test@test.com',
          password: 'Test'
        }
      end

      before { post :create, params: params }

      it 'returns a 422 response' do
        body = JSON.parse(response.body)
        expect(response.status).to eq(422)
        expect(body['error']['password']).to eq(['is too short (minimum is 6 characters)'])
      end
    end
  end
end
