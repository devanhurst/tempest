require_relative '../../command'
require_relative '../git_commands'
require_relative 'status'
require 'tempfile'


module TempestTime
  module Commands
    class Timer
      class Start < TempestTime::Command
        include Commands::GitCommands

        TEMP_DIR = '/tmp/timer/logs'.freeze
        FILE_EXT = '.timer'.freeze

        attr_reader :ticket, :timer_status

        def initialize
          @ticket = automatic_ticket
          @timer_status = Command::Timer::Status.new(ticket)
          ensure_tmp_dir
        end

        def execute(input: $stdin, output: $stdout)
          start_timer
        end

        private

        def ensure_tmp_dir
          FileUtils.mkdir_p TEMP_DIR unless File.directory? TEMP_DIR
        end

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
