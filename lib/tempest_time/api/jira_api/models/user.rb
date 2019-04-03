# frozen_string_literal: true

module JiraAPI
  module Models
    class User
      def initialize(user)
        @user_data = user
      end

      def name
        @name ||= user_data['displayName']
      end

      def username
        @username ||= user_data['name']
      end

      def email
        @email ||= user_data['emailAddress']
      end

      def account_id
        @account_id ||= user_data['accountId']
      end

      private

      attr_reader :user_data
    end
  end
end
