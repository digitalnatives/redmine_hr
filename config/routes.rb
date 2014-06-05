RedmineApp::Application.routes.draw do

  mount HR.server => "/hr_assets/"

  resources :hr
  resources :hr_holiday_requests do
    collection do
      get :filter_data
    end
    member do
      HrHolidayRequest::SM.events.map(&:name).each do |method|
        get method, action: method.to_s+"!"
      end
    end
  end
  resources :hr_employee_profiles do
    resources :hr_holiday_modifiers
    resources :hr_employee_children
  end

end
