require 'test_helper'
require 'tempest_time/commands/view'

class TempestTime::Commands::ViewTest < Minitest::Test
  def test_executes_view_command_successfully
    output = StringIO.new
    options = {}
    command = TempestTime::Commands::View.new(options)

    command.execute(output: output)

    assert_equal "OK\n", output.string
  end
end
