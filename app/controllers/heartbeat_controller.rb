# frozen_string_literal: true

class HeartbeatController < ApplicationController
  def show
    render json: { status: 'OK' }
  end
end
