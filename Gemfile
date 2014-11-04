source 'https://rubygems.org'

gem 'rails', '4.1.7'
gem 'pg'

gem 'sass-rails', '~> 4.0.3'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'

# Use jquery as the JavaScript library
gem 'jquery-rails'

# gem 'oj'
# gem 'oj_mimic_json'

# bundle exec rake doc:rails generates the API under doc/api.
# gem 'sdoc', '~> 0.4.0',          group: :doc

# deployment just to get rid of the deprecation warning. Won't be necessary after https://github.com/bkeepers/dotenv/pull/120 is merged
gem 'dotenv-deployment'
gem 'dotenv-rails'
gem 'active_model_serializers'
gem 'geocoder'

gem 'honeybadger'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

gem 'unicorn'
gem 'rack-cors', :require => 'rack/cors'
gem 'dalli'

gem 'sinatra', '>= 1.3.0', :require => nil
gem 'sidekiq'
gem 'sidekiq-failures'
gem 'sidekiq-unique-jobs'
gem 'pg_search'

gem 'kaminari'

gem 'bootstrap-sass', '~> 3.1.1'
gem 'haml'

gem 'httparty'

group :development, :test do
  gem 'foreman'
  gem 'rerun'
  gem 'vcr'
  gem 'rspec-rails', '~> 2.14.1'
  gem 'factory_girl_rails'
  gem 'shoulda-matchers'
  gem 'pry'
  gem 'growl'
  gem 'guard'
  gem 'guard-rspec', '4.2.8'
  gem 'guard-livereload'
  gem 'database_cleaner'
end

group :test do
  gem 'webmock'
end
