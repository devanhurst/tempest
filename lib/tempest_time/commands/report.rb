# frozen_string_literal: true

require_relative '../command'
require_relative '../settings/teams'
require_relative '../api/tempo_api/requests/list_worklogs'
require_relative '../models/report'

module TempestTime
  module Commands
    class Report < TempestTime::Command
      def initialize(users, options)
        @users = users || []
        @team = options[:team]
        @teams = TempestTime::Settings::Teams.new
      end

      def execute(input: $stdin, output: $stdout)
        @users = user_prompt if @users.empty? && @team.nil?
        @users.push(teams.members(@team)) if @team
        abort('No users specified.') unless @users.any?

        @week = week_prompt('Please select the week to report.')

        with_spinner('Generating report...') do |spinner|
          table = render_table
          spinner.stop(pastel.green('Your report is ready!'))
          date_range = "#{formatted_date(start_date)}"\
                       ' to '\
                       "#{formatted_date(end_date)}"
          prompt.say("\nReport for #{pastel.green(date_range)}")
          puts table
        end
      end

      private

      def user_prompt
        type = prompt.select(
          'Generate a report for a '\
          "#{pastel.green('team')} or a specific #{pastel.green('user')}?",
          %w[Team User]
        )

        if type == 'User'
          return [
            prompt.ask("Please enter a #{pastel.green('user')}.")
          ]
        end

        if @teams.names.empty?
          abort('You have no teams yet! Go make one! (tempest teams add)')
        end

        team = prompt.select(
          "Please select a #{pastel.green('team')}.",
          @teams.names
        )
        @teams.members(team)
      end

      def start_date
        @start_date ||= week_dates(@week).first
      end

      def end_date
        @end_date ||= week_dates(@week).last
      end

      def reports
        @reports ||= @users.map do |user|
          list = TempoAPI::Requests::ListWorklogs.new(
            start_date,
            end_date,
            user
          ).send_request
          TempestTime::Models::Report.new(user, list.worklogs)
        end || []
      end

      def aggregate
        @aggregate ||= TempestTime::Models::Report.new(
          'TOTAL',
          reports.flat_map(&:worklogs),
          @users.count
        )
      end

      def projects
        @projects ||= reports.flat_map(&:projects).uniq.sort.tap do |projects|
          projects.delete('BCIT')
          projects.unshift('BCIT')
        end
      end

      def table_headings
        %w[User COMP% UTIL%] + projects
      end

      def render_table
        t = table.new(
          table_headings,
          reports.map { |r| row(r) } + [row(aggregate)]
        )

        t.render(:ascii, padding: [0, 1])
      end

      def row(data)
        row = [
          data.user,
          right_align(percentage(data.total_compliance_percentage)),
          right_align(percentage(data.utilization_percentage))
        ]
        projects.each do |project|
          row.push(
            right_align(
              percentage(
                data.project_compliance_percentages.to_h.fetch(project, 0)
              )
            )
          )
        end
        row
      end

      def right_align(value)
        { value: value, alignment: :right }
      end

      def percentage(decimal)
        return '' unless decimal.positive?
        (decimal * 100.0).round(1).to_s + '%'
      end
    end
  end
end
