require 'tempest/version'
require_relative 'tempest/cli'

module Tempest
  class Runner
    def start(args)
      Tempest::CLI.start(args)
    end
  end
end
