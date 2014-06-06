require 'redmine'
require_dependency 'deps'
require_dependency 'app'
require_dependency 'holiday_calculator'
require_dependency 'hun_2014'
require_dependency 'holiday_report'

Redmine::Plugin.register :redmine_hr do
  name 'Redmine HR plugin'
  author 'Digital Natives'
  description 'HR management plugin for redmine'
  version '0.0.1'
  url 'tba'
  author_url 'tba'

  menu(:top_menu, :hr, {:controller => "hr", :action => 'index'}, :caption => 'HR', :after => :my_page, :if => Proc.new{ User.current.logged? && User.current.allowed_to_hr? }, :param => :user_id)

  settings :default => {
  	'admin_group' => [0],
    'access' => [0],
  	'working_day' => "Working day",
  	'holiday_module' => "HrHolidayCalculator::Hun2014"
	}, :partial => 'settings/redmine_hr_settings'
end
