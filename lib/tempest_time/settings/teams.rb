require_relative '../setting'

module TempestTime
  module Settings
    class Teams < TempestTime::Setting
      class << self
        def members(team)
          read(team)&.sort
        end

        private

        def file_name
          'teams.yml'
        end
      end
    end
  end
end