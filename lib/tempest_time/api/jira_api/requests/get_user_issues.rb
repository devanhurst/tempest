require_relative '../request'
require_relative '../responses/get_user_issues'

module JiraAPI
  module Requests
    class GetUserIssues < JiraAPI::Request
      attr_reader :requested_user

      def initialize(requested_user: nil)
        super
        @requested_user = requested_user || username
      end

      private

      def request_method
        'get'
      end

      def request_path
        "/search"
      end

      def query_params
        {
          'jql' => "assignee=#{requested_user} AND resolution is EMPTY",
          'maxResults' => 100,
        }
      end

      def response_klass
        JiraAPI::Responses::GetUserIssues
      end
    end
  end
end
