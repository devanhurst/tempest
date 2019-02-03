# frozen_string_literal: true

require_relative '../../command'
require_relative '../../settings/authorization'

module TempestTime
  module Commands
    class Config
      class Setup < TempestTime::Command
        def initialize(options)
          @options = options
        end

        def execute(input: $stdin, output: $stdout)
          email = prompt.ask(
            'Please enter your Atlassian ID. '\
            'This is typically your login email.'
          )
          username = prompt.ask(
            'Please enter your Atlassian username.'
          )
          subdomain = prompt.ask(
            'Please enter your Atlassian subdomain. '\
            'i.e. [THIS VALUE].atlassian.net'
          )
          jira_token = prompt.ask(
            'Please enter your Atlassian API token. '\
            'Your token can be generated at https://id.atlassian.com/manage/api-tokens'
          )
          tempo_token = prompt.ask(
            'Please enter your Tempo API token. '\
            "Your token can be generated through your worksheet's settings page."
          )

          if [email, username, subdomain, jira_token, tempo_token].any?(&:nil?)
            abort(
              pastel.red('Setup failed!') + ' ' +
              'One or more credentials were missing. Please try again.'
            )
          end

          authorization = TempestTime::Settings::Authorization

          authorization.update('email', email)
          authorization.update('username', username)
          authorization.update('subdomain', subdomain)
          authorization.update('jira_token', jira_token)
          authorization.update('tempo_token', tempo_token)

          puts pastel.green('Setup complete!')
        end
      end
    end
  end
end
