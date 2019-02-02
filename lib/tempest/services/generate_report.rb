require_relative '../helpers/time_helper'
require_relative '../api/tempo_api/requests/list_worklogs'
require_relative '../models/report'

module Tempest
  module Services
    class GenerateReport
      include Tempest::Helpers::TimeHelper

      attr_reader :users, :week_number, :reports

      def initialize(users, week_number)
        @users = users
        @week_number = week_number || Date.today.cweek
        @reports = build_reports if valid?
      end

      def to_s
        out = "Report for period #{start_date} - #{end_date}\n"
        reports.each { |report| out << "#{report.to_s}\n" }
        out
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
          Tempest::Models::Report.new(user, request.response.worklogs)
        end
      end

      def start_date
        @start_date ||= beginning_of_week(week_number)
      end

      def end_date
        @end_date ||= start_date + 6
      end
    end
  end
end