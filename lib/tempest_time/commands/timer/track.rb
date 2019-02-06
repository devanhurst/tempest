# frozen_string_literal: true

require_relative '../track'
require_relative '../../command'
require_relative '../../models/timer'

module TempestTime
  module Commands
    class Timer
      class Track < TempestTime::Command
        attr_reader :timer, :issue

        def initialize(issue)
          @issue = issue || automatic_issue
          @timer = TempestTime::Models::Timer.new(@issue)
        end

        def execute(input: $stdin, output: $stdout)
          abort(pastel.red("No timer for #{issue}!")) unless timer.exists?
          timer.pause
          track_time
          timer.delete
        end

        private

        def track_time
          issue = prompt.ask(
            'Which issue should this time be logged to?',
            default: timer.issue
          )
          time = prompt.ask(
            "How much time should be logged to #{issue}?",
            default: formatted_time_for_input(timer.runtime)
          )
          billable = prompt.yes?('Is this time billable?')
          message = prompt.ask('Add a message. (optional)')
          Commands::Track.new(
            parsed_time(time),
            [issue],
            'message' => message,
            'billable' => billable
          ).execute
        end
      end
    end
  end
end
