require_relative '../response'
require_relative '../models/issue'

module JiraAPI
  module Responses
    class GetUserIssues < JiraAPI::Response
      def message
        issues.map(&:to_s)
      end

      def issues
        @issues ||= raw_response['issues'].map do |issue|
          JiraAPI::Models::Issue.new(issue)
        end.reverse
      end
    end
  end
end