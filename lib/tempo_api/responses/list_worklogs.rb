require_relative '../response'
require_relative '../models/worklog'
require_relative '../../tempest/helpers/time_helper'

module Tempest
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
        worklogs.map { |log| log.hours }.reduce(:+) || 0
      end
    end
  end
end