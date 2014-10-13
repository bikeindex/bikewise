if ENV['HONEYBADGER_KEY'].present?
  Honeybadger.configure do |config|
    config.api_key = ENV['HONEYBADGER_KEY']
  end
end
