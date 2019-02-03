require_relative '../../../helpers/formatting_helper'

module JiraAPI
  module Models
    class Issue
      include TempestTime::Helpers::FormattingHelper

      attr_reader :fields, :summary, :key

      def initialize(issue)
        @key = issue['key']
        @fields = issue['fields']
      end

      def remaining_estimate
        @remaining_estimate ||= fields.dig('timetracking', 'remainingEstimateSeconds')
      end

      def summary
        @summary ||= fields.dig('summary')
      end

      def status
        @status ||= fields.dig('status', 'name')
      end
    end
  end
end