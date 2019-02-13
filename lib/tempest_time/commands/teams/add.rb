# frozen_string_literal: true

require_relative '../../command'
require_relative '../../settings/teams'

module TempestTime
  module Commands
    class Teams
      class Add < TempestTime::Command
        def initialize(options)
          @options = options
        end

        def execute!
          teams = TempestTime::Settings::Teams.new
          message =
            'Please enter ' + pastel.green('the members') + ' of this team. '\
            '(Comma-separated, e.g. jkirk, jpicard, bsisko, kjaneway) '
          members = prompt.ask(message) do |q|
            q.convert ->(input) { input.split(/,\s*/) }
          end
          name = prompt.ask('Please enter ' + pastel.green('the name') + ' of your new team.')
          teams.set(name, members)
          prompt.say(pastel.green('Success!'))
        end
      end
    end
  end
end
