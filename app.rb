require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)
require "rails/all"
require './lib/app'

class ApplicationController < ActionController::Base
  before_filter :prepend_view_paths

   def prepend_view_paths
     prepend_view_path "app/views/"
   end
end

class User < ActiveRecord::Base
  def self.current
    @current = self.new
  end

  def admin?
    true
  end

  def allowed_to?(a,b,c)
    true
  end
end

module RedmineApp
  class Application < Rails::Application
    config.secret_token = "37345f5b0290ba7611149625389eb6f7"
    config.active_support.deprecation = :log

    def config.database_configuration
      {
        "development" => {
          :adapter => 'mysql2',
          :database => 'redmine_hr_test',
          :host => 'localhost',
          :password => ""
        }
      }
    end
  end
end

Rails.logger = Logger.new(STDOUT)
require './config/routes'
require './lib/deps'

client = Mysql2::Client.new(:host => "localhost", :username => "root")
client.query('DROP DATABASE redmine_hr_test')
client.query('CREATE DATABASE redmine_hr_test')

RedmineApp::Application.initialize!

ActiveRecord::Migration.create_table :users do |t|
  t.string :firstname
  t.string :lastname
  t.timestamps
end
ActiveRecord::Migrator.up "db/migrate"

u = User.create({firstname: 'Test', lastname: 'User'})
