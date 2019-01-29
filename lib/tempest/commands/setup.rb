module Tempest
  module Commands
    module Setup
      def self.included(thor)
        thor.class_eval do
          desc 'setup [TOOL]', 'Provide Jira and Tempo credentials.'
          def setup
            email = ask(
              'Enter your Atlassian ID. '\
              'This is typically your login email.'
            )
            id = ask('Enter your Tempo username.')
            domain = ask(
              'Enter your Atlassian subdomain. '\
              'i.e. [THIS VALUE].atlassian.net'
            )
            jira_token = ask(
              'Enter your Atlassian API token. '\
              'Your token can be generated at https://id.atlassian.com.'
            )
            tempo_token = ask(
              'Enter your Tempo API token. '\
              "Your tempo token can be generated through your worksheet's settings page."
            )

            if [email, id, domain, jira_token, tempo_token].any?(&:empty?)
              abort('One or more credentials were missing. Please try again.')
            end

            puts 'Setting up...'

            TempoAPI::Authorization.new.update_credentials(
              'https://api.tempo.io/2',
              id,
              tempo_token
            )
            JiraAPI::Authorization.new.update_credentials(
              "https://#{domain}.atlassian.net/rest/api/3",
              email,
              jira_token

            )
            puts 'Good to go!'
          end
        end
      end
    end
  end
end