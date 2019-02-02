require_relative '../response'
require_relative '../models/issue'

module JiraAPI
  module Responses
    class GetIssue < JiraAPI::Response
      def message
        puts issue.to_s
      end

      def issue
        @issue ||= JiraAPI::Models::Issue.new(raw_response)
      end
    end
  end
end