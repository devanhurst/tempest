module Tempest
  module Commands
    module Jira
      def self.included(thor)
        thor.class_eval do
          desc 'issue [ISSUE]', 'Get Jira issue'
          def issue(id)
            request = JiraAPI::Requests::GetIssue.new(id)
            request.send_request
            puts request.response_message
          end

          map 'i' => 'issue'
        end
      end
    end
  end
end