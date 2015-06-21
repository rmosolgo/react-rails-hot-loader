# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hot_loader/version'

Gem::Specification.new do |spec|
  spec.name          = "react-rails-hot-loader"
  spec.version       = React::Rails::HotLoader::VERSION
  spec.authors       = ["Robert Mosolgo"]
  spec.email         = ["rdmosolgo@gmail.com"]

  spec.summary       = %q{Live-reload React.js components with Ruby on Rails}
  spec.description   = %q{Tie into the `react-rails` gem to notify the client of changed files & reload assets on the client when they are changed.}
  spec.homepage      = "http://github.com/rmosolgo/react-rails-hot-loader"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.1.0'

  spec.add_runtime_dependency "em-websocket"
  spec.add_runtime_dependency "react-rails"
  spec.add_runtime_dependency "rails"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-bundler"
  spec.add_development_dependency "guard-minitest"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "websocket-client-simple"
end
