require_relative '../request'

module TempoAPI
  module Requests
    class CreateWorklog < TempoAPI::Request
      def initialize(seconds, remaining, ticket, description, date)
        super
        @seconds = seconds
        @remaining = remaining
        @ticket = ticket
        @description = description
        @date = date ? Date.parse(date) : Date.today
      end

      private

      attr_reader :ticket, :remaining, :seconds, :description, :date

      def request_method
        'post'
      end

      def request_path
        '/worklogs'
      end

      def request_body
        {
          "issueKey": ticket,
          "timeSpentSeconds": seconds,
          "billableSeconds": seconds,
          "remainingEstimateSeconds": remaining,
          "startDate": formatted_date,
          "startTime": '12:00:00',
          "authorUsername": user,
          "description": description
        }.to_json
      end

      def formatted_date
        date.strftime("%Y-%m-%d")
      end
    end
  end
end