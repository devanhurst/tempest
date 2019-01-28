require_relative '../request'
require_relative '../responses/list_worklogs'

module TempoAPI
  module Requests
    class ListWorklogs < TempoAPI::Request
      attr_reader :date

      def initialize(date_input)
        super
        @date = parsed_date_input(date_input)
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

      def auth_type
        'bearer'
      end

      def query_params
        {
          "from": formatted_date,
          "to": formatted_date,
          "limit": 1000
        }
      end

      def parsed_date_input(date_input)
        case date_input
        when 'today', nil
          Date.today
        when 'yesterday'
          Date.today.prev_day
        else
          Date.parse(date_input)
        end
      end
    end
  end
end