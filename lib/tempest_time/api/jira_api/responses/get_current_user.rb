# frozen_string_literal: true

require_relative '../response'
require_relative '../models/user'

module JiraAPI
  module Responses
    class GetCurrentUser < JiraAPI::Response
      def user
        @user ||= JiraAPI::Models::User.new(raw_response)
      end
    end
  end
end
