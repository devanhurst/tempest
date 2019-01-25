require_relative '../request'
require_relative '../responses/today'

module TempoAPI
  module Requests
    class Today < TempoAPI::Request
      private

      def response_klass
        Tempest::Responses::Today
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

      def formatted_date
        date = Time.now
        "#{date.year}-#{date.month}-#{date.day}"
      end
    end
  end
end