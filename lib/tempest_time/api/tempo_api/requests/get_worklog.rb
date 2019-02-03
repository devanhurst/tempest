require_relative '../request'
require_relative '../responses/get_worklog'

module TempoAPI
  module Requests
    class GetWorklog < TempoAPI::Request
      attr_reader :worklog_id

      def initialize(worklog_id)
        super
        @worklog_id = worklog_id
      end

      private

      def request_method
        'get'
      end

      def request_path
        "/worklogs/#{worklog_id}"
      end

      def response_klass
        TempoAPI::Responses::GetWorklog
      end
    end
  end
end