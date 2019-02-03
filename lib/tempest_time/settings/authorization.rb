require_relative '../setting'

module TempestTime
  module Settings
    class Authorization < TempestTime::Setting
      class << self
        private

        def file_name
          'auth.yml'
        end

        def file_path
          [directory_path, file_name].join('/')
        end
      end
    end
  end
end