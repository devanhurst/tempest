require 'test_helper'
require 'tempest_time/commands/config/auth'

class TempestTime::Commands::Config::AuthTest < Minitest::Test
  def test_executes_tempest_time_config_help_auth_command_successfully
    output = `tempest_time config help auth`
    expect_output = <<-OUT
Usage:
  tempest_time auth

Options:
  -h, [--help], [--no-help]  # Display usage information

Command description...
    OUT

    assert_equal expected_output, output
  end
end
