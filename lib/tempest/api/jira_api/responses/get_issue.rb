require_relative '../response'
require_relative '../models/issue'

module JiraAPI
  module Responses
    class GetIssue < JiraAPI::Response
      def issue
        @issue ||= JiraAPI::Models::Issue.new(raw_response['fields'])
      end
    end
  end
end