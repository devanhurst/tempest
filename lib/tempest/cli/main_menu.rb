require 'byebug'
require 'git'

require 'thor'
require 'yaml'

require_relative './macros'

require_relative '../../tempo_api/requests/create_worklog'
require_relative '../../tempo_api/requests/delete_worklog'
require_relative '../../tempo_api/requests/list_worklogs'

module Tempest
  module CLI
    class MainMenu < Thor
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
        track_time(time_in_minutes(time), options)
      end

      desc 'multi [TIME]', 'Track identical time to multiple tickets.'
      option :tickets, aliases: ['-t'], required: true, type: :array
      option :message, aliases: '-m', type: :string
      option :date, aliases: '-d', type: :string
      def multi(time)
        tickets = options['tickets'].map(&:upcase)
        response = ask(
          "About to track time to #{tickets.join(', ')}.\n"\
          'Are you sure? (y/n)', limited_to: %w[y n])
        abort unless %w[y yes].include?(response.downcase)

        tickets.each { |ticket| track_time(time_in_minutes(time), options.merge(ticket: ticket)) }
      end

      desc 'list DATE', "List worklogs for given date."
      def list(date=nil)
        request = TempoAPI::Requests::ListWorklogs.new(date)
        request.send_request
        puts "Here are the logs for #{request.formatted_date}:"
        puts request.response_message
      end

      desc 'delete [WORKLOG_ID]', 'Delete worklog with ID [WORKLOG_ID]'
      def delete(worklog_id=nil)
        check_worklog_presence(worklog_id)
        request = TempoAPI::Requests::DeleteWorklog.new(worklog_id)
        request.send_request
        puts request.response_message
      end

      desc 'setup', 'Setup Tempest CLI with your credentials.'
      option :user
      option :token
      def setup
        if options['user'].nil? || options['token'].nil?
          abort(
            "Please provide your user credentials.\n"\
            "(--user=USERID -- token=TOKEN)\n"\
            "Your token can be accessed through your worksheet's settings page."
          )
        end

        secrets = YAML::load_file('config/secrets.yml')
        secrets['tempo']['user'] = options['user']
        secrets['tempo']['token'] = options['token']
        File.open('config/secrets.yml', 'w') { |f| f.write secrets.to_yaml }
      end

      private

      no_commands do
        def track_time(time, options)
          abort("Please provide time in the correct format. e.g. 0.5h, .5h, 30m") unless time > 0

          ticket = (options['ticket'] || automatic_ticket).upcase
          puts "Tracking #{time} minutes to #{ticket}!"
          request = TempoAPI::Requests::CreateWorklog.new(time,
                                                          ticket,
                                                          options['message'],
                                                          options['date'])
          request.send_request
          puts request.response_message
        end

        def automatic_ticket
          ticket = /[A-Z]+-\d+/.match(Git.open(Dir.pwd).current_branch)
          abort('Ticket not found for this branch. Please specify.') unless ticket
          response = ask("Track time to #{ticket}?", limited_to: %w[y n])
          %w[y yes].include?(response.downcase) ? ticket : abort('Aborting.')
        end

        def check_worklog_presence(worklog_id)
          if worklog_id.nil?
            puts "No worklog specified..."
            list
            abort
          end
        end

        def time_in_minutes(time)
          if /^\d*\.{0,1}\d{1,2}h$/.match(time)
            return (time.chomp('h').to_f * 60).to_i
          elsif /^\d+m$/.match(time)
            return time.chomp('m').to_i
          end
          0
        end
      end
    end
  end
end
