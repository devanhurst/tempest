require 'test_helper'
require 'tempest_time/commands/report'

class TempestTime::Commands::ReportTest < Minitest::Test
  def test_executes_report_command_successfully
    output = StringIO.new
    options = {}
    command = TempestTime::Commands::Report.new(options)

    command.execute(output: output)

    assert_equal "OK\n", output.string
  end
end
