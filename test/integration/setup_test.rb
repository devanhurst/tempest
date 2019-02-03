require 'test_helper'
require 'tempest_time/commands/setup'

class TempestTime::Commands::SetupTest < Minitest::Test
  def test_executes_tempest_time_help_setup_command_successfully
    output = `tempest_time help setup`
    expected_output = <<-OUT
Usage:
  tempest_time setup

Options:
  -h, [--help], [--no-help]  # Display usage information

Command description...
    OUT

    assert_equal expected_output, output
  end
end
