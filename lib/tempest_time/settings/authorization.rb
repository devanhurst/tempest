require_relative '../setting'

module TempestTime
  module Settings
    class Authorization < TempestTime::Setting
      def initialize
        super
        config.filename = 'auth'
      end
    end
  end
end
