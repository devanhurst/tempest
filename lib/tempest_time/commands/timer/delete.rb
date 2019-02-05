# frozen_string_literal: true

require_relative '../../command'
require_relative '../../models/timer'

module TempestTime
  module Commands
    class Timer
      class Delete < TempestTime::Command
        def initialize(issue)
          @issue = issue || automatic_issue
          @timer = TempestTime::Models::Timer.new(@issue)
        end

        def execute(input: $stdin, output: $stdout)
          timer.delete ? deleted_message : no_timer_message
        end

        private

        attr_reader :issue, :timer

        def deleted_message
          prompt.say('baleeted')
        end

        def no_timer_message
          prompt.say('noleeted')
        end
      end
    end
  end
end
