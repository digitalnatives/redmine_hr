RedmineApp::Application.routes.draw do

  mount HR.server => "/hr_assets/"

  resources :hr
  resources :hr_holiday_requests
  resources :hr_employee_profiles do
    resources :hr_holiday_modifiers
    resources :hr_employee_children
  end

end
