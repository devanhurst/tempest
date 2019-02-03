# frozen_string_literal: true

require 'forwardable'

module TempestTime
  class Command
    extend Forwardable

    def_delegators :command, :run

    def execute(*)
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

    def spinner
      require 'tty-spinner'
      TTY::Spinner
    end

    def table
      require 'tty-table'
      TTY::Table
    end

    def with_spinner(message, format = :pong)
      s = spinner.new(":spinner #{message}", format: format)
      s.auto_spin
      yield(s)
    end

    def with_success_fail_spinner(message, format = :spin_3)
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
