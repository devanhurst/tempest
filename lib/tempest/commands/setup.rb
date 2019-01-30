require_relative '../helpers/settings_helper'

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
            Tempest::Helpers::SettingsHelper.update('email', email)
            Tempest::Helpers::SettingsHelper.update('username', username)
            Tempest::Helpers::SettingsHelper.update('subdomain', subdomain)
            Tempest::Helpers::SettingsHelper.update('jira_token', jira_token)
            Tempest::Helpers::SettingsHelper.update('tempo_token', tempo_token)
            puts 'Good to go!'
          end

          desc 'config', 'View or modify current config settings.'
          option 'edit',
                 type: :string,
                 limited_to: %w[email id subdomain jira_token tempo_token]
          def config(command = nil)
            if command == 'edit'
              key = ask('Which value would you like to edit?',
                        limited_to: Tempest::Helpers::SettingsHelper.keys)
              new_value = ask("Please enter your new #{key}.")
              Tempest::Helpers::SettingsHelper.update(key, new_value)
            end
            puts Tempest::Helpers::SettingsHelper.to_s
          end
        end
      end
    end
  end
end