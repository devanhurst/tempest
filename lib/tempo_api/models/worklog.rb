module TempoAPI
  module Models
    class Worklog
      attr_reader :id, :issue, :seconds, :description

      def initialize(options)
        @id = options.fetch(:id)
        @issue = options.fetch(:issue)
        @seconds = options.fetch(:seconds)
        @description = options.fetch(:description)
      end

      def to_s
        "#{id}: #{issue}: #{time_output}: #{description}"
      end

      def minutes
        seconds / 60
      end

      def hours
        (minutes.to_f / 60).round(2)
      end

      private

      def time_output
        minutes < 60 ? "#{minutes}m" : "#{hours}h"
      end
    end
  end
end