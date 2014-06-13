require 'rubygems'
require 'bundler/setup'
require "rails/all"
Bundler.require(:default)
require './lib/app'

module Redmine
  module WikiFormatting
    def self.to_html(a,b)
      ""
    end
  end
end

class Mailer < ActionMailer::Base
end

class Secretary
  def self.ask(type,from,to)
    {}
  end
end

class Group
  def self.find(id)
    Group.new
  end

  def user_ids
    (0..1000).to_a
  end
end

module Setting
  def self.plugin_redmine_hr
    { admin_role: 0, working_day: "Working Day", admin_group: [0], access: [0] }
  end

  def self.host_name
    "a"
  end

  def self.protocol
    "b"
  end

  def self.text_formatting
    ""
  end

  def self.emails_header
    ""
  end

  def self.emails_footer
    ""
  end
end

class ApplicationController < ActionController::Base
  before_filter :prepend_view_paths

   def prepend_view_paths
     prepend_view_path "app/views/"
   end
end

class User < ActiveRecord::Base

  class << self
    attr_accessor :current
  end

  def name
    lastname + " " + firstname
  end

  def mail
    ""
  end
end

module RedmineApp
  class Application < Rails::Application
    config.secret_token = "37345f5b0290ba7611149625389eb6f7"
    config.active_support.deprecation = :log
    config.action_mailer.perform_deliveries = false

    def config.database_configuration
      {
        "test" => {
          :adapter => 'mysql2',
          :database => 'redmine_hr_test',
          :username => "travis"
        },
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

require './app/models/hr_holiday_request'
require './lib/deps'
require './config/routes'

silence_stream STDOUT do
  client = Mysql2::Client.new(:host => "localhost", :username => "root")
  client.query('DROP DATABASE redmine_hr_test')
  client.query('CREATE DATABASE redmine_hr_test')

  RedmineApp::Application.initialize!

  ActiveRecord::Migration.create_table :users do |t|
    t.boolean :admin
    t.boolean :test_hr_access, default: 1
    t.string :test_role, default: 'user'
    t.string :firstname
    t.string :lastname
    t.timestamps
  end
  ActiveRecord::Migrator.up "db/migrate"
end
