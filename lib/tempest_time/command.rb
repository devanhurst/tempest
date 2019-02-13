# frozen_string_literal: true

require 'tty-reader'
require 'forwardable'
require_relative 'helpers/time_helper'
require_relative 'helpers/formatting_helper'
require_relative 'helpers/git_helper'

module TempestTime
  class Command
    extend Forwardable
    include TempestTime::Helpers::TimeHelper
    include TempestTime::Helpers::FormattingHelper
    include TempestTime::Helpers::GitHelper

    def_delegators :command, :run

    def execute(*)
      execute!
    rescue TTY::Reader::InputInterrupt
      prompt.say(pastel.yellow("\nGoodbye!"))
    end

    def execute!(*)
      raise(
        NotImplementedError,
        "#{self.class}##{__method__} must be implemented"
      )
    end

    def command
      require 'tty-command'
      TTY::Command.new
    end

    def pastel(**options)
      require 'pastel'
      Pastel.new(options)
    end

    def prompt(**options)
      require 'tty-prompt'
      TTY::Prompt.new(options)
    end

    def week_prompt(message, past_weeks: 51)
      require 'tty-prompt'
      weeks = past_week_selections(past_weeks)
      TTY::Prompt.new.select(
        message,
        weeks,
        per_page: 5
      )
    end

    def date_prompt(message, past_days: 6)
      require 'tty-prompt'
      dates = past_date_selections(past_days)
      TTY::Prompt.new.select(
        message,
        dates,
        per_page: 5
      )
    end

    def spinner
      require 'tty-spinner'
      TTY::Spinner
    end

    def table
      require 'tty-table'
      TTY::Table
    end

    def with_spinner(message, format: :pong)
      s = spinner.new(":spinner #{message}", format: format)
      s.auto_spin
      yield(s)
    end

    def with_success_fail_spinner(message, format: :spin_3)
      s = spinner.new(":spinner #{message}", format: format)
      s.auto_spin
      response = yield
      if response.success?
        s.success(pastel.green(response.message))
      else
        s.error(pastel.red(response.message))
      end
    end
  end
end
