require 'httparty'
require 'json'
require 'yaml'

require_relative '../request'
require_relative './response'
require_relative './authorization'

module TempoAPI
  class Request < Tempest::API::Request
    def send_request
      @raw_response = self.class.send(
        request_method,
        request_path,
        headers: headers,
        body: request_body.empty? ? request_body : request_body.to_json,
        query: query_params
      )
      true
    end

    private

    def authorization_klass
      Authorization
    end

    def headers
      super.merge(authorization_header)
    end

    def response_klass
      TempoAPI::Response
    end
  end
end