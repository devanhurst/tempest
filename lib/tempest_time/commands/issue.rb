# frozen_string_literal: true

require_relative '../command'
require_relative '../settings/authorization'

module TempestTime
  module Commands
    class Issue < TempestTime::Command
      def initialize(issue)
        @issue = issue.upcase
      end

      def execute(input: $stdin, output: $stdout)
        command.run("open #{url(@issue)}")
      end

      private

      def url(issue)
        domain = TempestTime::Settings::Authorization.read('subdomain')
        "https://#{domain}.atlassian.net/browse/#{issue}"
      end
    end
  end
end
