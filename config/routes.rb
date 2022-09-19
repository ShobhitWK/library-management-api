Rails.application.routes.draw do

  # view user profile
  root 'users/users#profile'

  # roles routes
  resources :roles, controller: "users/roles"

  resources :issuedbooks, controller: "books/issuedbooks"
  post 'issuedbooks/return/:id', to: "books/issuedbooks#return"

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

  # handling routing error
  get '*path', :to => 'application#handlenotfound'
  post '*path', :to => 'application#handlenotfound'

end
