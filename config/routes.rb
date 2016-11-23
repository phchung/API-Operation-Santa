Rails.application.routes.draw do
  namespace :api, defaults: {format: :json} do
    resource :session, only: [:create,:destroy] 
    resources :user, only: [:create,:index,:show,:update,:destroy]
    resources :postmates, only: [:get,:put,:delete] do
      collection do
        post :get_estimate
        post :create_delivery
      end
    end
  end
  match '*any' => 'application#options', :via => [:options]
end
