require 'test_helper'
require 'tempest_time/commands/submit'

class TempestTime::Commands::SubmitTest < Minitest::Test
  def test_executes_submit_command_successfully
    output = StringIO.new
    options = {}
    command = TempestTime::Commands::Submit.new(options)

    command.execute(output: output)

    assert_equal "OK\n", output.string
  end
end
