# frozen_string_literal: true

require_relative 'timer_base'
require_relative 'status'

module TempestTime
  module Commands
    class Timer
      class Start < TimerBase

        attr_reader :timer_status

        def initialize
          super
          @timer_status = Commands::Timer::Status.new
        end

        def execute(input: $stdin, output: $stdout)
          start_timer
        end

        private

        def display_status
          timer_status.display_status

          prompt.say(
              pastel.yellow("Timer for #{ticket} is already running.")
          )
        end

        def ticket_prefix
          "#{ticket}-"
        end

        def create_log
          Tempfile.create([ticket_prefix, FILE_EXT], TEMP_DIR)
          prompt.say(pastel.green("#{ticket} Timer started"))
        end

        def start_timer
          timer_status.timer_running? ? display_status : create_log
        end
      end
    end
  end
end
