require 'fron'

require 'vendor/i18n'
require 'locales/en'

require 'fron-ext/rails_adapter'

require 'components/content'
require 'components/main-menu'

require 'models/employee_profile'
require 'models/holiday_modifier'
require 'models/holiday_request'

require 'controllers/application_controller'
require 'controllers/profiles_controller'
require 'controllers/holiday_requests_controller'

module Kernel
  def t(scope,options = {})
    `I18n.t(#{scope},JSON.parse(#{options.to_json}))`
  end
end
