require_relative '../request'

module TempoAPI
  module Requests
    class DeleteWorklog < TempoAPI::Request
      def initialize(worklog_id)
        super
        @worklog_id = worklog_id
      end

      private

      attr_reader :worklog_id

      def request_method
        'delete'
      end

      def request_path
        "/worklogs/#{worklog_id}"
      end
    end
  end
end