require_relative '../response'
require_relative '../models/worklog'
require_relative '../../../helpers/time_helper'

module TempoAPI
  module Responses
    class ListWorklogs < TempoAPI::Response
      include TempestTime::Helpers::TimeHelper

      attr_reader :worklogs, :total_hours_spent

      def worklogs
        @worklogs ||= raw_response['results'].map do |worklog|
          TempoAPI::Models::Worklog.new(
            id: worklog['tempoWorklogId'],
            issue: worklog.dig('issue', 'key'),
            seconds: worklog['timeSpentSeconds'],
            description: worklog['description']
          )
        end.sort_by(&:id)
      end

      def total_hours_spent
        worklogs.map(&:hours).reduce(:+)&.round(2) || 0
      end
    end
  end
end