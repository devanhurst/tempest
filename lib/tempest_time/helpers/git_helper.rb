require 'git'

module TempestTime
  module Helpers
    module GitHelper
      def automatic_issue
        issue = /[A-Z]+-\d+/.match(Git.open(Dir.pwd).current_branch)
        abort('Issue not found for this branch. Please specify.') unless issue
        issue.to_s.upcase
      end
    end
  end
end