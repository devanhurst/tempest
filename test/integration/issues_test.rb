require 'test_helper'
require 'tempest_time/commands/issues'

class TempestTime::Commands::IssuesTest < Minitest::Test
  def test_executes_tempest_time_help_issues_command_successfully
    output = `tempest_time help issues`
    expected_output = <<-OUT
Usage:
  tempest_time issues

Options:
  -h, [--help], [--no-help]  # Display usage information

Command description...
    OUT

    assert_equal expected_output, output
  end
end
