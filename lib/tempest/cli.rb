module Tempest
  class CLI < Thor
    no_commands do
      def confirm(message)
        response = ask(message)
        abort('Aborting.') unless %w[y yes].include?(response.downcase)
      end
    end
  end
end