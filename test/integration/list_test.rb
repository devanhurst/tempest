require 'test_helper'
require 'tempest_time/commands/list'

class TempestTime::Commands::ListTest < Minitest::Test
  def test_executes_tempest_time_help_list_command_successfully
    output = `tempest_time help list`
    expected_output = <<-OUT
Usage:
  tempest_time list DATE

Options:
  -h, [--help], [--no-help]  # Display usage information

Command description...
    OUT

    assert_equal expected_output, output
  end
end
