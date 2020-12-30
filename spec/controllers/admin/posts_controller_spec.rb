# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::PostsController, type: :controller do
  let(:admin_user) { create(:admin_user) }
  let(:access_token) { JsonWebToken.encode(sub: admin_user.id) }
  let(:post_params) do
    {
      title: 'mock title',
      content: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua!'
    }
  end

  describe 'POST #create' do
    context 'with unauthenticated user' do
      context 'with valid parameters' do
        before do
          post :create, params: post_params
        end

        it 'returns a 401 response' do
          expect(response.status).to eq(401)
        end
      end
    end

    context 'with authorized admin user' do
      before do
        @request.headers['Authorization'] = "Bearer #{access_token}"
      end

      context 'with valid parameters' do
        before do
          post :create, params: post_params
        end

        it 'returns a 201 response' do
          expect(response.status).to eq(201)
        end
      end

      context 'with nil title' do
        let(:params) do
          {
            title: nil,
            content: post_params[:content]
          }
        end

        before { post :create, params: params }

        it 'returns a 422 response' do
          body = JSON.parse(response.body)
          expect(response.status).to eq(422)
          expect(body['error']['title']).to eq(["can't be blank"])
        end
      end

      context 'with nil content' do
        let(:params) do
          {
            title: post_params[:title],
            content: nil
          }
        end

        before { post :create, params: params }

        it 'returns a 422 response' do
          body = JSON.parse(response.body)
          expect(response.status).to eq(422)
          expect(body['error']['content']).to eq(["can't be blank"])
        end
      end
    end
  end
end
