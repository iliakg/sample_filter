$:.push File.expand_path("../lib", __FILE__)

require "sample_filter/version"

Gem::Specification.new do |s|
  s.name        = "sample_filter"
  s.version     = SampleFilter::VERSION
  s.authors     = ["ilia"]
  s.email       = ["piryazevilia@gmail.com"]
  s.homepage    = "https://github.com/iliakg/sample_filter"
  s.summary     = "Engine plugin that makes to filter"
  s.description = "SampleFilter is a Rails Engine plugin that makes to filter and sort ActiveRecord lists"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_development_dependency "rails"
  s.add_development_dependency "pg"
  s.add_development_dependency "rspec"
  s.add_development_dependency "database_cleaner"
  s.add_development_dependency "pry"

  s.test_files = Dir["spec/**/*"]
end
