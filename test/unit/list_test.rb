require 'test_helper'
require 'tempest_time/commands/list'

class TempestTime::Commands::ListTest < Minitest::Test
  def test_executes_list_command_successfully
    output = StringIO.new
    date = nil
    options = {}
    command = TempestTime::Commands::List.new(date, options)

    command.execute(output: output)

    assert_equal "OK\n", output.string
  end
end
