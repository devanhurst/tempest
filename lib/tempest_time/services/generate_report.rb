require_relative '../helpers/time_helper'
require_relative '../api/tempo_api/requests/list_worklogs'
require_relative '../models/report'

module TempestTime
  module Services
    class GenerateReport
      include TempestTime::Helpers::TimeHelper

      attr_reader :users, :week_number, :reports

      def initialize(users, week_number)
        @users = users
        @week_number = week_number || Date.today.cweek
        @reports = build_reports if valid?
      end

      def projects
        @projects ||= reports.flat_map(&:projects).uniq
      end

      def aggregate
        @aggregate ||= TempestTime::Models::Report.new(
          'TOTAL',
          reports.flat_map(&:worklogs),
          users.count
        )
      end

      def start_date
        @start_date ||= beginning_of_week(week_number)
      end

      def end_date
        @end_date ||= start_date + 6
      end

      private

      def valid?
        return false unless week_number <= Date.today.cweek
        true
      end

      def build_reports
        users.map do |user|
          request = TempoAPI::Requests::ListWorklogs.new(start_date, end_date, user)
          request.send_request
          TempestTime::Models::Report.new(user, request.response.worklogs)
        end
      end
    end
  end
end