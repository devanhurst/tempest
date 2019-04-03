require_relative '../authorization'

module TempoAPI
  class Authorization < TempestTime::API::Authorization
    private

    def url
      'https://api.tempo.io/core/3'
    end

    def user
      settings.fetch('username')
    end

    def email
      settings.fetch('email')
    end

    def token
      settings.fetch('tempo_token')
    end
  end
end
