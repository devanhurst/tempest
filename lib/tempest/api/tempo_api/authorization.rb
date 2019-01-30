require_relative '../authorization'

module TempoAPI
  class Authorization < Tempest::API::Authorization
    private

    def url
      'https://api.tempo.io/2'
    end

    def user
      settings.read('username')
    end

    def email
      settings.read('email')
    end

    def token
      settings.read('tempo_token')
    end
  end
end
