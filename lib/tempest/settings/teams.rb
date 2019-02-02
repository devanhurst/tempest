require_relative '../setting'

module Tempest
  module Settings
    class Teams < Tempest::Setting
    class << self
        def members(team)
          read(team).delete(' ').split(',')
        end

        private

        def file_name
          'teams.yml'
        end
      end
    end
  end
end