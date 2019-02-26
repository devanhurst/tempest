# frozen_string_literal: true

require_relative '../../command'
require_relative '../../settings/app'

module TempestTime
  module Commands
    class Config
      class App < TempestTime::Command
        def initialize(options)
          @options = options
        end

        def execute!
          settings = TempestTime::Settings::App.new
          setting = prompt.select(
            "Which #{pastel.green('setting')} would you like to edit?",
            available_options
          )

          current = settings.fetch(setting)
          new_value = send(setting, current)

          if new_value != settings.fetch(setting)
            settings.set(setting, new_value)
            prompt.say(pastel.green('Setting updated!'))
          else
            prompt.say('Nothing changed.')
          end

          execute if prompt.yes?('Keep editing?')
        end

        private

        def available_options
          [
            'internal_projects',
          ]
        end

        def internal_projects(current)
          message =
            'Please enter the ' + pastel.green('project codes') + ' of internal projects. '\
            'This is used to calculate utilization percentage in reporting. (Comma-separated)'
          prompt.ask(message, default: current&.join(', ')) do |q|
            q.convert ->(input) { input.split(/,\s*/) }
          end.sort
        end
      end
    end
  end
end
