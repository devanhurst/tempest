# frozen_string_literal: true

require_relative '../command'
require_relative '../api/tempo_api/requests/submit_timesheet'

module TempestTime
  module Commands
    class Submit < TempestTime::Command
      def initialize(options)
        @options = options
      end

      def execute(input: $stdin, output: $stdout)
        # Command logic goes here ...
        reviewer = prompt.ask('Who should review this timesheet? (username)')
        message = "Submit this week's timesheet to " + pastel.green(reviewer) + '?'
        abort unless prompt.yes?(message)
        abort unless prompt.yes?('Are you sure? No edits can be made once submitted!')

        with_success_fail_spinner("Submitting this week's timesheet...") do
          TempoAPI::Requests::SubmitTimesheet.new(reviewer).send_request
        end
      end
    end
  end
end
