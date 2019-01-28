require_relative '../authorization'

module JiraAPI
  class Authorization < Tempest::API::Authorization
    private

    def file_name
      'jira_api'
    end
  end
end
