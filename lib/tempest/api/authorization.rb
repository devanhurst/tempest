require_relative '../setting'

module Tempest
  module API
    class Authorization
      def credentials
        { url: url, user: user, email: email, token: token }
      end

      private

      def settings
        Tempest::Settings::Authorization
      end
    end
  end
end