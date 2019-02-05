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
          teams = TempestTime::Settings::Teams.new
          abort("There are no teams to edit!") unless teams.names.any?
          team = prompt.select(
            "Which #{pastel.green('team')} would you like to edit?",
            teams.names
          )

          members = teams.members(team)
          member = prompt.select(
            "Which #{pastel.green('member')} would you like to edit?",
            members + ['Add New Member']
          )

          replacement = prompt.ask(
            "Enter the #{pastel.green('new name')}. "\
            "Leave blank to #{pastel.red('delete')}."
          )

          teams.remove(team, member)

          if replacement.nil?
            prompt.say("Deleted #{pastel.red(member)}!")
          else
            teams.append(team, replacement)
            prompt.say("Added #{pastel.green(replacement)}")
          end

          execute unless prompt.no?('Keep editing?')
        end
      end
    end
  end
end
