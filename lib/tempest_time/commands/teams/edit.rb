# frozen_string_literal: true

require_relative '../../command'
require_relative '../../settings/teams'

module TempestTime
  module Commands
    class Teams
      class Edit < TempestTime::Command
        def initialize(options)
          @options = options
        end

        def execute(input: $stdin, output: $stdout)
          teams = TempestTime::Settings::Teams
          team = prompt.select(
            "Which #{pastel.green('team')} would you like to edit?",
            teams.keys
          )

          members = teams.members(team)
          member = prompt.select(
            "Which #{pastel.green('member')} would you like to edit?",
            members + ['Add New Member']
          )

          replace = prompt.ask(
            "Enter the #{pastel.green('new name')}. "\
            "Leave blank to #{pastel.red('delete')}."
          )

          members.delete(member)

          if replace.nil?
            teams.update(team, members)
            prompt.say("Deleted #{pastel.red(member)}!")
          else
            members.push(replace)
            teams.update(team, members)
            prompt.say("Added #{pastel.green(replace)}")
          end

          execute if prompt.yes?('Keep editing?')
        end
      end
    end
  end
end
