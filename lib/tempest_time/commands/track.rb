# frozen_string_literal: true

require_relative '../command'
require_relative '../api/jira_api/requests/get_issue'
require_relative '../api/tempo_api/requests/create_worklog'

module TempestTime
  module Commands
    class Track < TempestTime::Command
      attr_reader :time, :issues, :options

      def initialize(time, issues, options)
        @options = options
        @issues = issues.any? ? issues.map(&:upcase) : [automatic_issue]
        @time = parsed_time(time) / @issues.count
        @dates = options[:date] ? [Date.parse(options[:date])] : nil
      end

      def execute!
        dates

        unless options[:autoconfirm]
          confirm_prompt
        end
        dates.each do |date|
          issues.each do |issue|
            track_time(time, options.merge({ issue: issue, date: date }))
          end
        end
      end

      private

      def track_time(time, options)
        message = "Tracking #{formatted_time(time)} to #{options[:issue]}..."
        with_success_fail_spinner(message) do
          options[:remaining] = if options[:remaining].nil?
                                  remaining_estimate(options[:issue], time)
                                else
                                  parsed_time(options[:remaining])
                                end
          TempoAPI::Requests::CreateWorklog.new(time, options).send_request
        end
      end

      def dates
        @dates ||= if options[:autoconfirm]
                     [Date.today]
                   else
                     date_prompt("Select the day(s) to log this time to.",
                                 days_before: 13,
                                 days_after: 365).sort
                   end
      end

      def confirm_prompt
        prompt_message = "Track #{formatted_time(time)}, "\
                           "#{billability(options)}, "\
                           "to #{issues.join(', ')}?"
        abort unless prompt.yes?(prompt_message, convert: :bool)
      end

      def remaining_estimate(issue, time)
        request = JiraAPI::Requests::GetIssue.new(issue)
        request.send_request
        if request.response.failure?
          abort("There was an issue getting this Jira issue.\n"\
                'Please check the issue number and your credentials.')
        end
        remaining = request.response.issue.remaining_estimate || 0
        remaining > time ? remaining - time : 0
      end

      def billability(options)
        options[:billable] ? 'billed' : 'non-billed'
      end
    end
  end
end
