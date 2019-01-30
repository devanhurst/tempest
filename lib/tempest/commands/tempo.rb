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
          LONGDESC
          def list(date=nil)
            request = TempoAPI::Requests::ListWorklogs.new(date)
            request.send_request
            puts "\nHere are your logs for #{request.formatted_date}:\n"
            puts request.response_message
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

          map 't' => 'track'
          map 'log' => 'track'
          map 'l' => 'list'
          map 'd' => 'delete'
        end
      end
    end
  end
end