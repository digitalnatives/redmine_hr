require './app'
Rails.logger = Logger.new(STDOUT)
run RedmineApp::Application
