require_relative '../request'
require_relative '../responses/create_worklog'

module TempoAPI
  module Requests
    class CreateWorklog < TempoAPI::Request
      def initialize(seconds, options)
        super
        @seconds = seconds
        @remaining = options['remaining']
        @ticket = options['ticket']
        @message = options['message']
        @date = options['date'] ? Date.parse(options['date']) : Date.today
        @billable = options['billable']
      end

      private

      attr_reader :ticket, :remaining, :seconds, :message, :date, :billable

      def request_method
        'post'
      end

      def request_path
        '/worklogs'
      end

      def response_klass
        TempoAPI::Responses::CreateWorklog
      end

      def request_body
        {
          "issueKey": ticket,
          "timeSpentSeconds": seconds,
          "billableSeconds": billable_time,
          "remainingEstimateSeconds": remaining,
          "startDate": date.strftime('%Y-%m-%d'),
          "startTime": '12:00:00',
          "authorUsername": user,
          "description": message
        }
      end

      def billable_time
        billable ? seconds : 0
      end
    end
  end
end