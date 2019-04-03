require_relative '../request'
require_relative '../responses/create_worklog'

module TempoAPI
  module Requests
    class CreateWorklog < TempoAPI::Request
      def initialize(seconds, options)
        super
        @seconds = seconds
        @remaining = options[:remaining]
        @issue = options[:issue]
        @message = options[:message]
        @date = options[:date] ? options[:date] : Date.today
        @billable = options[:billable]
        @user = options[:user]
      end

      private

      attr_reader :issue, :remaining, :seconds, :message, :date, :billable, :user

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
          "issueKey": issue,
          "timeSpentSeconds": seconds,
          "billableSeconds": billable_time,
          "remainingEstimateSeconds": remaining,
          "startDate": date.strftime('%Y-%m-%d'),
          "startTime": '12:00:00',
          "authorAccountId": user.account_id,
          "description": message,
        }
      end

      def billable_time
        billable ? seconds : 0
      end
    end
  end
end
