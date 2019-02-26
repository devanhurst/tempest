# frozen_string_literal: true

require_relative '../../command'
require_relative '../../settings/authorization'

module TempestTime
  module Commands
    class Config
      class Auth < TempestTime::Command
        def initialize(options)
          @options = options
        end

        def execute!
          settings = TempestTime::Settings::Authorization.new
          setting = prompt.select(
            "Which #{pastel.green('setting')} would you like to edit?",
            settings.keys
          )

          new_value = prompt.ask(
            "Enter the #{pastel.green('new value')}.",
            default: settings.fetch(setting)
          )

          if new_value != settings.fetch(setting)
            settings.set(setting, new_value)
            prompt.say(pastel.green('Setting updated!'))
          else
            prompt.say('Nothing changed.')
          end

          execute if prompt.yes?('Keep editing?')
        end
      end
    end
  end
end
