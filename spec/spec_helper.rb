ENV['RAILS_ENV'] ||= 'test'

require "sprockets/railtie"
require 'rspec'
require 'database_cleaner'
require 'pry'
require "sample_filter"

ENGINE_RAILS_ROOT=File.join(File.dirname(__FILE__), '../')
Dir[File.join(ENGINE_RAILS_ROOT, 'spec/support/**/*.rb')].each {|f| require f }

Time.zone = 'UTC'
