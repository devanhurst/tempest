require_relative '../helpers/formatting_helper'

module Tempest
  module Models
    class Report
      include Tempest::Helpers::FormattingHelper
      EXPECTED_SECONDS = (37.5 * 60 * 60).to_i.freeze
      INTERNAL_PROJECT = 'BCIT'.freeze

      attr_reader :user, :worklogs

      def initialize(user, worklogs)
        @user = user
        @worklogs = worklogs
      end

      def to_s
        out = ''
        out << "#{braced(user)}"
        out << "#{braced("COMP: #{with_percent_sign(total_compliance_percentage)}")}"
        out << "#{braced("UTIL: #{with_percent_sign(utilization_percentage)}")}"
        project_compliance_percentages.each do |project, percentage|
          out << "#{braced("#{project}: #{with_percent_sign(percentage)}")}"
        end
        out
      end

      private

      def project_worklogs
        @project_worklogs ||= worklogs.group_by(&:project)
      end

      def project_total_times
        @project_total_times ||= project_worklogs.map do |project, worklogs|
          [project, time_logged_seconds(worklogs)]
        end.to_h
      end

      def compliance_percentage(time)
        (time.to_f / EXPECTED_SECONDS).round(2)
      end

      def project_compliance_percentages
        @project_compliance_percentages ||= project_total_times.map do |project, time|
          [project, compliance_percentage(time)]
        end.to_h.sort
      end

      def total_compliance_percentage
        @total_compliance_percentage ||= compliance_percentage(time_logged_seconds(worklogs))
      end

      def utilization_percentage
        @utilization_percentage ||= project_compliance_percentages.inject(0) do |memo, (project, percentage)|
          memo += percentage unless project == INTERNAL_PROJECT
          memo
        end
      end

      def time_logged_seconds(logs)
        logs.map(&:seconds).reduce(:+)
      end
    end
  end
end