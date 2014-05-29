RedmineApp::Application.routes.draw do

  mount HR.server => "/hr_assets/"

  resources :hr
  resources :hr_holiday_requests do
    member do
      HrHolidayRequest::SM.events.map(&:name).each do |method|
        get method, action: method.to_s+"!"
      end
    end
  end
  resources :hr_employee_profiles do
    resources :hr_holiday_modifiers
  end

end
