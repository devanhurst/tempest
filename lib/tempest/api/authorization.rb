module Tempest
  module API
    class Authorization
      def update_credentials(url, user, token)
        Dir.mkdir(directory_path) unless Dir.exist?(directory_path)
        File.open(file_path, 'w') do |file|
          file.write("#{url}|#{user}|#{token}")
        end
      end

      def credentials
        File.open(file_path, 'r') do |file|
          line = file.readline.split('|')
          return nil unless line.is_a?(Array) && line.count == 3
          { url: line[0], user: line[1], token: line[2] }
        end
      end

      private

      # @abstract Subclass is expected to implement #file_name
      # @!method file_name
      #    Name of file containing API credentials in ~/.tempest

      def file_path
        [directory_path, file_name].join('/')
      end

      def directory_path
        "#{Dir.home}/.tempest"
      end
    end
  end
end