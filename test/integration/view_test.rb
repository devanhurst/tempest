require 'test_helper'
require 'tempest_time/commands/view'

class TempestTime::Commands::ViewTest < Minitest::Test
  def test_executes_tempest_time_help_view_command_successfully
    output = `tempest_time help view`
    expected_output = <<-OUT
Usage:
  tempest_time view

Options:
  -h, [--help], [--no-help]  # Display usage information

Command description...
    OUT

    assert_equal expected_output, output
  end
end
