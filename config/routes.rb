Rails.application.routes.draw do
  post 'expenses' => 'expenses#create'
  get 'expenses/:expense_id' => 'expenses#show'
  delete 'expenses/:expense_id' => 'expenses#destroy'
  get 'expenses' => 'expenses#index'

  post 'groups' => 'groups#create'
  get 'groups/:group_id' => 'groups#show'
  delete 'groups/:group_id' => 'groups#destroy'
  get 'groups' => 'groups#index'

  post 'users' => 'users#create'
  get 'users/:user_id' => 'users#show'
  delete 'users/:user_id' => 'users#destroy'
  get 'users' => 'users#list'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
