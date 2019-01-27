require 'tempest/version'
require_relative 'tempest/cli/main_menu'

module Tempest
  class Runner
    def start(args)
      Tempest::CLI::MainMenu.start(args)
    end
  end
end
