module Tempest
  module Commands
    module Jira
      def self.included(thor)
        thor.class_eval do
          desc 'issue [ISSUE]', 'Get Jira issue.'
          def issue(id)
            request = JiraAPI::Requests::GetIssue.new(id)
            request.send_request
            puts request.response_message
          end

          desc 'issues', 'Get all unresolved issues assigned to you.'
          def issues(requested_user = nil)
            request = JiraAPI::Requests::GetUserIssues.new(requested_user)
            request.send_request
            puts request.response_message
          end
        end
      end
    end
  end
end