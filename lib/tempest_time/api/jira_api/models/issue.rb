require_relative '../../../helpers/formatting_helper'

module JiraAPI
  module Models
    class Issue
      include TempestTime::Helpers::FormattingHelper

      attr_reader :fields, :name, :key

      def initialize(issue)
        @key = issue['key']
        @fields = issue['fields']
      end

      def remaining_estimate
        @remaining_estimate ||= fields.dig('timetracking', 'remainingEstimateSeconds')
      end

      def name
        @name ||= fields.dig('summary')
      end

      def status
        @status ||= fields.dig('status', 'name')
      end

      def to_s
        "#{braced(status, 20)} #{braced(key, 10)} #{name}"
      end
    end
  end
end