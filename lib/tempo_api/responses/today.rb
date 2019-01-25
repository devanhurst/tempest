require_relative '../response'

module Tempest
  module Responses
    class Today < TempoAPI::Response
      private

      attr_reader :worklogs

      def success_message
        output = ''
        output << worklogs_output
        output << "TOTAL TIME LOGGED: #{hours(minutes(total_seconds_spent))} hours."
      end

      def worklogs
        @worklogs ||= raw_response['results']
      end

      def worklogs_output
        worklogs.map do |log|
          "#{log['tempoWorklogId']}: #{log.dig('issue', 'key')}: #{minutes(log['timeSpentSeconds'])}m: #{log['description']}\n"
        end.join
      end

      def total_seconds_spent
        worklogs.map { |log| log['timeSpentSeconds'] }.reduce(:+) || 0
      end

      def minutes(seconds)
        seconds / 60
      end

      def hours(minutes)
        (minutes.to_f / 60).round(2)
      end
    end
  end
end