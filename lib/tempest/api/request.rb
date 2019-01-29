require 'httparty'
require 'json'
require 'yaml'

require_relative './authorization'
require_relative './response'

module Tempest
  module API
    class Request
      include HTTParty

      def initialize(*args)
        self.class.base_uri credentials.fetch(:url)
      end

      # @abstract Subclass is expected to implement #send_request
      # @!method send_request
      #    HTTParty call to API

      def response
        @response ||= response_klass.new(raw_response, self)
      end

      def response_message
        response.message
      end

      private

      attr_reader :raw_response

      # @abstract Subclass is expected to implement #request_method
      # @!method request_method
      #    RESTful operation: one of 'get', 'post', 'put', 'delete'

      # @abstract Subclass is expected to implement #request_path
      # @!method request_path
      #    Path for the operation. i.e. /users

      # @abstract Subclass is expected to implement #response_klass
      # @!method request_klass
      #    The class used to parse the response object.

      # @abstract Subclass is expected to implement #authorization_klass
      # @!method authorization_klass
      #    Define as Authorization.new in each subclass so class is dynamic.

      def request_body
        {}
      end

      def query_params
        {}
      end

      def credentials
        authorization_klass.new.credentials
      end

      def user
        credentials.fetch(:user, nil)
      end

      def token
        credentials.fetch(:token, nil)
      end

      def headers
        content_type_header
      end

      def content_type_header
        { 'Content-Type' => 'application/json' }
      end

      def authorization_header
        { 'Authorization' => "Bearer #{token}" }
      end

      def basic_auth
        { username: user, password: token }
      end
    end
  end
end