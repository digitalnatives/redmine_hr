require 'redmine'
require_dependency 'deps'
require_dependency 'app'
require_dependency 'holiday_calculator'

Redmine::Plugin.register :redmine_hr do
  name 'Redmine HR plugin'
  author 'Digital Natives'
  description 'HR management plugin for redmine'
  version '0.0.1'
  url 'tba'
  author_url 'tba'

  permission :view_holidays, :hr => [:index]

  menu(:top_menu, :hr, {:controller => "hr", :action => 'index'}, :caption => 'HR', :after => :my_page, :if => Proc.new{ User.current.logged? && User.current.allowed_to_hr? }, :param => :user_id)

  settings :default => {'admin_role' => 0, 'working_day' => "Working day"}, :partial => 'settings/redmine_hr_settings'
end
