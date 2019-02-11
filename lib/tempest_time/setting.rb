require 'tty-config'

module TempestTime
  class Setting
    attr_reader :config

    def initialize
      @config = TTY::Config.new
      config.extname = '.yml'
      config.append_path(directory)
      Dir.mkdir(directory) unless File.exists?(directory)
    end

    def keys
      read_config { config.to_h.keys }
    end

    def fetch(key)
      read_config { config.fetch(key) }
    end

    def delete(key)
      write_config { config.delete(key) }
    end

    def set(key, value)
      write_config { config.set(key, value: value) }
    end

    def remove(key, value)
      write_config { config.remove(value, from: key) }
    end

    def append(key, value)
      write_config { config.append(value, to: key) }
    end

    private

    def directory
      Dir.home + '/.tempest'
    end

    def read_config
      config.read
      yield
    end

    def write_config
      config.read if config.exist?
      yield
      config.write(force: true)
    end
  end
end