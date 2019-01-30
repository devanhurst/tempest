require 'thor'
require 'git'

require_relative 'commands/setup'
require_relative 'commands/tempo'
require_relative 'commands/jira'
require_relative 'commands/helper'

require_relative 'helpers/time_helper'

require_relative 'api/jira_api/authorization'
require_relative 'api/jira_api/requests/get_issue'
require_relative 'api/jira_api/requests/get_user_issues'

require_relative 'api/tempo_api/authorization'
require_relative 'api/tempo_api/requests/create_worklog'
require_relative 'api/tempo_api/requests/delete_worklog'
require_relative 'api/tempo_api/requests/list_worklogs'

module Tempest
  class CLI < Thor
    include Tempest::Commands::Setup
    include Tempest::Commands::Jira
    include Tempest::Commands::Tempo
    include Tempest::Commands::Helper
    include Tempest::Helpers::TimeHelper
  end
end