# frozen_string_literal: true

require 'rails_helper'

describe 'GET /healthcheck', type: :request do
  it 'successfully run status check' do
    get '/healthcheck'
    body = JSON.parse(response.body)
    expect(body['status']).to eq 'ok'
  end

  it 'returns error response status when some checks fails' do
    allow(ActiveRecord::Base).to receive(:connected?).and_return(false)

    get '/healthcheck'
    body = JSON.parse(response.body)
    expect(body['status']).to eq 'internal_server_error'
  end
end
