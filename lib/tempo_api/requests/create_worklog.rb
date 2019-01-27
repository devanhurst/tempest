require_relative '../request'

module TempoAPI
  module Requests
    class CreateWorklog < TempoAPI::Request
      def initialize(minutes, ticket, description, date)
        @minutes = minutes
        @ticket = ticket
        @description = description
        @date = date ? Date.parse(date) : Date.today
      end

      private

      attr_reader :ticket, :minutes, :description, :date

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
          "startDate": formatted_date,
          "startTime": '12:00:00',
          "authorUsername": user,
          "description": description
        }.to_json
      end

      def formatted_date
        date.strftime("%Y-%m-%d")
      end

      def seconds
        minutes.to_i * 60
      end
    end
  end
end