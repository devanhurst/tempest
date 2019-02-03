# frozen_string_literal: true

require 'thor'

module TempestTime
  module Commands
    class Teams < Thor

      namespace :config

      desc 'add', 'Add a team.'
      def add(*)
        require_relative 'teams/add'
        TempestTime::Commands::Teams::Add.new(options).execute
      end

      desc 'edit', 'Edit a team.'
      def edit(*)
        require_relative 'teams/edit'
        TempestTime::Commands::Teams::Edit.new(options).execute
      end

      desc 'delete', 'Edit a team.'
      def delete(*)
        require_relative 'teams/delete'
        TempestTime::Commands::Teams::Delete.new(options).execute
      end
    end
  end
end
