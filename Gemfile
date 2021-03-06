source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.5.5"

gem "rails", "~> 4.2.11"
gem "pg", "~> 0.18" # Postgres
gem "pg_search", "~> 1.0" # Full text search - e.g. admin_search in user
gem "rake", "< 12.0"

gem "sass-rails", "~> 4.0.3"
gem "uglifier", ">= 1.3.0"
gem "coffee-rails", "~> 4.0.0"

# Use jquery as the JavaScript library
gem "jquery-rails"

# gem 'oj'
# gem 'oj_mimic_json'

# bundle exec rake doc:rails generates the API under doc/api.
# gem 'sdoc', '~> 0.4.0',          group: :doc

# deployment just to get rid of the deprecation warning. Won't be necessary after https://github.com/bkeepers/dotenv/pull/120 is merged
gem "dotenv-deployment"
gem "dotenv-rails"
gem "active_model_serializers", "~> 0.9.0"
gem "geocoder"

group :production do
  gem "honeybadger"
end

gem "devise"
gem "devise-bootstrap-views"
gem "omniauth-bike-index"

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

gem "unicorn"
gem "rack-cors", :require => "rack/cors"
gem "dalli"

gem "sinatra", ">= 1.3.0", :require => nil
gem "sidekiq", "~> 4.0"
gem "sidekiq-failures"
gem "sidekiq-unique-jobs"

gem "kaminari"
gem "grape", "~> 1.1.0"
gem "grape-active_model_serializers", "~> 1.4.0"
gem "grape-swagger", "0.11"
gem "api-pagination"
gem "swagger-ui_rails"

gem "bootstrap-sass", "~> 3.1.1"
gem "haml"

gem "httparty"

gem "kramdown"
gem "kramdown-parser-gfm" # Parser required to render grape-swagger

gem "carrierwave", "~> 0.11.0"
gem "carrierwave_backgrounder"
gem "mini_magick"
gem "fog-aws", "~> 3.5.2"
gem "nokogiri"

# Logging
gem "grape_logging" # Grape logging. Also how we pass it to lograge. Always used, not just in Prod
gem "lograge" # Structure log data, put it in single lines to improve the functionality
gem "logstash-event" # Use logstash format for logging data

group :development, :test do
  gem "foreman"
  gem "rerun"
  gem "vcr"
  gem "rspec-rails", "~> 2.14.1"
  gem "factory_bot_rails"
  gem "pry"
  gem "growl"
  gem "guard"
  gem "guard-rspec", "4.2.8"
  gem "guard-livereload"
  gem "database_cleaner"
  gem "json_spec"
  gem "rspec_junit_formatter" # For circle ci
end

group :test do
  gem "codeclimate-test-reporter", require: nil
  gem "webmock"
end
