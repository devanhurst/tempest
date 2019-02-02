module Tempest
  module Commands
    module Tempo
      def self.included(thor)
        thor.class_eval do
          include Tempest::Helpers::TimeHelper

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
            time = options[:split] ? parsed_time(time) / tickets.count : parsed_time(time)
            tickets = tickets.any? ? tickets.map(&:upcase) : [automatic_ticket]
            confirm("Track #{formatted_time(time)}, #{billability(options)}, to #{tickets.join(', ')}?", options)
            tickets.each { |ticket| track_time(parsed_time(time), options.merge(ticket: ticket)) }
          end

          desc 'list [DATE]', 'List worklogs for given date. (Defaults to today.)'
          long_desc <<-LONGDESC
            `tempest list` will list a day's worklogs.\n
            e.g. `tempest list today`\n
            e.g. `tempest list yesterday`\n
            e.g. `tempest list 2019-01-31`\n
            e.g. `tempest list 2019-01-31 --user=jsmith`
          LONGDESC
          option :user, type: :string
          option :end_date, type: :string
          def list(date_input = nil)
            dates = parsed_date_input(date_input)
            dates.each do |start_date|
              request = TempoAPI::Requests::ListWorklogs.new(start_date, options['end_date'], options[:user])
              request.send_request
              puts "\nHere are your logs for #{formatted_date_range(start_date, options['end_date'])}:\n"
              puts request.response_message
            end
          end

          desc 'delete [WORKLOG(S)]', 'Delete worklogs.'
          long_desc <<-LONGDESC
            `tempest delete` will delete the specified worklogs.\n
            e.g. `tempest delete 12345`\n
            e.g. `tempest delete 12345 12346 12347`\n
          LONGDESC
          option :autoconfirm, type: :boolean
          def delete(*worklogs)
            confirm("Delete worklog(s) #{worklogs.join(', ')}?", options)
            worklogs.each { |worklog| delete_worklog(worklog) }
          end

          desc 'submit', 'Submit your timesheet!'
          def submit
            reviewer = ask('Who should review this timesheet? (username)')
            confirm("Submit this week's timesheet to #{reviewer}?")
            confirm('Are you sure? Your timesheet cannot be edited once submitted!')
            puts "Submitting this week's timesheet..."
            request = TempoAPI::Requests::SubmitTimesheet.new(reviewer)
            request.send_request
            puts request.response_message
          end

          desc 'view', 'View specific worklogs.'
          def view(*worklogs)
            worklogs.each { |worklog| get_worklog(worklog) }
          end

          desc 'report', 'Report'
          option :week, aliases: '-w', type: :numeric
          option :team, aliases: '-t', type: :string
          def report(*users)
            team = options[:team]
            users.push(Tempest::Settings::Teams.members(team)) if team
            abort('No users specified.') unless users.any?
            report = Tempest::Services::GenerateReport.new(users.flatten, options[:week])
            puts report.to_s
          end

          map 'd' => 'delete'
          map 'l' => 'list'
          map 'log' => 'track'
          map 'r' => 'report'
          map 't' => 'track'
          map 's' => 'submit'
        end
      end
    end
  end
end