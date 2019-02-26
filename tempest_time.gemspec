lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tempest_time/version'

Gem::Specification.new do |spec|
  spec.name          = 'tempest_time'
  spec.version       = TempestTime::VERSION
  spec.licenses      = ['MIT']

  spec.authors       = ['Devan Hurst']
  spec.email         = ['devan.hurst@gmail.com']

  spec.summary       = %q(Smart CLI for Jira Cloud.)
  spec.description   = %q(Log time and more... directly from the command line!)
  spec.homepage      = 'https://github.com/devanhurst/tempest_time'

  spec.post_install_message = %q(
    Thank you for installing Tempest!

    If this is your first time installing, please run `tempest setup` to provide your Atlassian credentials.

    UPDATE: v1.2.0 makes changes to how reports are calculated!
    If you have been using this feature, please run `tempest config app` to set up your internal project codes.
  )

  spec.required_ruby_version = '~> 2.3'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.executables   = ['tempest']
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'byebug', '~> 10.0'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rubocop-airbnb', '~> 2.0'

  spec.add_dependency 'git', '~>1.5'
  spec.add_dependency 'httparty', '~>0.16'
  spec.add_dependency 'pastel', '~> 0.7.2'
  spec.add_dependency 'ruby-git', '~>0.2'
  spec.add_dependency 'thor', '~> 0.20.0'
  spec.add_dependency 'tty-command', '~> 0.8.0'
  spec.add_dependency 'tty-config', '~> 0.3.0'
  spec.add_dependency 'tty-prompt', '~> 0.18.0'
  spec.add_dependency 'tty-spinner', '~> 0.9.0'
  spec.add_dependency 'tty-table', '~> 0.10.0'
end
