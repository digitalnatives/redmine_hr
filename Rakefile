require 'rubygems'
require 'bundler'
Bundler.setup(:default)
require 'opal/haml'
require 'opal/rspec/rake_task'
require 'rack'
require 'fron'
require './lib/app'

task :server do
  Rack::Server.start :app => HR.server, Port: 9292
end

task :test do
  Opal::RSpec::RakeTask.new do |server|
    server.append_path File.expand_path(File.dirname(__FILE__) + '/config')
    server.append_path File.expand_path(File.dirname(__FILE__) + '/source')
  end
  Rake::Task['opal:rspec'].invoke
end
