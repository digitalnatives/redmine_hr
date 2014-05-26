require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)
require "action_controller/railtie"
require './lib/app'


module RedmineApp
  class Application < Rails::Application
    config.secret_token = "37345f5b0290ba7611149625389eb6f7"
  end
end

class MockController < ActionController::Base
  define_method "hr_employee_profiles.json" do
    render :json => [{user: {firstname: 'X', lastname: 'Y'}, supervisor: {}, id: '0', holiday_modifiers: []}]
  end

  define_method 'hr_employee_profiles/0' do
    render :json => {user: {firstname: 'X', lastname: 'Y'}, supervisor: {}, id: '0', holiday_modifiers: []}
  end
end

RedmineApp::Application.routes.draw do
  mount HR.server => "/"

  MockController.instance_methods.each do |name|
    if name =~ /^hr/
      get "/#{name}", to: "mock##{name}"
    end
  end
end

Rails.logger = Logger.new(STDOUT)
