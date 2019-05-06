# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "api_tools/version"

Gem::Specification.new do |spec|
  spec.name          = "api_tools"
  spec.version       = ApiTools::VERSION
  spec.authors       = ["atpking"]
  spec.email         = ["atpking@gmail.com"]

  spec.summary       = 'rest 的常用请求'
  spec.description   = '简单点'
  spec.homepage      = "http://jicheng1014.cnblogs.com"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "webmock"

  spec.add_dependency 'multi_json'
  spec.add_dependency "rest-client", '~> 2.0'
end
