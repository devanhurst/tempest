require_relative '../request'
require_relative '../responses/search_users'

module JiraAPI
  module Requests
    class SearchUsers < JiraAPI::Request
      def initialize(query: nil)
        super
        @query = query
      end

      private

      def request_method
        'get'
      end

      def request_path
        "/user/search"
      end

      def query_params
        {
          'query' => @query,
        }
      end

      def response_klass
        JiraAPI::Responses::SearchUsers
      end
    end
  end
end
