RedmineApp::Application.routes.draw do

	mount HR.server => "/hr_assets/"
  resources :holidays

end
