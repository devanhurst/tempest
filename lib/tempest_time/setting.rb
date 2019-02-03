require 'yaml'

module TempestTime
  class Setting
    class << self
      def contents
        file.map do |key, value|
          { key => value }
        end
      end

      def read(key)
        file[key]
      end

      def keys
        file.keys.sort
      end

      def update(key, value)
        temp = file
        temp[key] = value
        File.open(file_path, 'w') { |f| f.write temp.to_yaml }
      end

      def delete(key)
        temp = file.tap { |f| f.delete(key) }
        File.open(file_path, 'w') { |f| f.write temp.to_yaml }
      end

      private

      def file
        Dir.mkdir(directory_path) unless Dir.exist?(directory_path)
        File.exist?(file_path) ? YAML.load_file(file_path) : {}
      end

      def file_path
        [directory_path, file_name].join('/')
      end

      def directory_path
        "#{Dir.home}/.tempest"
      end
    end
  end
end
