require_relative '../settings'

module Tempest
  module Commands
    module Setup
      def self.included(thor)
        thor.class_eval do
          desc 'setup', 'Setup Tempest to talk to Jira and Tempo.'
          def setup
            email = ask(
              'Enter your Atlassian ID. '\
              'This is typically your login email.'
            )
            username = ask(
              'Enter your Tempo username.'
            )
            subdomain = ask(
              'Enter your Atlassian subdomain. '\
              'i.e. [THIS VALUE].atlassian.net'
            )
            jira_token = ask(
              'Enter your Atlassian API token. '\
              'Your token can be generated at https://id.atlassian.com.'
            )
            tempo_token = ask(
              'Enter your Tempo API token. '\
              "Your token can be generated through your worksheet's settings page."
            )

            if [email, username, subdomain, jira_token, tempo_token].any?(&:empty?)
              abort('One or more credentials were missing. Please try again.')
            end

            puts 'Setting up...'
            Tempest::Settings.update('email', email)
            Tempest::Settings.update('username', username)
            Tempest::Settings.update('subdomain', subdomain)
            Tempest::Settings.update('jira_token', jira_token)
            Tempest::Settings.update('tempo_token', tempo_token)
            puts 'Good to go!'
          end

          desc 'config (edit)', 'View (config) or modify (config edit) current settings.'
          long_desc <<-LONGDESC
            `tempest config` will list current user configs.\n
            `tempest config edit` will prompt you to select a config value to edit.\n
          LONGDESC
          def config(command = nil)
            if command == 'edit'
              key = ask('Which value would you like to edit?',
                        limited_to: Tempest::Settings.keys)
              new_value = ask("Please enter your new #{key}.")
              Tempest::Settings.update(key, new_value)
            end
            puts Tempest::Settings.to_s
          end
        end
      end
    end
  end
end