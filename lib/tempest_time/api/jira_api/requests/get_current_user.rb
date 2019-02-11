# frozen_string_literal: true

require_relative '../request'
require_relative '../responses/get_current_user'

module JiraAPI
  module Requests
    # :no-doc:
    class GetCurrentUser < JiraAPI::Request
      private

      def request_method
        'get'
      end

      def request_path
        '/myself'
      end

      def response_klass
        JiraAPI::Responses::GetCurrentUser
      end
    end
  end
end
