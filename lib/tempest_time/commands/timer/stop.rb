# frozen_string_literal: true

require_relative 'timer_base'
require_relative 'status'

module TempestTime
  module Commands
    class Timer
      class Stop < TimerBase

        attr_reader :timer_status

        def initialize
          super
          @timer_status = Commands::Timer::Status.new
        end

        def execute(input: $stdin, output: $stdout)
          return timer_status.prompt_no_timers if timer_status.log_files.empty?
          stop_timer
        end

        private

        def stop_timer
          timer_status.log_files.each do |log|
            FileUtils.touch(log) if timer_status.log_running?(log)
          end

          prompt.say(pastel.green("#{ticket} Timer stopped"))
        end
      end
    end
  end
end