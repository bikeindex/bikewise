custom_web: bundle exec unicorn_rails -c config/unicorn.rb -E $RAILS_ENV
hard_worker: bundle exec sidekiq -q importer -q parser -q carrierwave -q tasker -c 10