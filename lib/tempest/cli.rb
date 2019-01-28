module Tempest
  class CLI < Thor
    no_commands do
      def confirm(message)
        response = ask(message, limited_to: %w[y n])
        abort('Aborting.') unless %w[y yes].include?(response.downcase)
      end
    end
  end
end