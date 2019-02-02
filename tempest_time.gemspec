
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tempest_time/version'

Gem::Specification.new do |spec|
  spec.name          = 'tempest_time_time'
  spec.version       = TempestTime::VERSION
  spec.licenses      = ['MIT']

  spec.authors       = ['Devan Hurst']
  spec.email         = ['devan.hurst@gmail.com']

  spec.summary       = %q{Smart console-based Tempo time tracking!}
  spec.description   = %q{Log your Tempo hours directly from the command line!}
  spec.homepage      = 'https://github.com/devanhurst/tempest_time_time'

  spec.required_ruby_version = '~> 2.3'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.executables   = ['tempest_time']
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'byebug', '~> 10.0'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'rake', '~> 10.0'

  spec.add_dependency 'git', '~>1.5'
  spec.add_dependency 'httparty', '~>0.16'
  spec.add_dependency 'pastel', '~> 0.7.2'
  spec.add_dependency 'ruby-git', '~>0.2'
  spec.add_dependency 'thor', '~> 0.20.0'
  spec.add_dependency 'tty-box', '~> 0.3.0'
  spec.add_dependency 'tty-color', '~> 0.4'
  spec.add_dependency 'tty-command', '~> 0.8.0'
  spec.add_dependency 'tty-config', '~> 0.3.0'
  spec.add_dependency 'tty-cursor', '~> 0.6'
  spec.add_dependency 'tty-editor', '~> 0.5.0'
  spec.add_dependency 'tty-file', '~> 0.7.0'
  spec.add_dependency 'tty-font', '~> 0.2.0'
  spec.add_dependency 'tty-markdown', '~> 0.5.0'
  spec.add_dependency 'tty-pager', '~> 0.12.0'
  spec.add_dependency 'tty-pie', '~> 0.1.0'
  spec.add_dependency 'tty-platform', '~> 0.2.0'
  spec.add_dependency 'tty-progressbar', '~> 0.16.0'
  spec.add_dependency 'tty-prompt', '~> 0.18.0'
  spec.add_dependency 'tty-screen', '~> 0.6'
  spec.add_dependency 'tty-spinner', '~> 0.9.0'
  spec.add_dependency 'tty-table', '~> 0.10.0'
  spec.add_dependency 'tty-tree', '~> 0.2.0'
  spec.add_dependency 'tty-which', '~> 0.4'

end
