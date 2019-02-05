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

          delete_logs
          prompt.say(pastel.green("#{ticket} Timer deleted"))
        end

        def delete_logs
          timer_status.log_files.each { |log| File.unlink log }
        end
      end
    end
  end
end
