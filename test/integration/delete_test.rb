require 'test_helper'
require 'tempest_time/commands/delete'

class TempestTime::Commands::DeleteTest < Minitest::Test
  def test_executes_tempest_time_help_delete_command_successfully
    output = `tempest_time help delete`
    expected_output = <<-OUT
Usage:
  tempest_time delete

Options:
  -h, [--help], [--no-help]  # Display usage information

Command description...
    OUT

    assert_equal expected_output, output
  end
end
