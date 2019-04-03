# frozen_string_literal: true

require 'thor'

module TempestTime
  module Commands
    class Issue < Thor
      namespace :issue

      desc 'list', 'List unresolved issues.'
      option :user, aliases: '-u', type: :string
      def list
        require_relative 'issue/list'
        TempestTime::Commands::Issue::List.new(options).execute
      end

      desc 'open', 'Open an issue in your browser. (Default: current branch)'
      def open(*issues)
        require_relative 'issue/open'
        TempestTime::Commands::Issue::Open.new(issues).execute
      end
    end
  end
end
