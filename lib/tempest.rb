require 'tempest/version'
require_relative 'tempest/menus/main_menu'

module Tempest
  class Runner
    def start(args)
      Tempest::MainMenu.start(args)
    end
  end
end
