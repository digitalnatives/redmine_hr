require './app'
require './lib/holiday_calculator'
require './lib/hun_2014'
require 'capybara/cucumber'
require 'capybara/poltergeist'
require 'database_cleaner/cucumber'

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, phantomjs_logger: Logger.new('/dev/null'))
end

Capybara.default_driver = :poltergeist
Capybara.default_wait_time = 10
Capybara.app = RedmineApp::Application

ActiveRecord::Base.logger.level = Logger::Severity::UNKNOWN

Rails.logger = Logger.new('./log/test.log')

DatabaseCleaner.strategy = :truncation

Around do |scenario, block|
  DatabaseCleaner.cleaning(&block)
end

def select_option(field,value)
  page.execute_script """
    var select = document.querySelector(\"[name='#{field}']\");
    select.value = '#{value}';
    event = document.createEvent(\"HTMLEvents\");
    event.initEvent(\"change\", true, true);
    select.dispatchEvent(event);
  """
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
