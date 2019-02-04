# frozen_string_literal: true

require_relative '../command'
require_relative '../helpers/time_helper'

require_relative '../api/tempo_api/requests/create_worklog'
require_relative '../api/jira_api/requests/get_issue'

module TempestTime
  module Commands
    class Track < TempestTime::Command
      include TempestTime::Helpers::TimeHelper

      def initialize(time, tickets, options)
        @time = time
        @tickets = tickets
        @options = options
      end

      def execute(input: $stdin, output: $stdout)
        time = @options[:split] ? parsed_time(@time) / @tickets.count : parsed_time(@time)
        tickets = @tickets.any? ? @tickets.map(&:upcase) : [automatic_ticket]

        unless @options[:autoconfirm]
          prompt_message = "Track #{formatted_time(time)}, "\
                         "#{billability(@options)}, "\
                         "to #{tickets.join(', ')}?"
          abort unless prompt.yes?(prompt_message, convert: :bool)
        end

        tickets.each do |ticket|
          track_time(time, @options.merge(ticket: ticket))
        end
      end

      private

      def track_time(time, options)
        message = "Tracking #{formatted_time(time)} to #{options['ticket']}..."
        with_success_fail_spinner(message) do
          options['remaining'] = if options['remaining'].nil?
                                 remaining_estimate(options['ticket'], time)
                               else
                                 parsed_time(options['remaining'])
                               end
          TempoAPI::Requests::CreateWorklog.new(time, options).send_request
        end
      end

      def remaining_estimate(ticket, time)
        request = JiraAPI::Requests::GetIssue.new(ticket)
        request.send_request
        if request.response.failure?
          abort("There was an issue getting this Jira ticket.\n"\
                'Please check the ticket number and your credentials.')
        end
        remaining = request.response.issue.remaining_estimate || 0
        remaining > time ? remaining - time : 0
      end

      def automatic_ticket
        ticket = /[A-Z]+-\d+/.match(Git.open(Dir.pwd).current_branch)
        abort('Ticket not found for this branch. Please specify.') unless ticket
        ticket.to_s
      end

      def billability(options)
        options['billable'] ? 'billed' : 'non-billed'
      end
    end
  end
end
