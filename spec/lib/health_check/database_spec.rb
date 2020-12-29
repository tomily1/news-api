# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HealthChecks::Database do
  subject(:healthcheck) do
    described_class.new
  end

  describe 'checks' do
    it 'should run checks on connections' do
      health_check = healthcheck.check
      expect(health_check.count).to eq 1
      expect(health_check.any? { |check| check[:name] == 'db.api.connection' }).to eq true
    end
  end
end
