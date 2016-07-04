# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'active_use_case/version'

Gem::Specification.new do |s|
  s.name        = 'active_use_case'
  s.version     = ActiveUseCase::VERSION::STRING
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Nicolas Rodriguez']
  s.email       = ['nrodriguez@jbox-web.com']
  s.homepage    = 'https://github.com/jbox-web/active_use_case'
  s.summary     = %q{A Ruby gem to ease creation of ActiveUseCase objects}
  s.description = %q{This gem is designed to provide helpers for ActiveUseCase objects}
  s.license     = 'MIT'

  s.add_dependency 'railties', '>= 4.1.0', '< 5.1'

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rspec-rails'

  s.add_development_dependency 'guard'
  s.add_development_dependency 'guard-rspec'

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'factory_girl'
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency 'database_cleaner'

  s.add_development_dependency 'awesome_print'
  s.add_development_dependency 'pry'

  s.add_development_dependency 'simplecov'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
