require 'test_helper'
require 'tempest_time/commands/issue'

class TempestTime::Commands::IssueTest < Minitest::Test
  def test_executes_issue_command_successfully
    output = StringIO.new
    options = {}
    command = TempestTime::Commands::Issue.new(options)

    command.execute(output: output)

    assert_equal "OK\n", output.string
  end
end
