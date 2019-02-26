# frozen_string_literal: true

require_relative '../response'
require_relative '../../../helpers/time_helper'

module TempoAPI
  module Responses
    class GetUserSchedule < TempoAPI::Response
      include TempestTime::Helpers::TimeHelper

      def required_seconds
        results.map { |result| result['requiredSeconds'] }.reduce(:+)
      end

      private

      def results
        @results = raw_response['results'] || []
      end
    end
  end
end
