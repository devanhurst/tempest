require 'test_helper'
require 'tempest_time/commands/config/auth'

class TempestTime::Commands::Config::AuthTest < Minitest::Test
  def test_executes_config_auth_command_successfully
    output = StringIO.new
    options = {}
    command = TempestTime::Commands::Config::Auth.new(options)

    command.execute(output: output)

    assert_equal "OK\n", output.string
  end
end
