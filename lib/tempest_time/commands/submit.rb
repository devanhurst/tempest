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
        # Command logic goes here ...
        reviewer = prompt.ask('Who should review this timesheet? (username)')
        week_number = week_prompt

        message = 'Submit the selected timesheet to ' + pastel.green(reviewer) + '?'
        abort unless prompt.yes?(message)
        abort unless prompt.yes?('Are you sure? No edits can be made once submitted!')

        with_success_fail_spinner("Submitting your timesheet...") do
          TempoAPI::Requests::SubmitTimesheet.new(reviewer, week_number).send_request
        end
      end

      private

      def week_prompt
        week = TTY::Prompt.new.select(
            'Please select the week to submit.',
            week_ranges,
            default: current_week,
            per_page: 5
        )
        week_ranges.find_index(week) + 1
      end
    end
  end
end
