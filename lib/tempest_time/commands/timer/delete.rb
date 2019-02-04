# frozen_string_literal: true

require_relative 'timer_base'
require_relative 'status'

module TempestTime
  module Commands
    class Timer
      class Delete < TimerBase

        attr_reader :timer_status

        def initialize
          super
          @timer_status = Commands::Timer::Status.new
        end

        def execute(input: $stdin, output: $stdout)
          return timer_status.prompt_no_timers if timer_status.log_files.empty?

          timer_status.log_files.each { |log| File.unlink log }
          prompt.say(pastel.green("#{ticket} Timer deleted"))
        end
      end
    end
  end
end
