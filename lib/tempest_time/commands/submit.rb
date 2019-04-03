# frozen_string_literal: true

require_relative '../command'
require_relative '../api/tempo_api/requests/submit_timesheet'

module TempestTime
  module Commands
    class Submit < TempestTime::Command
      def initialize(options)
        @options = options
      end

      def execute!
        reviewer = find_user(prompt.ask('Who should review this timesheet?'))
        dates = week_dates(week_prompt('Select a week to submit.'))

        message = 'Submit the selected timesheet to ' + pastel.green(reviewer.name) + '?'
        abort unless prompt.yes?(message)
        abort unless prompt.yes?('Are you sure? No edits can be made once submitted!')

        with_success_fail_spinner('Submitting your timesheet...') do
          TempoAPI::Requests::SubmitTimesheet.new(
            submitter: current_user,
            reviewer: reviewer,
            dates: dates
          ).send_request
        end
      end
    end
  end
end
