require_relative '../request'
require_relative '../responses/list_worklogs'

module TempoAPI
  module Requests
    class ListWorklogs < TempoAPI::Request
      attr_reader :date

      def initialize(date)
        super
        @date = date
      end

      def formatted_date
        date.strftime("%Y-%m-%d")
      end

      private

      def response_klass
        TempoAPI::Responses::ListWorklogs
      end

      def request_method
        'get'
      end

      def request_path
        "/worklogs/user/#{user}"
      end

      def query_params
        {
          "from": formatted_date,
          "to": formatted_date,
          "limit": 1000
        }
      end
    end
  end
end