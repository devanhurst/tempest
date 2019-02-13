require_relative '../request'
require_relative '../responses/get_issue'

module JiraAPI
  module Requests
    class GetIssue < JiraAPI::Request
      attr_reader :issue

      def initialize(issue)
        super
        @issue = issue
      end

      private

      def request_method
        'get'
      end

      def request_path
        "/issue/#{issue}"
      end

      def response_klass
        JiraAPI::Responses::GetIssue
      end
    end
  end
end
