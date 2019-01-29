
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "tempest/version"

Gem::Specification.new do |spec|
  spec.name          = "tempest-time"
  spec.version       = Tempest::VERSION
  spec.licenses      = ['MIT']

  spec.authors       = ["Devan Hurst"]
  spec.email         = ["devan.hurst@gmail.com"]

  spec.summary       = %q{Smart console-based Tempo time tracking!}
  spec.description   = %q{Log your Tempo hours directly from the command line!}
  spec.homepage      = "https://github.com/devanhurst/tempest-time"

  spec.required_ruby_version = '~> 2.3'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.executables   = ["tempest"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "byebug", "~> 10.0"

  spec.add_dependency "thor", "~>0.20"
  spec.add_dependency "httparty", "~>0.16"
  spec.add_dependency "git", "~>1.5"
  spec.add_dependency "ruby-git", "~>0.2"
end
