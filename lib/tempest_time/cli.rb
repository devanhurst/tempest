require 'thor'
require 'git'

module TempestTime
  class CLI < Thor
    # Error raised by this runner
    Error = Class.new(StandardError)

    desc 'version', 'Show version number.'
    def version
      require_relative 'version'
      puts "v#{TempestTime::VERSION}"
    end
    map %w(--version -v) => :version

    require_relative 'commands/config'
    register TempestTime::Commands::Config,
             'config', 'config [SUBCOMMAND]',
             'Setup or modify user settings.'

    require_relative 'commands/teams'
    register TempestTime::Commands::Teams,
             'teams', 'teams [SUBCOMMAND]',
             'Add or modify teams.'

    desc 'list', 'List worklogs for a specific date.'
    option :user, aliases: '-u', type: :string
    def list
      require_relative 'commands/list'
      TempestTime::Commands::List.new(options).execute
    end


    desc 'submit', 'Submit your timesheet to a supervisor.'
    def submit(*)
      require_relative 'commands/submit'
      TempestTime::Commands::Submit.new(options).execute
    end

    desc 'report', 'Generate a user or team report.'
    option :week, aliases: '-w', type: :numeric
    option :team, aliases: '-t', type: :string
    def report(*users)
      require_relative 'commands/report'
      TempestTime::Commands::Report.new(users, options).execute
    end

    desc 'delete [WORKLOG(S)]', 'Delete worklogs.'
    long_desc <<-LONGDESC
      `tempest_time delete` will delete the specified worklogs.\n
      e.g. `tempest delete 12345`\n
      e.g. `tempest delete 12345 12346 12347`\n
    LONGDESC
    option :autoconfirm, type: :boolean
    def delete(*worklogs)
      require_relative 'commands/delete'
      TempestTime::Commands::Delete.new(worklogs, options).execute
    end

    desc 'issues', "View a list of a user's assigned tickets. (Defaults to you.)"
    def issues(user = nil)
      require_relative 'commands/issues'
      TempestTime::Commands::Issues.new(user, options).execute
    end

    desc "track [TIME] [TICKET(S)]", 'Track time to Tempo.'
    long_desc <<-LONGDESC
            `tempest track` or `tempest log` will track the specified number of hours or minutes to the ticket(s) specified.\n
            If not specified, it will check the name of the current git branch and automatically track the logged time to that ticket, if found.\n
            You can also split a bank of time evenly across multiple tickets with the --split flag.\n
            e.g. tempest track 1.5h BCIT-1 --message='Tracking 1.5 hours.'\n
            e.g. tempest log 90m BCIT-1 BCIT-2 --message='Tracking 90 minutes.'\n
            e.g. tempest track 3h BCIT-1 BCIT-2 BCIT-3 --message='Tracking 1 hour.'\n
    LONGDESC
    option :message, aliases: '-m', type: :string
    option :date, aliases: '-d', type: :string
    option :remaining, aliases: '-r', type: :string
    option :billable, aliases: '-b', type: :boolean, default: true
    option :split, aliases: '-s', type: :boolean, default: false
    option :autoconfirm, type: :boolean, default: false
    def track(time, *tickets)
      require_relative 'commands/track'
      TempestTime::Commands::Track.new(time, tickets, options).execute
    end
  end
end