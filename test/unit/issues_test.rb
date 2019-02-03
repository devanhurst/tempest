require 'test_helper'
require 'tempest_time/commands/issues'

class TempestTime::Commands::IssuesTest < Minitest::Test
  def test_executes_issues_command_successfully
    output = StringIO.new
    options = {}
    command = TempestTime::Commands::Issues.new(options)

    command.execute(output: output)

    assert_equal "OK\n", output.string
  end
end
