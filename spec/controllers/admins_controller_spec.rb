# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AdminsController, type: :controller do
  let(:super_admin_user) { create(:admin_user, :super_admin) }
  let(:admin_user) { create(:admin_user) }
  let(:user) { create(:user) }

  def access_token(user)
    JsonWebToken.encode(sub: user.id)
  end

  describe 'POST #create' do
    context 'unauthenticated user' do
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

        it 'returns a 401 response' do
          expect(response.status).to eq(401)
        end
      end
    end

    context 'unauthorized admin user' do
      context 'with valid parameters' do
        let(:params) do
          {
            email: 'test@test.com',
            password: 'Testpassword1!'
          }
        end

        before do
          @request.headers['Authorization'] = "Bearer #{access_token(admin_user)}"
          post :create, params: params
        end

        it 'returns a 401 response' do
          expect(response.status).to eq(401)
        end
      end
    end

    context 'authorized super_admin user' do
      before do
        @request.headers['Authorization'] = "Bearer #{access_token(super_admin_user)}"
      end

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
          post :create, params: { email: admin_user.email, password: admin_user.password }
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

  describe 'POST /login' do
    context '200' do
      before do
        post :login, params: { email: admin_user.email, password: admin_user.password }
      end

      it 'should respond with an access token when passed authorized params' do
        body = JSON.parse(response.body)
        expect(response.status).to eq 200
        expect(body.keys).to include('access_token')
      end

      it "should respond with an access token type 'Bearer' when passed authorized params" do
        body = JSON.parse(response.body)
        expect(body['token_type']).to eq('Bearer')
      end
    end

    context 'ignore email letter case' do
      before do
        post :login, params: { email: admin_user.email.upcase, password: admin_user.password }
      end

      it 'should ignore letter casing of email param' do
        body = JSON.parse(response.body)
        expect(response.status).to eq 200
        expect(body.keys).to include('access_token')
      end
    end

    context '401' do
      context 'when an email is provided' do
        before do
          post :login, params: { email: admin_user.email, password: 'WrongPassword' }
        end

        it 'should respond with unauthorized when passed incorrect params' do
          expect(response.status).to eq 401
        end
      end

      context 'when an email is not provided' do
        before do
          post :login, params: { email: nil, password: 'WrongPassword' }
        end

        it 'should respond with unauthorized when passed blank/nil params' do
          expect(response.status).to eq 401
        end
      end
    end
  end
end
