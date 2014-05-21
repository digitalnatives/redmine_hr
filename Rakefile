require 'rubygems'
require 'bundler'
Bundler.setup(:default)
require 'rack'
require 'fron'
require './lib/app'

task :server do
  Rack::Server.start :app => HR.server, Port: 9292
end
