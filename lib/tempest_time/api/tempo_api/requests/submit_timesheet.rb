require_relative '../request'
require_relative '../../../helpers/time_helper'
require_relative '../responses/submit_timesheet'

module TempoAPI
  module Requests
    class SubmitTimesheet < TempoAPI::Request
      include TempestTime::Helpers::TimeHelper

      attr_reader :reviewer

      def initialize(reviewer)
        super
        @reviewer = reviewer
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
        {
          from: week_dates.first.strftime(DATE_FORMAT),
          to: week_dates.last.strftime(DATE_FORMAT)
        }
      end

      def request_body
        {
          reviewerUsername: reviewer
        }
      end

      def week_dates
        parsed_date_input('week')
      end
    end
  end
end