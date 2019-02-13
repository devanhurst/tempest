# frozen_string_literal: true

require_relative '../../command'
require_relative '../../models/timer'

module TempestTime
  module Commands
    class Timer
      class Status < TempestTime::Command
        def initialize(issue)
          @issue = issue || automatic_issue
          @timer = TempestTime::Models::Timer.new(issue)
        end

        def execute!
          prompt.say("#{issue}: #{status_message}")
        end

        private

        attr_reader :issue, :timer

        def status_message
          if timer.running?
            pastel.green("#{formatted_time_long(timer.runtime)} running")
          else
            pastel.yellow("#{formatted_time_long(timer.runtime)} paused")
          end
        end
      end
    end
  end
end
