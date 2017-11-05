$:.push File.expand_path("../lib", __FILE__)

require "sample_filter/version"

Gem::Specification.new do |s|
  s.name        = "sample_filter"
  s.version     = SampleFilter::VERSION
  s.authors     = ["ilia"]
  s.email       = ["piryazevilia@gmail.com"]
  s.homepage    = "https://github.com/iliakg/sample_filter"
  s.summary     = "sample filter for filtering"
  s.description = "simple filtering"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  s.add_dependency "rails", "~> 5.1"
  s.test_files = Dir["spec/**/*"]
end
