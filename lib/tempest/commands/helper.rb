module Tempest
  module Commands
    module Helper
      def self.included(thor)
        thor.class_eval do
          no_commands do
            def confirm(message, options = {})
              return if options['autoconfirm']
              response = ask(message)
              abort('Aborting.') unless %w[y yes].include?(response.downcase)
            end

            def track_time(time, options)
              puts "Tracking #{formatted_time(time)} to #{options['ticket']}!"

              options['remaining'] = if options['remaining'].nil?
                                       remaining_estimate(options['ticket'], time)
                                     else
                                       parsed_time(options['remaining'])
                                     end

              request = TempoAPI::Requests::CreateWorklog.new(time, options)
              request.send_request
              puts request.response_message
            end

            def delete_worklog(worklog)
              request = TempoAPI::Requests::DeleteWorklog.new(worklog)
              request.send_request
              puts request.response_message
            end

            def remaining_estimate(ticket, time)
              request = JiraAPI::Requests::GetIssue.new(ticket)
              request.send_request
              remaining = request.response.issue.remaining_estimate || 0
              remaining > time ? remaining - time : 0
            end

            def automatic_ticket
              ticket = /[A-Z]+-\d+/.match(Git.open(Dir.pwd).current_branch)
              abort('Ticket not found for this branch. Please specify.') unless ticket
              ticket.to_s
            end

            def billability(options)
              options['billable'] ? 'billed' : 'non-billed'
            end
          end
        end
      end
    end
  end
end