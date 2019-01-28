require 'yaml'

module Tempest
  module Helpers
    module SecretHelper
      def secrets
        @secrets ||= YAML::load_file('config/secrets.yml')
      end

      def update_secret
        new_secrets = YAML::load_file('config/secrets.yml')
        yield new_secrets
        File.open('config/secrets.yml', 'w') { |f| f.write new_secrets.to_yaml }
      end
    end
  end
end