require './app'
require 'capybara/cucumber'
require 'capybara/poltergeist'

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, phantomjs_logger: Logger.new('/dev/null'))
end

Capybara.default_driver = :poltergeist
Capybara.app = RedmineApp::Application

ActiveRecord::Base.logger.level = Logger::Severity::UNKNOWN

Rails.logger = Logger.new('./log/test.log')

DatabaseCleaner.strategy = :truncation
