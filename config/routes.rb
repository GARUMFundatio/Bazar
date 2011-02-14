Bazar::Application.routes.draw do

  resources :favoritos

  resources :actividades

  root :to => 'home#home'
  match '/noticias.rss' => 'noticias#rss'

  resources :noticias
  resources :clusters
  resources :mensajes
  resources :gruposconfs
  resources :confs
  resources :roles_users
  resources :roles
  resources :user_sessions
  resources :ciudades
  resources :password_resets
  
  # get 'login(.:format)' => 'user_sessions#new', :as => :login
  # post 'login(.:format)' => 'user_sessions#create', :as => :login
  # delete 'logout(.:format)' => 'user_sessions#destroy', :as => :logout
  
  resources :users
  
  match 'micuenta' => "user#edit",          :as => :micuenta
  match 'login' => "user_sessions#new",      :as => :login
  match 'logout' => "user_sessions#destroy", :as => :logout
  match 'home' => "home#index"
  match '/mensajes/leido/:id' => "mensajes#leido", :constrants => { :id => /\d+/ }
  match 'busquedaciudades' => 'ciudades#busqueda', :as => :busquedaciudades
  match '/clusters/activar/:id' => 'clusters#activar', :constrants => { :id => /\d+/ }, :as => :activar_cluster
  match '/notificacion' => 'mensajes#notificacion', :as => :notificacion
  match '/enviarnotificacion' => 'mensajes#enviarnotificacion', :as => :enviarnotificacion
  match '/updateinfo' => 'clusters#updateinfo', :as => :updateinfo
  
# API routes

  match '/api/index' => 'api#index'
  match '/api/info' => 'api#info'
  match '/api/empresas' => 'api#empresas'
  match '/api/infoempresa(.:format)/:id' => "api#infoempresa", :constrants => { :id => /\d+/ }

  match '/api/ejemplos' => 'api#ejemplos'
  match '/api/ejemploinfo' => 'api#ejemploinfo'
  match '/api/ejemploempresas' => 'api#ejemploempresas'
  match '/api/ejemploinfoempresa' => 'api#ejemploinfoempresa'
  

end
