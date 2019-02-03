require 'test_helper'
require 'tempest_time/commands/config'

class TempestTime::Commands::ConfigTest < Minitest::Test
  def test_executes_tempest_time_help_config_command_successfully
    output = `tempest_time help config`
    expected_output = <<-OUT
Usage:
  tempest_time config

Options:
  -h, [--help], [--no-help]  # Display usage information

Command description...
    OUT

    assert_equal expected_output, output
  end
end
