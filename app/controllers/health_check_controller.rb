# frozen_string_literal: true

class HealthCheckController < ApplicationController
  def show
    results = HealthChecks::Database.new.check
    all_pass = HealthChecks::Database.all_pass?(results)

    render json: { results: results, status: all_pass ? :ok : :internal_server_error }
  end
end
