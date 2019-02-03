# frozen_string_literal: true

require_relative '../command'
require_relative '../helpers/time_helper'
require_relative '../api/tempo_api/requests/list_worklogs'

module TempestTime
  module Commands
    class List < TempestTime::Command
      include TempestTime::Helpers::TimeHelper

      def initialize(date, options)
        @date = date
        @options = options
      end

      def execute(input: $stdin, output: $stdout)
        dates = parsed_date_input(@date)
        dates.each do |start_date|
          request = TempoAPI::Requests::ListWorklogs.new(
            start_date,
            @options['end_date'],
            @options[:user]
          )
          request.send_request
          puts "\nHere are your logs for #{formatted_date_range(start_date, @options['end_date'])}:\n"
          puts request.response_message
        end
      end
    end
  end
end
