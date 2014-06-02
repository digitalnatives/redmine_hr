require './deps'
require 'native'

CurrentUser = Native `window.CurrentUser`
CurrentProfile = EmployeeProfile.new CurrentUser[:profile]

class RedmineHR < Fron::Application
  config.title = `document.title`
  config.stylesheets = []

  config.routes do
    map "holiday_requests/", HolidayRequestsController
    map ProfilesController
  end

  injectPoint = DOM::Element.new `document.querySelector("#main")`

  config.customInject do |base|
    injectPoint.empty
    injectPoint << base
  end
end

RedmineHR.new
MainMenu.new({
  "#{t('hr.main_menu.employee_profiles')}" => "#profiles",
  "#{t('hr.main_menu.new_holiday_request')}" => "#holiday_requests/new"
})

