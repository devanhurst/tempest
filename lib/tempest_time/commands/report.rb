# frozen_string_literal: true

require_relative '../command'
require_relative '../settings/teams'
require_relative '../services/generate_report'

module TempestTime
  module Commands
    class Report < TempestTime::Command
      def initialize(users, options)
        @users = users || []
        @options = options
      end

      def execute(input: $stdin, output: $stdout)
        team = @options[:team]
        @users = prompt_for_input if @users.empty? && team.nil?
        @users.push(TempestTime::Settings::Teams.members(team)) if team
        abort('No users specified.') unless @users.any?

        puts render_table
      end

      private

      def report
        @report ||= TempestTime::Services::GenerateReport.new(
          @users.flatten, @options[:week]
        )
      end

      def prompt_for_input
        type = prompt.select(
          "Generate a report for a #{pastel.green('user')} or #{pastel.green('team')}?",
          ['user', 'team']
        )
        return [prompt.ask('Which user would you like to analyse?')] if type == 'user'
        teams = TempestTime::Settings::Teams
        team = prompt.select(
          "Which #{pastel.green('team')} would you like to analyse?",
          teams.keys
        )
        teams.members(team)
      end

      def table_headings
        %w[User COMP% UTIL%] + report.projects
      end

      def render_table
        t = table.new(
          table_headings,
          report.reports.map { |r| row(r) } + [row(report.aggregate)]
        )

        t.render(:ascii, padding: [0, 1])
      end

      def row(r)
        row = [
          r.user,
          r.total_compliance_percentage.round(2),
          r.utilization_percentage.round(2)
        ]
        report.projects.each do |project|
          row.push(r.project_compliance_percentages.to_h.fetch(project, 0).round(2))
        end
        row
      end
    end
  end
end
