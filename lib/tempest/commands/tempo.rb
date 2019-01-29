module Tempest
  module Commands
    module Tempo
      def self.included(thor)
        thor.class_eval do
          include Tempest::Helpers::TimeHelper

          desc "track [TIME]", 'Track time to Tempo.'
          long_desc <<-LONGDESC
            `tempest track [time]` will track the specified number of hours or minutes to the ticket specified.\n
            If not specified, it will check the name of the current git branch and automatically
            put the logged time in that ticket, if found.\n
            e.g. tempest track 1.5h --ticket='BCIT-2' --message='Tracking 1.5 hours!'
            e.g. tempest track 90m --ticket='BCIT-2' --message='Tracking time in minutes this time.'
          LONGDESC
          option :message, aliases: '-m', type: :string
          option :date, aliases: '-d', type: :string
          option :remaining, aliases: '-r', type: :string
          option :billable, aliases: '-b', type: :boolean, default: true
          option :split, aliases: '-s', type: :boolean, default: false
          option :autoconfirm, type: :boolean, default: false
          def track(time, *tickets)
            time = options[:split] ? parsed_time(time) / tickets.count : parsed_time(time)
            tickets = tickets.map(&:upcase)
            confirm("Track #{formatted_time(time)}, #{billability(options)}, to #{tickets.join(', ')}?", options)
            tickets.each { |ticket| track_time(parsed_time(time), options.merge(ticket: ticket)) }
          end

          desc 'list [DATE]', "List worklogs for given date."
          def list(date=nil)
            request = TempoAPI::Requests::ListWorklogs.new(date)
            request.send_request
            puts "\nHere are your logs for #{request.formatted_date}:\n"
            puts request.response_message
          end

          desc 'delete', 'Delete worklog with IDS [WORKLOG_ID]'
          option :worklogs, aliases: '-w', required: true, type: :array
          option :autoconfirm, type: :boolean
          def delete
            worklogs = options['worklogs']
            confirm("Delete worklog(s) #{worklogs.join(', ')}?", options)
            worklogs.each { |worklog| delete_worklog(worklog)}
          end

          map 't' => 'track'
          map 'l' => 'list'
          map 'd' => 'delete'
        end
      end
    end
  end
end