# frozen_string_literal: true

require_relative '../command'
require_relative '../settings/authorization'
require_relative '../settings/app'
require_relative '../api/jira_api/requests/get_current_user'
require_relative '../api/tempo_api/requests/list_worklogs'

module TempestTime
  module Commands
    class Setup < TempestTime::Command
      def initialize(options)
        @options = options
      end

      def execute!
        check_for_completion
        set_authorization_values
        set_app_settings
        with_spinner('Checking credentials...') do |spinner|
          begin
            check_for_validity
            spinner.stop(pastel.green("Success! You're ready to go!"))
          rescue StandardError
            spinner.stop(
              pastel.red("Something isn't right... please re-run setup.")
            )
          end
        end
      end

      private

      def credentials
        @credentials ||= {
          'email' => email,
          'username' => username,
          'subdomain' => subdomain,
          'jira_token' => jira_token,
          'tempo_token' => tempo_token,
        }
      end

      def app_settings_values
        @app_settings_values ||= {
          'internal_projects' => internal_projects,
        }
      end

      def authorization
        @authorization ||= TempestTime::Settings::Authorization.new
      end

      def app_settings
        @app_settings ||= TempestTime::Settings::App.new
      end

      def check_for_completion
        return true unless credentials.any? { |_, value| value.nil? }
        abort(
          pastel.red('Setup failed!') + ' ' \
          'One or more credentials were missing. Please try again.'
        )
      end

      def set_authorization_values
        credentials.map { |key, value| authorization.set(key, value) }
      end

      def set_app_settings
        app_settings_values.map { |key, value| app_settings.set(key, value) }
      end

      def check_for_validity
        jira = JiraAPI::Requests::GetCurrentUser.new
        tempo = TempoAPI::Requests::ListWorklogs.new(Date.today)
        raise StandardError unless jira.send_request.success?
        raise StandardError unless tempo.send_request.success?
      end

      def email
        prompt.ask(
          'Please enter your Atlassian ID. '\
          'This is typically your login email.',
          default: authorization.fetch('email')
        )
      end

      def username
        prompt.ask(
          'Please enter your Atlassian username.',
          default: authorization.fetch('username')
        )
      end

      def subdomain
        prompt.ask(
          'Please enter your Atlassian subdomain. '\
          'i.e. [THIS VALUE].atlassian.net',
          default: authorization.fetch('subdomain')
        )
      end

      def jira_token
        prompt.ask(
          'Please enter your Atlassian API token. '\
          'Your token can be generated at '\
          'https://id.atlassian.com/manage/api-tokens',
          default: authorization.fetch('jira_token')
        )
      end

      def tempo_token
        prompt.ask(
          'Please enter your Tempo API token. '\
          'Your token can be generated through '\
          "your worksheet's settings page.",
          default: authorization.fetch('tempo_token')
        )
      end

      def internal_projects
        current = app_settings.fetch('internal_projects')&.join(', ') || ''

        prompt.ask(
          'Please enter the project codes of internal projects. (Optional, comma-separated.) '\
          'This is used to calculate utilization percentage in reporting.',
          default: current
        ) do |q|
          q.convert ->(input) { input.split(/,\s*/) }
        end.sort
      end
    end
  end
end
