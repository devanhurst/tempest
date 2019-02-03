require 'test_helper'
require 'tempest_time/commands/track'

class TempestTime::Commands::TrackTest < Minitest::Test
  def test_executes_track_command_successfully
    output = StringIO.new
    options = {}
    command = TempestTime::Commands::Track.new(options)

    command.execute(output: output)

    assert_equal "OK\n", output.string
  end
end
