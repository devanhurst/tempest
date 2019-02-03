require 'test_helper'
require 'tempest_time/commands/teams'

class TempestTime::Commands::TeamsTest < Minitest::Test
  def test_executes_teams_command_successfully
    output = StringIO.new
    options = {}
    command = TempestTime::Commands::Teams.new(options)

    command.execute(output: output)

    assert_equal "OK\n", output.string
  end
end
