# frozen_string_literal: true

require 'thor'

module TempestTime
  module Commands
    class Timer < Thor

      namespace :timer

      desc 'start [ISSUE]', 'Start a new timer, or continue a paused timer.'
      def start(issue = nil)
        require_relative 'timer/start'
        TempestTime::Commands::Timer::Start.new(issue).execute
      end

      desc 'pause [ISSUE]', 'Pause a timer.'
      def pause(issue = nil)
        require_relative 'timer/pause'
        TempestTime::Commands::Timer::Pause.new(issue).execute
      end

      desc 'track [ISSUE]', 'Stop and track a timer.'
      def track(issue = nil)
        require_relative 'timer/track'
        TempestTime::Commands::Timer::Track.new(issue).execute
      end

      desc 'delete [ISSUE]', 'Delete current timer.'
      def delete(issue = nil)
        require_relative 'timer/delete'
        TempestTime::Commands::Timer::Delete.new(issue).execute
      end

      desc 'status [ISSUE]', 'Display timer status.'
      def status(issue = nil)
        require_relative 'timer/status'
        TempestTime::Commands::Timer::Status.new(issue).execute
      end

      desc 'list', 'Display all timers.'
      def list
        require_relative 'timer/list'
        TempestTime::Commands::Timer::List.new.execute
      end
    end
  end
end
