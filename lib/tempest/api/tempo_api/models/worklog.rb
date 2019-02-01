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
        seconds / 60.to_f
      end

      def hours
        minutes / 60.to_f
      end

      private

      def time_output
        minutes < 60 ? "#{minutes.to_i}m" : "#{hours.to_i}h"
      end
    end
  end
end