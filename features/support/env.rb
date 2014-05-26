require './app'
require 'capybara/cucumber'
require 'capybara/poltergeist'
require 'database_cleaner/cucumber'

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, phantomjs_logger: Logger.new('/dev/null'))
end

Capybara.default_driver = :poltergeist
Capybara.app = RedmineApp::Application

ActiveRecord::Base.logger.level = Logger::Severity::UNKNOWN

Rails.logger = Logger.new('./log/test.log')

DatabaseCleaner.strategy = :truncation

Around do |scenario, block|
  DatabaseCleaner.cleaning(&block)
end

def wait_until(&block)
  Timeout.timeout(Capybara.default_wait_time) do
    active = block.call
    until active
      active = block.call
    end
  end
end

def wait_for_hash(hash)
	wait_until do
    uri = URI.parse(current_url)
    uri.fragment == hash
  end
end
