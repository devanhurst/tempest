require_relative '../setting'

module TempestTime
  module Settings
    class App < TempestTime::Setting
      def initialize
        super
        config.filename = 'config'
      end
    end
  end
end
