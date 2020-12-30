# frozen_string_literal: true

module HealthChecks
  class Database
    include Helper

    def check
      [
        run_check('db.api.connection') do
          ActiveRecord::Base.connection
          ActiveRecord::Base.connected?
        end
      ]
    end

    def self.all_pass?(results)
      results.all? { |result| result[:pass] == true }
    end
  end
end
