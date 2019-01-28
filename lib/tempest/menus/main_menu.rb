require 'git'
require 'thor'

require_relative '../cli'

require_relative '../../tempo_api/authorization'
require_relative '../../tempo_api/requests/create_worklog'
require_relative '../../tempo_api/requests/delete_worklog'
require_relative '../../tempo_api/requests/list_worklogs'

require_relative '../helpers/time_helper'

module Tempest
  class MainMenu < CLI
    include Tempest::Helpers::TimeHelper

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
    def track(time)
      time = parsed_time(time)
      ticket = (options['ticket'] || automatic_ticket).upcase
      confirm("Track #{formatted_time(time)} to #{ticket}?")
      track_time(parsed_time(time), options.merge(ticket: ticket))
    end

    map 't' => 'track'

    desc 'multi [TIME]', 'Track identical time to multiple tickets.'
    option :tickets, aliases: ['-t'], required: true, type: :array
    option :message, aliases: '-m', type: :string
    option :date, aliases: '-d', type: :string
    def multi(time)
      time = parsed_time(time)
      tickets = options['tickets'].map(&:upcase)
      confirm("Track #{formatted_time(time)} each to #{tickets.join(', ')}?")
      tickets.each { |ticket| track_time(parsed_time(time), options.merge(ticket: ticket)) }
    end

    desc 'split [TIME]', 'Track bank of time, split equally across multiple tickets.'
    option :tickets, aliases: ['-t'], required: true, type: :array
    option :message, aliases: '-m', type: :string
    option :date, aliases: '-d', type: :string
    def split(time)
      tickets = options['tickets'].map(&:upcase)
      time = parsed_time(time) / tickets.count
      confirm("Track #{formatted_time(time)} each to #{tickets.join(', ')}?")
      tickets.each { |ticket| track_time(time, options.merge(ticket: ticket)) }
    end

    desc 'list DATE', "List worklogs for given date."
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

    desc 'setup', 'Setup Tempest CLI with your credentials.'
    option :user, aliases: '-u', type: :string
    option :token, aliases: '-t', type: :string
    def setup
      if options['user'].nil? || options['token'].nil?
        abort(
          "Please provide your user credentials.\n"\
          "(--user=USERID -- token=TOKEN)\n"\
          "Your token can be accessed through your worksheet's settings page."
        )
      end

      TempoAPI::Authorization.update_credentials(options['user'], options['token'])
    end

    private

    no_commands do
      def track_time(time, options)
        puts "Tracking #{formatted_time(time)} to #{options['ticket']}!"
        request = TempoAPI::Requests::CreateWorklog.new(time,
                                                        options['ticket'],
                                                        options['message'],
                                                        options['date'])
        request.send_request
        puts request.response_message
      end

      def parsed_time(time)
        return time if time.is_a?(Integer)

        if /^\d*\.{0,1}\d{1,2}h$/.match(time)
          return (time.chomp('h').to_f * 60).to_i
        elsif /^\d+m$/.match(time)
          return time.chomp('m').to_i
        end

        abort("Please provide time in the correct format. e.g. 0.5h, .5h, 30m")
      end

      def automatic_ticket
        ticket = /[A-Z]+-\d+/.match(Git.open(Dir.pwd).current_branch)
        abort('Ticket not found for this branch. Please specify.') unless ticket
        ticket
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
