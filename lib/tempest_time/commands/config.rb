# frozen_string_literal: true

require 'thor'

module TempestTime
  module Commands
    class Config < Thor
      namespace :config

      desc 'edit', 'Modify your jira/tempo authentication settings.'
      def auth(*)
        require_relative 'config/auth'
        TempestTime::Commands::Config::Auth.new(options).execute
      end

      desc 'app', 'Modify your app settings.'
      def app(*)
        require_relative 'config/app'
        TempestTime::Commands::Config::App.new(options).execute
      end
    end
  end
end
