require './deps'
require 'native'

module Kernel
  def t(scope,options = {})
    `I18n.t(#{scope},JSON.parse(#{options.to_json}))`
  end
end

module Fron
  class Request
    private

    def handle_state_change
      if ready_state == 4
        response = Response.new `#{@request}.status`, `#{@request}.responseText`, `#{@request}.getAllResponseHeaders()`
        @callback.call response if @callback
      end
    end
  end
end


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
  el = DOM::Element.new 'div'
  injectPoint << el

  injectPoint.find("#content").hide

  config.customInject do |base|
    el.empty
    el << base
  end
end

RedmineHR.new

menu = {
  "#{t('hr.main_menu.my_profile')}" => "#profiles/#{CurrentProfile.id}",
  "#{t('hr.main_menu.my_holiday_requests')}" => "#holiday_requests/mine",
  "#{t('hr.main_menu.new_holiday_request')}" => "#holiday_requests/new"
}

if CurrentUser.admin || CurrentUser[:supervisor]
  menu[t('hr.main_menu.holiday_requests')] = "#holiday_requests/"
end
if CurrentUser.admin
  menu[t('hr.main_menu.employee_profiles')] = "#profiles"
end

MainMenu.new menu

