# frozen_string_literal: true

require_relative '../../../helpers/formatting_helper'

module JiraAPI
  module Models
    class Issue
      include TempestTime::Helpers::FormattingHelper

      attr_reader :fields, :key

      def initialize(issue)
        @key = issue['key']
        @fields = issue['fields']
      end

      def remaining_estimate
        @remaining_estimate ||= fields.fetch('timetracking', {}).fetch(
          'remainingEstimateSeconds', nil
        )
      end

      def summary
        @summary ||= fields.fetch('summary')
      end

      def status
        @status ||= fields.fetch('status', {}).fetch('name', nil)
      end
    end
  end
end
