require 'test_helper'
require 'tempest_time/commands/track'

class TempestTime::Commands::TrackTest < Minitest::Test
  def test_executes_tempest_time_help_track_command_successfully
    output = `tempest_time help track`
    expected_output = <<-OUT
Usage:
  tempest_time track

Options:
  -h, [--help], [--no-help]  # Display usage information

Command description...
    OUT

    assert_equal expected_output, output
  end
end
