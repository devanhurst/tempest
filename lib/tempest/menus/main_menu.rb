require 'git'
require 'thor'

require_relative '../cli'

require_relative '../api/jira_api/authorization'
require_relative '../api/jira_api/requests/get_issue'

require_relative '../api/tempo_api/authorization'
require_relative '../api/tempo_api/requests/create_worklog'
require_relative '../api/tempo_api/requests/delete_worklog'
require_relative '../api/tempo_api/requests/list_worklogs'

require_relative '../helpers/time_helper'

module Tempest
  class MainMenu < CLI
    include Tempest::Helpers::TimeHelper

    desc 'setup [TOOL]', 'Provide Jira and Tempo credentials.'
    def setup
      email = ask('Enter your Atlassian ID. This is typically your login email.')
      id = ask('Enter your Tempo username.')
      domain = ask('Enter your atlassian subdomain. i.e. [THIS VALUE].atlassian.net')
      jira_token = ask('Enter your Atlassian API token. Your token can be generated at https://id.atlassian.com.')
      tempo_token = ask("Enter your Tempo API token. Your tempo token can be generated through your worksheet's settings page.")

      if [email, id, domain, jira_token, tempo_token].any?(&:empty?)
        abort('One or more credentials were missing. Please try again.')
      end

      puts 'Setting up...'
      TempoAPI::Authorization.new.update_credentials('https://api.tempo.io/2', id, tempo_token)
      JiraAPI::Authorization.new.update_credentials("https://#{domain}.atlassian.net/rest/api/3", email, jira_token)
      puts 'Good to go!'
    end

    desc "track [TIME]", "Track time to Tempo."
    long_desc <<-LONGDESC
      'tempest track [time]' will track the specified number of hours or minutes to the ticket specified.\n
      If not specified, it will check the name of the current git branch and automatically
      put the logged time in that ticket, if found.\n
      e.g. tempest track 1.5h --ticket='BCIT-2' --message='Tracking 1.5 hours!'
      e.g. tempest track 90m --ticket='BCIT-2' --message='Tracking time in minutes this time.'
    LONGDESC
    option :message, aliases: '-m', type: :string
    option :ticket, aliases: '-t', type: :string
    option :date, aliases: '-d', type: :string
    option :remaining, aliases: '-r', type: :string
    def track(time)
      time = parsed_time(time)
      ticket = (options['ticket'] || automatic_ticket).upcase
      confirm("Track #{formatted_time(time)} to #{ticket}?")
      track_time(parsed_time(time), options.merge(ticket: ticket))
    end

    map 't' => 'track'

    desc 'multi [TIME]', 'Track identical time to multiple tickets.'
    option :tickets, aliases: '-t', required: true, type: :array
    option :message, aliases: '-m', type: :string
    option :date, aliases: '-d', type: :string
    def multi(time)
      time = parsed_time(time)
      tickets = options['tickets'].map(&:upcase)
      confirm("Track #{formatted_time(time)} each to #{tickets.join(', ')}?")
      tickets.each { |ticket| track_time(parsed_time(time), options.merge(ticket: ticket)) }
    end

    desc 'split [TIME]', 'Track bank of time, split equally across multiple tickets.'
    option :tickets, aliases: '-t', required: true, type: :array
    option :message, aliases: '-m', type: :string
    option :date, aliases: '-d', type: :string
    def split(time)
      tickets = options['tickets'].map(&:upcase)
      time = parsed_time(time) / tickets.count
      confirm("Track #{formatted_time(parsed_time(time))} each to #{tickets.join(', ')}?")
      tickets.each { |ticket| track_time(time, options.merge(ticket: ticket)) }
    end

    desc 'list [DATE]', "List worklogs for given date."
    def list(date=nil)
      request = TempoAPI::Requests::ListWorklogs.new(date)
      request.send_request
      puts "\nHere are your logs for #{request.formatted_date}:\n"
      puts request.response_message
    end
    map 'l' => 'list'

    desc 'delete [WORKLOG_ID]', 'Delete worklog with ID [WORKLOG_ID]'
    def delete(worklog_id=nil)
      check_worklog_presence(worklog_id)
      request = TempoAPI::Requests::DeleteWorklog.new(worklog_id)
      request.send_request
      puts request.response_message
    end

    desc 'issue [ISSUE]', 'Get Jira issue'
    def issue(id)
      request = JiraAPI::Requests::GetIssue.new(id)
      request.send_request
      puts request.response_message
    end

    private

    no_commands do
      def track_time(time, options)
        puts "Tracking #{formatted_time(time)} to #{options['ticket']}!"
        remaining = options['remaining'].nil? ? remaining_estimate(options['ticket'], time) : parsed_time(options['remaining'])
        request = TempoAPI::Requests::CreateWorklog.new(time,
                                                        remaining,
                                                        options['ticket'],
                                                        options['message'],
                                                        options['date'])
        request.send_request
        puts request.response_message
      end

      def remaining_estimate(ticket, time)
        request = JiraAPI::Requests::GetIssue.new(ticket)
        request.send_request
        remaining = request.response.issue.remaining_estimate
        remaining > time ? remaining - time : 0
      end

      def automatic_ticket
        ticket = /[A-Z]+-\d+/.match(Git.open(Dir.pwd).current_branch)
        abort('Ticket not found for this branch. Please specify.') unless ticket
        ticket.to_s
      end

      def check_worklog_presence(worklog_id)
        if worklog_id.nil?
          puts "No worklog specified..."
          list
          abort
        end
      end
    end
  end
end
