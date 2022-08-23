Rails.application.routes.draw do

  # This will generate devise routes

  resources :roles, controller: "users/roles"

  devise_for :users,
             controllers: {
                 sessions: 'users/sessions',
                 registrations: 'users/registrations'
             }

  # route to see the current user profile
  get '/profile', to: 'users/members#show'

  # This creates routes for users folder
  namespace :users do
    resources :users, path: '/', except: %i[create]
  end

  # namespace :books do
  #   resources :issuedbooks
  #   resources :books
  # end

end
