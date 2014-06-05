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
    server.main = 'runner'
    server.append_path File.expand_path(File.dirname(__FILE__) + '/frontend_spec')
    server.append_path File.expand_path(File.dirname(__FILE__) + '/config')
    server.append_path File.expand_path(File.dirname(__FILE__) + '/source')
  end
  Rake::Task['opal:rspec'].invoke
end

task :build do
  code = HR.server.sprockets.find_asset('hr.js')
  path = File.expand_path(File.dirname(__FILE__) + '/assets/javascripts/hr.js')
  File.open(path, 'w+') { |file| file.write(code) }
end
