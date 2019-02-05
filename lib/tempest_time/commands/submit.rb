# frozen_string_literal: true

require_relative '../command'
require_relative '../api/tempo_api/requests/submit_timesheet'
require_relative '../helpers/time_helper'

module TempestTime
  module Commands
    class Submit < TempestTime::Command
      include TempestTime::Helpers::TimeHelper

      def initialize(options)
        @options = options
      end

      def execute(input: $stdin, output: $stdout)
        reviewer = prompt.ask('Who should review this timesheet? (username)')
        dates = week_dates(week_prompt('Select a week to submit.'))

        message = 'Submit the selected timesheet to ' + pastel.green(reviewer) + '?'
        abort unless prompt.yes?(message)
        abort unless prompt.yes?('Are you sure? No edits can be made once submitted!')

        with_success_fail_spinner("Submitting your timesheet...") do
          TempoAPI::Requests::SubmitTimesheet.new(reviewer, dates).send_request
        end
      end
    end
  end
end
