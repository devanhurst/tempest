require_relative '../helpers/formatting_helper'

module TempestTime
  module Models
    class Report
      include TempestTime::Helpers::FormattingHelper
      EXPECTED_SECONDS = (37.5 * 60 * 60).to_i.freeze
      INTERNAL_PROJECT = 'BCIT'.freeze

      attr_reader :user, :worklogs, :number_of_users

      def initialize(user, worklogs, number_of_users: 1)
        @user = user
        @worklogs = worklogs
        @number_of_users = number_of_users
      end

      def project_total_times
        @project_total_times ||= project_worklogs.map do |project, worklogs|
          [project, time_logged_seconds(worklogs)]
        end.to_h
      end

      def compliance_percentage(time)
        (time.to_f / (EXPECTED_SECONDS * number_of_users))
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
        @utilization_percentage ||=
          project_compliance_percentages.inject(0) do |memo, (project, percentage)|
            memo += percentage unless project == INTERNAL_PROJECT
            memo
          end
      end

      def time_logged_seconds(logs)
        logs.flat_map(&:seconds).reduce(:+)
      end

      def project_worklogs
        @project_worklogs ||= worklogs.group_by(&:project)
      end

      def projects
        @projects ||= project_worklogs.keys.sort
      end
    end
  end
end
