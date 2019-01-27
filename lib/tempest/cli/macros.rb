require 'thor'

module Tempest
  module CLI
    class Macros < Thor
      namespace :macros

      desc 'test', 'test'
      def test
        'test'
      end
    end
  end
end