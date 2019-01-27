require_relative('./macro/command')

module Tempest
  class Macro
    def initialize(commands)
      @commands = commands
    end

    def run
      commands.each do |command|
        Command.new(command)
      end
    end
  end
end