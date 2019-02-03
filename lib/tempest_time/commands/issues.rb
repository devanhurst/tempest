# frozen_string_literal: true

require_relative '../command'
require_relative '../api/jira_api/requests/get_user_issues'

module TempestTime
  module Commands
    class Issues < TempestTime::Command
      def initialize(user, options)
        @user = user
        @options = options
      end

      def execute(input: $stdin, output: $stdout)
        request = JiraAPI::Requests::GetUserIssues.new(@user)
        with_spinner("Getting issues for #{request.requested_user}") do |spinner|
          response = request.send_request
          spinner.stop
          puts format_output(response.issues)
        end
      end

      private

      def format_output(issues)
        table.new(
          %w[Status Issue Summary],
          issues.map { |issue| row(issue) }
        ).render(:ascii, padding: [0, 1])
      end

      def row(issue)
        [issue.status, issue.key, issue.summary]
      end
    end
  end
end
