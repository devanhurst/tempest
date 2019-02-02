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

            authorization = Tempest::Settings::Authorization

            puts 'Setting up...'
            authorization.update('email', email)
            authorization.update('username', username)
            authorization.update('subdomain', subdomain)
            authorization.update('jira_token', jira_token)
            authorization.update('tempo_token', tempo_token)
            puts 'Good to go!'
          end

          desc 'config (edit)', 'View (config) or modify (config edit) current settings.'
          long_desc <<-LONGDESC
            `tempest config` will list current user configs.\n
            `tempest config edit` will prompt you to select a config value to edit.\n
          LONGDESC
          def config(command = nil)
            auth = Tempest::Settings::Authorization
            if command == 'edit'
              key = ask('Which value would you like to edit?',
                        limited_to: auth.keys)
              new_value = ask("Please enter your new #{key}.")
              auth.update(key, new_value)
            end
            puts auth.to_s
          end

          desc 'teams (new, edit)', 'Add (teams add) or modify (teams edit) teams for group reporting.'
          def teams(command = nil)
            teams = Tempest::Settings::Teams
            if command == 'add'
              members = ask(
                "Please enter the members of this team.\n"\
                '(Comma-separated, e.g. jkirk, jpicard, bsisko, kjaneway) '
              )
              name = ask('Please enter the name of your new team.')
              teams.update(name, members)
            elsif command == 'edit'
              name = ask('Which team would you like to edit?',
                         limited_to: teams.keys)
              members = ask(
                "Please enter the members of this team.\n"\
                '(Comma-separated, e.g. jkirk, jpicard, bsisko, kjaneway) '
              )
              teams.update(name, members)
            end
            puts teams.to_s
          end
        end
      end
    end
  end
end