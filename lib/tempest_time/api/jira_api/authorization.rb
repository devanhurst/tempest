require_relative '../authorization'

module JiraAPI
  class Authorization < TempestTime::API::Authorization
    private

    def url
      "https://#{subdomain}.atlassian.net/rest/api/3"
    end

    def subdomain
      settings.fetch('subdomain')
    end

    def user
      settings.fetch('username')
    end

    def email
      settings.fetch('email')
    end

    def token
      settings.fetch('jira_token')
    end
  end
end
