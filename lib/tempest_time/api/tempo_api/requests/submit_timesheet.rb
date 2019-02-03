require_relative '../request'
require_relative '../../../helpers/time_helper'
require_relative '../responses/submit_timesheet'

module TempoAPI
  module Requests
    class SubmitTimesheet < TempoAPI::Request
      include TempestTime::Helpers::TimeHelper

      attr_reader :reviewer, :week_number

      def initialize(reviewer, week_number)
        super
        @reviewer = reviewer
        @week_number = week_number
      end

      private

      def request_method
        'post'
      end

      def request_path
        "/timesheet-approvals/user/#{user}/submit"
      end

      def response_klass
        TempoAPI::Responses::SubmitTimesheet
      end

      def query_params
        dates = week_dates(week_number)
        {
          from: dates.first.strftime(DATE_FORMAT),
          to: dates.last.strftime(DATE_FORMAT)
        }
      end

      def request_body
        {
          reviewerUsername: reviewer
        }
      end
    end
  end
end