# frozen_string_literal: true

require_relative '../../command'
require_relative '../../api/jira_api/requests/get_user_issues'

module TempestTime
  module Commands
    class Issue
      class List < TempestTime::Command
        def initialize(options)
          @user = options[:user] || current_user
          @options = options
        end

        def execute(input: $stdin, output: $stdout)
          request = JiraAPI::Requests::GetUserIssues.new(@user)
          message = "Getting issues for #{request.requested_user}"
          response = with_spinner(message) do |spinner|
            request.send_request.tap { spinner.stop }
          end
          puts format_output(response.issues)
          browser_prompt(response.issues)
        end

        private

        def browser_prompt(issues)
          abort if prompt.no?('Open any issues in your browser?')
          selections = prompt.multi_select(
            'Select an issue to open in browser, or press ^C to quit.',
            issues.map(&:key),
            per_page: 5
          )
          require_relative 'open'
          Open.new(selections).execute
        end

        def format_output(issues)
          table.new(
            %w[Status Issue Summary],
            issues.map { |issue| row(issue) }
          ).render(:ascii, padding: [0, 1], column_widths: [15, 10, 30])
        end

        def row(issue)
          [issue.status, issue.key, issue.summary]
        end

        def current_user
          require_relative '../../settings/authorization'
          TempestTime::Settings::Authorization.new.fetch('username')
        end
      end
    end
  end
end