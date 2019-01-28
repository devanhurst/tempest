module Tempest
  class Authorization
    class << self
      def credentials
        File.open(file_path, 'r') do |file|
          line = file.readline.split(':')
          raise StandardError unless line.count == 2
          { user: line[0], token: line[1] }
        end
      end

      def update_credentials(user, token)
        Dir.mkdir(directory_path) unless Dir.exist?(directory_path)
        File.open(file_path, 'w') do |file|
          file.write("#{user}:#{token}")
        end
      end

      private

      def with_auth_file
        Dir.mkdir(directory_path) unless Dir.exist?(directory_path)
        file = File.open(file_path, 'w')
        yield(file)
        file.close
      end

      def file_path
        [directory_path, file_name].join('/')
      end

      def directory_path
        "#{Dir.home}/.tempest"
      end

      def file_name
        'tempest'
      end
    end
  end
end