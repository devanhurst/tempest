require 'byebug'
require 'git'

require 'thor'
require 'yaml'
require 'tempest/version'

require_relative 'tempo_api/requests/create_worklog'
require_relative 'tempo_api/requests/delete_worklog'
require_relative 'tempo_api/requests/today'

module Tempest
  class CLI < Thor
    desc "track [MINUTES]", "Track time to Tempo."
    long_desc <<-LONGDESC
      'tempest track [MINUTES]' will track the specified number of minutes to the ticket specified.\n

      If not specified, it will check the name of the current git branch and automatically
      put the logged time in that ticket, if found.\n

      e.g. tempest track 60 --ticket='BCIT-2' --description='Making Tempest CLI!'
    LONGDESC
    option :description
    option :ticket
    option :date
    def track(minutes)
      ticket = options['ticket'] || automatic_ticket
      puts "Tracking #{minutes} minutes to #{ticket}!"
      request = TempoAPI::Requests::CreateWorklog.new(minutes,
                                                    ticket,
                                                    options['description'],
                                                    options['date'])
      request.send_request
      puts request.response_message
    end

    desc 'delete [WORKLOG_ID]', 'Delete worklog with ID [WORKLOG_ID]'
    def delete(worklog_id=nil)
      check_worklog_presence(worklog_id)
      request = TempoAPI::Requests::DeleteWorklog.new(worklog_id)
      request.send_request
      puts request.response_message
    end

    desc 'today', "Get today's worklogs."
    def today
      puts "Here are today's logs:"
      request = TempoAPI::Requests::Today.new
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

    def automatic_ticket
      ticket = /[A-Z]+-\d+/.match(Git.open(Dir.pwd).current_branch)
      abort('Ticket not found for this branch. Please specify.') unless ticket
      response = ask("Track time to #{ticket}?", limited_to: %w[y n])
      %w[y yes].include?(response.downcase) ? ticket : abort('Aborting.')
    end

    def check_worklog_presence(worklog_id)
      if worklog_id.nil?
        puts "No worklog specified..."
        today
        abort
      end
    end
  end
end
