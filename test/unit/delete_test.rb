require 'test_helper'
require 'tempest_time/commands/delete'

class TempestTime::Commands::DeleteTest < Minitest::Test
  def test_executes_delete_command_successfully
    output = StringIO.new
    options = {}
    command = TempestTime::Commands::Delete.new(options)

    command.execute(output: output)

    assert_equal "OK\n", output.string
  end
end
