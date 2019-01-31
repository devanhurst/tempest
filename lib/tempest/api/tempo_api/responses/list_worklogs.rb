require_relative '../response'
require_relative '../models/worklog'
require_relative '../../../helpers/time_helper'

module TempoAPI
  module Responses
    class ListWorklogs < TempoAPI::Response
      include Tempest::Helpers::TimeHelper

      private

      attr_reader :worklogs

      def success_message
        output = ""
        output << worklogs_output
        output << "\nTOTAL TIME LOGGED: #{total_hours_spent} hours."
      end

      def worklogs
        @worklogs ||= raw_response['results'].map do |worklog|
          TempoAPI::Models::Worklog.new(
            id: worklog['tempoWorklogId'],
            issue: worklog.dig('issue', 'key'),
            seconds: worklog['timeSpentSeconds'],
            description: worklog['description']
          )
        end
      end

      def worklogs_output
        worklogs.map(&:to_s).join("\n")
      end

      def total_hours_spent
        worklogs.map(&:hours).reduce(:+).round(2) || 0
      end
    end
  end
end