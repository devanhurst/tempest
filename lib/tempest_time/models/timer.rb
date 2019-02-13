# frozen_string_literal: true

require 'tempfile'

module TempestTime
  module Models
    class Timer
      TEMP_DIR = Dir.home + '/.tempest/timer/logs'
      FILE_EXT = '.timer'
      PREFIX_SEPARATOR = '___'

      class << self
        def all_timers
          issues = Dir.glob("#{TEMP_DIR}/*#{FILE_EXT}").map do |file|
            file.delete(TEMP_DIR).split(PREFIX_SEPARATOR).first
          end

          issues.uniq.sort.map { |issue| new(issue) }
        end
      end

      attr_reader :issue

      def initialize(issue)
        ensure_tmp_dir
        @issue = issue
      end

      def start
        return false if running?
        Tempfile.create([log_file_prefix, FILE_EXT], TEMP_DIR)
      end

      def pause
        log_files.each do |log|
          FileUtils.touch(log) if log_running?(log)
        end
      end

      def delete
        return false unless exists?
        log_files.each { |log| File.unlink log }
      end

      def runtime
        @runtime ||= log_files.each_with_object([]) do |log, array|
          start_time = File.birthtime(log)
          end_time = log_running?(log) ? Time.now : File.mtime(log)

          array << (end_time - start_time)
        end.reduce(:+)
      end

      def running?
        log_files.any? { |log| log_running?(log) }
      end

      def exists?
        log_files.any?
      end

      private

      def log_file_prefix
        "#{issue}#{PREFIX_SEPARATOR}"
      end

      def log_running?(log)
        File.birthtime(log).eql? File.mtime(log)
      end

      def log_files
        @log_files ||= Dir.glob("#{TEMP_DIR}/#{issue}*#{FILE_EXT}")
      end

      def ensure_tmp_dir
        FileUtils.mkdir_p TEMP_DIR unless File.directory? TEMP_DIR
      end
    end
  end
end
