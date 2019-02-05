# frozen_string_literal: true

require_relative '../command'
require_relative '../helpers/time_helper'
require_relative '../api/jira_api/requests/get_issue'
require_relative '../api/tempo_api/requests/create_worklog'

module TempestTime
  module Commands
    class Track < TempestTime::Command
      def initialize(time, issues, options)
        @time = time
        @issues = issues
        @options = options
      end

      def execute(input: $stdin, output: $stdout)
        time = @options[:split] ? parsed_time(@time) / @issues.count : parsed_time(@time)
        issues = @issues.any? ? @issues.map(&:upcase) : [automatic_issue]

        unless @options[:autoconfirm]
          prompt_message = "Track #{formatted_time(time)}, "\
                         "#{billability(@options)}, "\
                         "to #{issues.join(', ')}?"
          abort unless prompt.yes?(prompt_message, convert: :bool)
        end

        issues.each do |issue|
          track_time(time, @options.merge('issue' => issue))
        end
      end

      private

      def track_time(time, options)
        message = "Tracking #{formatted_time(time)} to #{options['issue']}..."
        with_success_fail_spinner(message) do
          options['remaining'] = if options['remaining'].nil?
                                 remaining_estimate(options['issue'], time)
                               else
                                 parsed_time(options['remaining'])
                               end
          TempoAPI::Requests::CreateWorklog.new(time, options).send_request
        end
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
        options['billable'] ? 'billed' : 'non-billed'
      end
    end
  end
end
