# frozen_string_literal: true

require_relative '../../command'
require_relative '../../models/timer'

module TempestTime
  module Commands
    class Timer
      class Pause < TempestTime::Command
        def initialize(issue)
          @issue = issue || automatic_issue
          @timer = TempestTime::Models::Timer.new(@issue)
        end

        def execute(input: $stdin, output: $stdout)
          timer.pause
          TempestTime::Commands::Timer::Status.new(issue).execute
        end

        private

        attr_reader :issue, :timer
      end
    end
  end
end