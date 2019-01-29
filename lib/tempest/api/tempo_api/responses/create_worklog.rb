require_relative '../response'
require_relative '../../../helpers/time_helper'

module TempoAPI
  module Responses
    class CreateWorklog < TempoAPI::Response
      include Tempest::Helpers::TimeHelper

      private

      def worklog_id
        @worklog_id ||= raw_response['tempoWorklogId']
      end

      def seconds
        @seconds ||= raw_response['timeSpentSeconds']
      end

      def issue_key
        @issue_key ||= raw_response['issue']['key']
      end

      def success_message
        "Worklog #{worklog_id} created! Logged #{formatted_time(seconds)} to #{issue_key}!"
      end
    end
  end
end