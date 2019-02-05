require_relative '../setting'

module TempestTime
  module Settings
    class Teams < TempestTime::Setting
      def initialize
        super
        config.filename = 'teams'
      end

      alias names keys

      def members(team)
        config.fetch(team)&.sort
      end
    end
  end
end