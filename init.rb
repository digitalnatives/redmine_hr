require 'redmine'
require_dependency 'app'

Rails.configuration.to_prepare do
  User.class_eval do
    has_one :employee_profile
    before_create :build_default_employee_profile

    private

    # Create employee_profile automatically
    def build_default_employee_profile
      build_employee_profile
      true
    end
  end
end

Redmine::Plugin.register :redmine_hr do
  name 'Redmine HR plugin'
  author 'Digital Natives'
  description 'HR management plugin for redmine'
  version '0.0.1'
  url 'tba'
  author_url 'tba'

  permission :view_holidays, :holidays => [:index]

  menu(:top_menu, :holidays, {:controller => "holidays", :action => 'index'}, :caption => 'Holidays', :after => :my_page, :if => Proc.new{ User.current.logged? && User.current.allowed_to?(:view_holidays,nil,global: true)}, :param => :user_id)
end
