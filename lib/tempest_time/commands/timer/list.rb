# frozen_string_literal: true

require_relative './status'
require_relative '../../command'
require_relative '../../models/timer'

module TempestTime
  module Commands
    class Timer
      class List < TempestTime::Command
        def execute(input: $stdin, output: $stdout)
          all_timers.each do |timer|
            TempestTime::Commands::Timer::Status.new(timer.issue).execute
          end
          issue = prompt.select(
            'Please select a timer to toggle / track, or enter ^C to exit.',
            all_timers.map(&:issue)
          )
          action = action_prompt(timer(issue))
          take_action(issue, action)
        end

        private

        def all_timers
          @all_timers ||= TempestTime::Models::Timer.all_timers
        end

        def timer(issue)
          all_timers.detect { |timer| timer.issue == issue }
        end

        def action_prompt(timer)
          if timer.running?
            prompt.select('', %w[Pause Track])
          else
            prompt.select('', %w[Resume Track])
          end
        end

        def take_action(issue, action)
          case action
          when 'Pause'
            require_relative './pause'
            TempestTime::Commands::Timer::Pause.new(issue).execute
          when 'Resume'
            require_relative './start'
            TempestTime::Commands::Timer::Start.new(issue).execute
          when 'Track'
            require_relative './track'
            TempestTime::Commands::Timer::Track.new(issue).execute
          else
            abort
          end
        end
      end
    end
  end
end
