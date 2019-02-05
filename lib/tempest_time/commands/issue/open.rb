# frozen_string_literal: true

require_relative '../../command'
require_relative '../../settings/authorization'

module TempestTime
  module Commands
    class Issue
      class Open < TempestTime::Command
        def initialize(issue)
          @issue = issue.upcase
          @issue = automatic_issue if issue.empty?
        end

        def execute(input: $stdin, output: $stdout)
          command.run("open #{url(@issue)}")
        end

        private

        def url(issue)
          domain = TempestTime::Settings::Authorization.new.fetch('subdomain')
          "https://#{domain}.atlassian.net/browse/#{issue}"
        end
      end
    end
  end
end