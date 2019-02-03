require 'test_helper'
require 'tempest_time/commands/report'

class TempestTime::Commands::ReportTest < Minitest::Test
  def test_executes_tempest_time_help_report_command_successfully
    output = `tempest_time help report`
    expected_output = <<-OUT
Usage:
  tempest_time report

Options:
  -h, [--help], [--no-help]  # Display usage information

Command description...
    OUT

    assert_equal expected_output, output
  end
end
