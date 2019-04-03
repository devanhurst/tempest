require_relative '../response'
require_relative '../models/user'

module JiraAPI
  module Responses
    class SearchUsers < JiraAPI::Response
      def users
        @users ||= raw_response.parsed_response.map { |user| JiraAPI::Models::User.new(user) }
      end
    end
  end
end
