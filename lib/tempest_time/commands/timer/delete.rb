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

        def execute!
          timer.exists? ? deleted_message : no_timer_message
          timer.delete
        end

        private

        attr_reader :issue, :timer

        def deleted_message
          prompt.say(
            pastel.yellow(
              "Timer #{issue} deleted at #{formatted_time_long(timer.runtime)}"
            )
          )
        end

        def no_timer_message
          prompt.say(pastel.red("Timer #{issue} does not exist!"))
        end
      end
    end
  end
end
