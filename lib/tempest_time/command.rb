# frozen_string_literal: true

require 'tty-reader'
require 'forwardable'
require_relative 'helpers/time_helper'
require_relative 'helpers/formatting_helper'
require_relative 'helpers/git_helper'
require_relative 'api/jira_api/requests/get_current_user'
require_relative 'api/jira_api/requests/search_users'

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

    def date_prompt(message, days_before: 3, days_after: 3)
      require 'tty-prompt'
      dates = dates_in_range(days_before: days_before, days_after: days_after)
      TTY::Prompt.new.multi_select(
        message,
        dates,
        per_page: 5,
        default: dates.find_index { |k, v| v == Date.today } + 1
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

    def find_user(query)
      return current_user unless query

      users = JiraAPI::Requests::SearchUsers.new(query: query).send_request.users
      case users.count
      when 0
        abort(
          pastel.red('User not found!') + ' ' \
          'Please check your query and try again.'
        )
      when 1
        return users.first
      else
        require 'tty-prompt'
        TTY::Prompt.new.select(
          pastel.yellow('Multiple users match your query. Please select a user.'),
          users.map { |user| { "#{user.name}: #{user.email}" => user } },
          per_page: 10
        )
      end
    end

    def current_user
      @current_user ||= JiraAPI::Requests::GetCurrentUser.new.send_request.user
    end
  end
end
