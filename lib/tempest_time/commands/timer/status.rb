# frozen_string_literal: true

require_relative 'timer_base'
require 'tempfile'
require 'byebug'

module TempestTime
  module Commands
    class Timer
      class Status < TimerBase

        def execute(input: $stdin, output: $stdout)
          display_status
        end

        def display_status
          return prompt_no_timers if log_files.empty?

          prompt.say(
              pastel.green("#{ticket} #{running_time.to_i}s #{timer_running_status}")
          )
        end

        def log_running?(log)
          File.birthtime(log).eql? File.mtime(log)
        end

        def log_files
          @log_files ||= Dir.glob("#{TEMP_DIR}/#{ticket}*#{FILE_EXT}")
        end

        def timer_running?
          log_files.any? { |log| log_running?(log) }
        end

        def log_running?(log)
          File.birthtime(log).eql? File.mtime(log)
        end

        def prompt_no_timers
          prompt.say(pastel.green "No timers found.")
        end

        private

        def running_time
          logs = log_files.each_with_object([]) do |log, array|
            start_time = File.birthtime(log)
            end_time = log_running?(log) ? Time.now : File.mtime(log)

            array << (end_time - start_time)
          end

          logs.sum
        end

        def timer_running_status
          timer_running? ? 'running' : 'stopped'
        end
      end
    end
  end
end
