# frozen_string_literal: true

require 'rails_helper'

describe AuthenticationController, type: :controller do
  let!(:user) { create(:user) }

  describe 'POST /login' do
    context '200' do
      before do
        post :login, params: { email: user.email, password: user.password }
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
        post :login, params: { email: user.email.upcase, password: user.password }
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
          post :login, params: { email: user.email, password: 'WrongPassword' }
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

  describe 'POST /logout' do
    context '200' do
      before do
        access_token = JsonWebToken.encode(sub: user.id)
        @request.headers['Authorization'] = "Bearer #{access_token}"
        post :logout
      end

      it 'should respond with 200 for new token' do
        body = JSON.parse(response.body)
        expect(response.status).to eq 200
        expect(body['message']).to eq('logged out')
      end
    end

    context '401' do
      before do
        access_token = JsonWebToken.encode(sub: user.id)
        TokenBlacklist.create(jwt_token: access_token, expiration_date: 1.hour.from_now)
        @request.headers['Authorization'] = "Bearer #{access_token}"
        post :logout
      end

      it 'should respond with 401 for already blacklisted token' do
        expect(response.status).to eq 401
      end
    end

    context 'invalid signature' do
      before do
        @request.headers['Authorization'] = 'Bearer test.qwerty'
        post :logout
      end

      it 'should respond with 401' do
        expect(response.status).to eq 401
      end
    end

    context 'verification error' do
      before do
        allow_any_instance_of(ApplicationController).to receive(:authorize_request).and_raise(JWT::VerificationError)
        @request.headers['Authorization'] = 'Bearer test.qwerty'
        post :logout
      end

      it 'should respond with 422' do
        expect(response.status).to eq 422
      end
    end
  end
end
