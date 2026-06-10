RSpec.configure do |config|
    config.before(:suite) { DatabaseCleaner.clean_with(:truncation) }
    config.before { DatabaseCleaner.strategy = :transaction }
    config.before(:each, js: true) { DatabaseCleaner.strategy = :truncation }
    config.before { DatabaseCleaner.start }
    config.after  { DatabaseCleaner.clean }
  end