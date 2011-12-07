# coding: UTF-8
lib = File.expand_path('../lib', __FILE__)
$:.unshift lib unless $:.include?(lib)

require "api_strut_wrapper/version"

Gem::Specification.new do |s|
  s.name        = "api_strut_wrapper"
  s.version     = ApiStrutWrapper::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["kanechika7"]
  s.email       = ["kanechika7@gmail.com"]
  s.homepage    = %q{http://github.com/#{github_username}/#{project_name}}
  s.summary     = "strut wrapper for api"
  s.description = "strut wrapper for api"

  s.required_rubygems_version = ">= 1.3.6"
  s.add_dependency("rails",[">= 3.0.0"])
  s.add_dependency("strut",[":git => 'https://github.com/kuruma-gs/strut.git'"])

  s.files        = Dir.glob("lib/**/*") + %W(README.rdoc Rakefile)
  s.require_path = 'lib'
end
