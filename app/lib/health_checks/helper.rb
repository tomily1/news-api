# frozen_string_literal: true

module HealthChecks
  module Helper
    def run_check(name)
      results = {
        kind: self.class.to_s,
        name: name,
        pass: false
      }
      begin
        results[:pass] = yield
      rescue StandardError => e
        results[:message] = "#{e.class}: #{e.message}"
      end
      results
    end
  end
end
