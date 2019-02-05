# frozen_string_literal: true

require_relative '../../command'
require_relative '../git_commands'
require 'tempfile'

module TempestTime
  module Commands
    class Timer
      class TimerBase < TempestTime::Command
        include Commands::GitCommands

        TEMP_DIR = '/tmp/timer/logs'.freeze
        FILE_EXT = '.timer'.freeze

        attr_reader :ticket

        def initialize
          ensure_tmp_dir
          @ticket = automatic_ticket
        end

        private

        def ensure_tmp_dir
          FileUtils.mkdir_p TEMP_DIR unless File.directory? TEMP_DIR
        end
      end
    end
  end
end
