# frozen_string_literal: true

require_relative '../settings/authorization'

module TempestTime
  module API
    class Authorization
      def credentials
        { url: url, user: user, email: email, token: token }
      end

      private

      def settings
        TempestTime::Settings::Authorization.new
      end
    end
  end
end
