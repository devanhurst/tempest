require_relative('../tempest/authorization')

module TempoAPI
  class Authorization < Tempest::Authorization
    class << self
      private

      def file_name
        'tempo_api'
      end
    end
  end
end