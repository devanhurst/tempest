require 'test_helper'
require 'tempest_time/commands/config'

class TempestTime::Commands::ConfigTest < Minitest::Test
  def test_executes_config_command_successfully
    output = StringIO.new
    options = {}
    command = TempestTime::Commands::Config.new(options)

    command.execute(output: output)

    assert_equal "OK\n", output.string
  end
end
