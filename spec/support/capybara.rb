require "capybara/rspec"

Capybara.default_max_wait_time = 5

RSpec.configure do |config|
  config.before(:each, type: :system) do |example|
    if example.metadata[:js]
      driven_by :selenium, using: :headless_chrome, screen_size: [ 1400, 900 ]
    else
      driven_by :rack_test
    end
  end
end
