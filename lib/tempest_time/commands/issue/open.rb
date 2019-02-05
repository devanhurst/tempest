# frozen_string_literal: true

require_relative '../../command'
require_relative '../../settings/authorization'

module TempestTime
  module Commands
    class Issue
      class Open < TempestTime::Command
        def initialize(issues)
          @issues = issues.map(&:upcase)
          @issues = [automatic_issue] if issues.empty?
        end

        def execute(input: $stdin, output: $stdout)
          @issues.each { |issue| command.run("open #{url(issue)}") }
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