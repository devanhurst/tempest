require_relative '../response'

module TempoAPI
  module Responses
    class DeleteWorklog < TempoAPI::Response
      private

      def success_message
        "Worklog #{request.worklog_id} deleted successfully!"
      end
    end
  end
end