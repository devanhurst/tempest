require_relative '../response'

module TempoAPI
  module Responses
    class SubmitTimesheet < TempoAPI::Response
      private

      def success_message
        "Timesheet submitted successfully to #{request.reviewer}!"
      end
    end
  end
end