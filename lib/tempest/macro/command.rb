module Tempest
  class Macro
    class Command
      def initialize(command)
        @command = command
      end

      def parse_command
        command
      end
    end
  end
end