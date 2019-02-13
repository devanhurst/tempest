# frozen_string_literal: true

require_relative '../response'
require_relative '../models/worklog'
require_relative '../../../helpers/time_helper'

module TempoAPI
  module Responses
    class ListWorklogs < TempoAPI::Response
      include TempestTime::Helpers::TimeHelper

      def worklogs
        @worklogs ||= results.map do |worklog|
          TempoAPI::Models::Worklog.new(
            id: worklog['tempoWorklogId'],
            issue: worklog.fetch('issue', {}).fetch('key', nil),
            seconds: worklog['timeSpentSeconds'],
            description: worklog['description']
          )
        end.sort_by(&:id)
      end

      def total_hours_spent
        worklogs.map(&:hours).reduce(:+)&.round(2) || 0
      end

      private

      def results
        @results = raw_response['results'] || []
      end
    end
  end
end
