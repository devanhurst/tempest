require_relative '../authorization'

module JiraAPI
  class Authorization < TempestTime::API::Authorization
    private

    def url
      "https://#{subdomain}.atlassian.net/rest/api/3"
    end

    def subdomain
      settings.read('subdomain')
    end

    def user
      settings.read('username')
    end

    def email
      settings.read('email')
    end

    def token
      settings.read('jira_token')
    end
  end
end
