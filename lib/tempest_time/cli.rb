require 'thor'
require 'git'

require_relative 'commands/setup'
require_relative 'commands/tempo'
require_relative 'commands/jira'
require_relative 'commands/helper'

require_relative 'helpers/time_helper'

require_relative 'services/generate_report'

require_relative 'settings/authorization'
require_relative 'settings/teams'

require_relative 'api/jira_api/authorization'
require_relative 'api/jira_api/requests/get_issue'
require_relative 'api/jira_api/requests/get_user_issues'

require_relative 'api/tempo_api/authorization'
require_relative 'api/tempo_api/requests/get_worklog'
require_relative 'api/tempo_api/requests/create_worklog'
require_relative 'api/tempo_api/requests/delete_worklog'
require_relative 'api/tempo_api/requests/list_worklogs'
require_relative 'api/tempo_api/requests/submit_timesheet'

module TempestTime
  class CLI < Thor
    include TempestTime::Commands::Setup
    include TempestTime::Commands::Jira
    include TempestTime::Commands::Tempo
    include TempestTime::Commands::Helper
    include TempestTime::Helpers::TimeHelper

    # Error raised by this runner
    Error = Class.new(StandardError)

    desc 'version', 'tempest_time version'
    def version
      require_relative 'version'
      puts "v#{TempestTime::VERSION}"
    end
    map %w(--version -v) => :version

    desc 'config', 'Command description...'
    method_option :help, aliases: '-h', type: :boolean,
                         desc: 'Display usage information'
    def config(*)
      if options[:help]
        invoke :help, ['config']
      else
        require_relative 'commands/config'
        TempestTimeTime::Commands::Config.new(options).execute
      end
    end
  end
end