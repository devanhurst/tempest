require_relative '../settings'

module Tempest
  module API
    class Authorization
      def credentials
        { url: url, user: user, email: email, token: token }
      end

      private

      def settings
        Tempest::Settings
      end
    end
  end
end