# frozen_string_literal: true

require_relative '../../command'
require_relative '../../settings/teams'

module TempestTime
  module Commands
    class Teams
      class Delete < TempestTime::Command
        def initialize(options)
          @options = options
        end

        def execute(input: $stdin, output: $stdout)
          teams = TempestTime::Settings::Teams
          team = prompt.select(
            "Which #{pastel.green('team')} would you like to delete?",
            teams.keys
          )
          if prompt.yes?(pastel.red("Are you sure you want to delete #{team}?"))
            teams.delete(team)
            prompt.say("Successfully #{pastel.red("deleted #{team}!")}")
          else
            abort('Nothing was deleted.')
          end
          execute if prompt.yes?('Delete another team?')
        end
      end
    end
  end
end
