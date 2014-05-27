require 'fron'

require 'vendor/i18n'
require 'locales/en'

require './fron-ext/rails_adapter'

require './components/content'
require './components/main-menu'

require './models/employee_profile'
require './models/holiday_modifier'

require './controllers/application_controller'
require './controllers/profiles_controller'

module Kernel
  def t(scope,options = {})
    `I18n.t(#{scope},JSON.parse(#{options.to_json}))`
  end
end

class RedmineHR < Fron::Application
  config.title = `document.title`
  config.stylesheets = []

  config.routes do
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
})

