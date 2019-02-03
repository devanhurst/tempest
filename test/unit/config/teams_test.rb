require 'test_helper'
require 'tempest_time/commands/config/teams'

class TempestTime::Commands::Config::TeamsTest < Minitest::Test
  def test_executes_config_teams_command_successfully
    output = StringIO.new
    options = {}
    command = TempestTime::Commands::Config::Teams.new(options)

    command.execute(output: output)

    assert_equal "OK\n", output.string
  end
end
