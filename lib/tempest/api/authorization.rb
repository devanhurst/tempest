require_relative '../helpers/settings_helper'

module Tempest
  module API
    class Authorization
      def credentials
        { url: url, user: user, email: email, token: token }
      end

      private

      def settings
        Tempest::Helpers::SettingsHelper
      end
    end
  end
end