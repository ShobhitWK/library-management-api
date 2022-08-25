Rails.application.routes.draw do

  # roles routes
  resources :roles, controller: "users/roles"
  resources :issuedbooks, controller: "books/issuedbooks"

  # This will generate devise routes
  devise_for :users,
             controllers: {
                 sessions: 'users/sessions',
                 registrations: 'users/registrations'
             }

  # route to see the current user profile
  get '/profile', to: 'users/users#profile'

  # This creates routes for users folder
  namespace :users do
    resources :users, path: '/', except: %i[create]
  end


  # books routes
  namespace :books do
    resources :books, path: '/'
  end

end
