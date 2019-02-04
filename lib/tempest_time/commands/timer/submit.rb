# frozen_string_literal: true

require_relative 'timer_base'
require_relative 'status'
require_relative '../track'
require_relative 'delete'
require_relative 'stop'

module TempestTime
  module Commands
    class Timer
      class Submit < TimerBase

        attr_reader :timer_status

        def initialize
          super
          @timer_status = Commands::Timer::Status.new
        end

        def execute(input: $stdin, output: $stdout)
          return timer_status.prompt_no_timers if timer_status.log_files.empty?

          Stop.new.stop_timer
          Commands::Track.new(seconds, [ticket], 'billable' => true).execute
          Delete.new.delete_logs
        end

        private

        def seconds
          (timer_status.running_time / 60).round.to_s + 'm'
        end
      end
    end
  end
end
