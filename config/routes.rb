RedmineApp::Application.routes.draw do

  mount HR.server => "/hr_assets/"

  resources :hr
  resources :hr_employee_profiles do
    resources :hr_holiday_modifiers
  end

end
