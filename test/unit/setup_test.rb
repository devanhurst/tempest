require 'test_helper'
require 'tempest_time/commands/setup'

class TempestTime::Commands::SetupTest < Minitest::Test
  def test_executes_setup_command_successfully
    output = StringIO.new
    options = {}
    command = TempestTime::Commands::Setup.new(options)

    command.execute(output: output)

    assert_equal "OK\n", output.string
  end
end
