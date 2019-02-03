require 'test_helper'
require 'tempest_time/commands/submit'

class TempestTime::Commands::SubmitTest < Minitest::Test
  def test_executes_tempest_time_help_submit_command_successfully
    output = `tempest_time help submit`
    expected_output = <<-OUT
Usage:
  tempest_time submit

Options:
  -h, [--help], [--no-help]  # Display usage information

Command description...
    OUT

    assert_equal expected_output, output
  end
end
