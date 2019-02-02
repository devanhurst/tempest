require 'test_helper'
require 'tempest_time_time/commands/config'

class TempestTimeTime::Commands::ConfigTest < Minitest::Test
  def test_executes_config_command_successfully
    output = StringIO.new
    options = {}
    command = TempestTimeTime::Commands::Config.new(options)

    command.execute(output: output)

    assert_equal "OK\n", output.string
  end
end
