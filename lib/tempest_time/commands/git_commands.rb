require_relative '../api/jira_api/requests/get_issue'

module TempestTime
  module Commands
    module GitCommands
      def automatic_ticket
        ticket = /[A-Z]+-\d+/.match(Git.open(Dir.pwd).current_branch)
        abort('Ticket not found for this branch. Please specify.') unless ticket
        ticket.to_s
      end
    end
  end
end