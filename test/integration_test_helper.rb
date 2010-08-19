require "test_helper"
require "capybara/rails"
require "selenium-webdriver"

module ActionController
  class IntegrationTest
    include Capybara
    self.fixture_path = "#{Rails.root}/test/fixtures/integration/"
    fixtures :all
  end
end

Capybara.default_driver = :selenium
Capybara.javascript_driver = :selenium
Capybara.default_wait_time = 5