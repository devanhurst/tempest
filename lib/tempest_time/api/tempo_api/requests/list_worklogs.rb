# frozen_string_literal: true

require_relative '../request'
require_relative '../responses/list_worklogs'

module TempoAPI
  module Requests
    # :no-doc:
    class ListWorklogs < TempoAPI::Request
      attr_reader :start_date, :end_date

      def initialize(start_date, end_date = nil, requested_user = nil)
        super
        @start_date = start_date
        @end_date = end_date || start_date
        @requested_user = requested_user || user
      end

      private

      attr_reader :requested_user

      def response_klass
        TempoAPI::Responses::ListWorklogs
      end

      def request_method
        'get'
      end

      def request_path
        "/worklogs/user/#{requested_user}"
      end

      def query_params
        {
          "from": start_date.strftime(DATE_FORMAT),
          "to": end_date.strftime(DATE_FORMAT),
          "limit": 1000
        }
      end
    end
  end
end
