# frozen_string_literal: true

require 'thor'

module TempestTime
  module Commands
    class Timer < Thor

      namespace :timer

      desc 'start', 'Start a new timer, or continue a paused timer.'
      def start(*)
        require_relative 'timer/start'
        TempestTime::Commands::Timer::Start.new.execute
      end

      desc 'stop', 'Stop current timer.'
      def stop(*)
        require_relative 'timer/stop'
        TempestTime::Commands::Timer::Stop.new.execute
      end

      desc 'submit', 'Submit current timer.'
      def submit(*)
        require_relative 'timer/submit'
        TempestTime::Commands::Timer::Submit.new.execute
      end

      desc 'delete', 'Delete current timer.'
      def delete(*)
        require_relative 'timer/delete'
        TempestTime::Commands::Timer::Delete.new.execute
      end

      desc 'status', 'Current timer status.'
      def status(*)
        require_relative 'timer/status'
        TempestTime::Commands::Timer::Status.new.execute
      end
    end
  end
end
