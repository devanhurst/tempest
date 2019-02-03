# frozen_string_literal: true

require_relative '../command'
require_relative '../api/tempo_api/requests/delete_worklog'

module TempestTime
  module Commands
    class Delete < TempestTime::Command
      def initialize(worklogs, options)
        @worklogs = worklogs
        @options = options
      end

      def execute(input: $stdin, output: $stdout)
        pluralized = @worklogs.length > 1 ? 'worklogs' : 'worklog'
        confirm_message =
          "Delete #{pluralized} #{pastel.green(@worklogs.join(', '))}?"
        abort unless prompt.yes?(confirm_message)
        @worklogs.each { |worklog| delete_worklog(worklog) }
      end

      private

      def delete_worklog(worklog)
        with_success_fail_spinner("Deleting worklog #{worklog}...", :spin_3) do
          TempoAPI::Requests::DeleteWorklog.new(worklog).send_request
        end
      end
    end
  end
end
