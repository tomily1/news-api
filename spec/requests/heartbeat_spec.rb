# frozen_string_literal: true

require 'rails_helper'

describe 'GET /heartbeat', type: :request do
  it 'successfully run status check' do
    get '/heartbeat'
    expect(response.status).to eq 200
  end
end
