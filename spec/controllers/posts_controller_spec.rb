# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  let(:user) { create(:user) }
  let(:admin_user) { create(:admin_user) }
  let!(:post) { create(:post) }
  let(:access_token) { JsonWebToken.encode(sub: user.id) }
  let(:admin_access_token) do
    admin_user.generate_token
    JsonWebToken.encode(sub: admin_user.token)
  end

  before do
    10.times { create(:post) }
  end

  describe 'GET #index' do
    context 'with unauthenticated user' do
      it 'returns a 401 response' do
        get :index
        expect(response.status).to eq(401)
      end
    end

    context 'with authenticated user' do
      context 'without pagination' do
        before do
          @request.headers['Authorization'] = "Bearer #{access_token}"
          get :index
        end

        it 'returns a 200 response' do
          expect(response.status).to eq(200)
        end

        it 'returns max set records with no pagination set' do
          body = JSON.parse(response.body)
          expect(body['data'].count).to eq(11)
          expect(body['meta']).to eq({ 'total_pages' => 1, 'records' => 11 })
        end
      end

      context 'with pagination' do
        before do
          @request.headers['Authorization'] = "Bearer #{access_token}"
          get :index, params: { page: 1, per_page: 5 }
        end

        it 'returns a 200 response' do
          expect(response.status).to eq(200)
        end

        it 'returns max set records with no pagination set' do
          body = JSON.parse(response.body)
          expect(body['data'].count).to eq(5)
          expect(body['meta']).to eq({ 'total_pages' => 3, 'records' => 11 })
        end
      end
    end
  end

  describe 'GET #show' do
    context 'with unauthenticated user' do
      it 'returns a 401 response' do
        get :show, params: { id: post.id }
        expect(response.status).to eq(401)
      end
    end

    context 'with authenticated user' do
      context 'found' do
        before do
          @request.headers['Authorization'] = "Bearer #{access_token}"
          get :show, params: { id: post.id }
        end

        it 'returns a 200 response' do
          expect(response.status).to eq(200)
        end

        it 'returns the record' do
          body = JSON.parse(response.body)
          expect(body['data'].keys).to include('title', 'content')
        end
      end

      context 'not_found' do
        before do
          @request.headers['Authorization'] = "Bearer #{access_token}"
          get :show, params: { id: '123abc' }
        end

        it 'returns a 404 response' do
          expect(response.status).to eq(404)
        end
      end
    end

    context 'with authenticated admin_user' do
      context 'found' do
        before do
          @request.headers['Authorization'] = "Bearer #{admin_access_token}"
          get :show, params: { id: post.id }
        end

        it 'returns a 200 response' do
          expect(response.status).to eq(200)
        end

        it 'returns the record' do
          body = JSON.parse(response.body)
          expect(body['data'].keys).to include('title', 'content')
        end
      end

      context 'not_found' do
        before do
          @request.headers['Authorization'] = "Bearer #{admin_access_token}"
          get :show, params: { id: 'abc' }
        end

        it 'returns a 404 response' do
          expect(response.status).to eq(404)
        end
      end
    end
  end
end
