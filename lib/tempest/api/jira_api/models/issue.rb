module JiraAPI
  module Models
    class Issue
      attr_reader :remaining_estimate

      def initialize(issue)
        @remaining_estimate = issue.dig('timetracking', 'remainingEstimateSeconds')
      end
    end
  end
end