require 'test_helper'
require 'tempest_time/commands/issue'

class TempestTime::Commands::IssueTest < Minitest::Test
  def test_executes_tempest_time_help_issue_command_successfully
    output = `tempest_time help issue`
    expected_output = <<-OUT
Usage:
  tempest_time issue

Options:
  -h, [--help], [--no-help]  # Display usage information

Command description...
    OUT

    assert_equal expected_output, output
  end
end
