ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'database_cleaner'
require 'vcr'
require 'sidekiq/testing'


DatabaseCleaner.strategy = :truncation

VCR.configure do |c|
  c.ignore_request do |request|
    request.uri[/(\$zoom\$)/]
  end
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
end

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false

  config.before :suite do
    DatabaseCleaner.clean
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
