$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "active_record_better_dependent_error_messages/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "active_record_better_dependent_error_messages"
  s.version     = ActiveRecordBetterDependentErrorMessages::VERSION
  s.authors     = ["kaspernj"]
  s.email       = ["kaspernj@gmail.com"]
  s.homepage    = "https://github.com/kaspernj/active-record-better-dependent-error-messages"
  s.summary     = "A gem that makes better dependent error messages telling exactly which relationship tree failed with which ID's."
  s.description = "A gem that makes better dependent error messages telling exactly which relationship tree failed with which ID's."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", ">= 5.1.0"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "factory_bot_rails"
end
