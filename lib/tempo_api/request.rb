require 'httparty'
require 'json'
require 'yaml'
require_relative 'response'

module TempoAPI
  class Request
    include HTTParty

    base_uri 'https://api.tempo.io/2/'

    def send_request
      @raw_response ||= self.class.send(
          request_method,
          request_path,
          headers: headers,
          body: request_body,
          query: query_params
      )

      true
    end

    def response_message
      response.message
    end

    private

    attr_reader :raw_response

    def response_klass
      TempoAPI::Response
    end

    def response
      @response ||= response_klass.new(raw_response)
    end

    def headers
      content_type_header
        .merge(authorization_header)
    end

    def content_type_header
      { 'Content-Type' => 'application/json' }
    end

    def authorization_header
      { 'Authorization' => "Bearer #{auth_token}" }
    end

    def request_body
      {}
    end

    def query_params
      {}
    end

    def user
      @user ||= secrets.fetch('user')
    end

    def auth_token
      @auth_token ||= secrets.fetch('token')
    end

    def secrets
      @secrets ||= YAML::load_file('config/secrets.yml')['tempo']
    end
  end
end