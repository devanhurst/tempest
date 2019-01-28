require_relative('../authorization')

module TempoAPI
  class Authorization < Tempest::API::Authorization
    private

    def authorization
      Authorization.new
    end

    def file_name
      'tempo_api'
    end
  end
end