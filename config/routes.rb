Bazar::Application.routes.draw do


  themes_for_rails

#  root :to => 'home#home'
  root :to => 'home#queesbazar'


  match '/noticias.rss' => 'noticias#rss'
  match '/actividades.rss' => 'actividades#rss'
  match '/actividades.rss' => 'actividades#rss'
  
  
  resources :favoritos
  resources :actividades

  resources :noticias
  resources :clusters
  resources :mensajes
  resources :gruposconfs
  resources :confs
  resources :roles_users
  resources :roles
  resources :user_sessions
  resources :ciudades
  resources :paises
  resources :password_resets
  
  # get 'login(.:format)' => 'user_sessions#new', :as => :login
  # post 'login(.:format)' => 'user_sessions#create', :as => :login
  # delete 'logout(.:format)' => 'user_sessions#destroy', :as => :logout
  
  resources :users
  
  match 'micuenta' => "user#edit",          :as => :micuenta
  match 'login' => "user_sessions#new",      :as => :login
  match 'logout' => "user_sessions#destroy", :as => :logout
  match '/registrarse' => "users#registrarse"
  match '/altaregistrarse' => "users#altaregistrarse"
  
  match 'home' => "home#index"
  match '/home/bazares' => "home#bazares"
  match '/home/datos' => "home#datos"
  match '/home/open' => "home#open"
  match '/home/dashboardbazar' => "home#dashboardbazar"
  match '/home/ofertas/:tipo' => "home#ofertas"
  match '/home/fichaoferta/:bazar/:id' => "home#fichaoferta", :constrants => { :id => /\d+/ , :bazar => /\d+/ }
  match '/busqueda-oferta' => "home#busquedaoferta"
   
  match '/mensajes/leido/:id' => "mensajes#leido", :constrants => { :id => /\d+/ }
  match '/mensajeremoto' => "mensajes#mensajeremoto"
  match "/mensaje/dashboard" => "mensajes#dashboard"
  match '/notificacion' => 'mensajes#notificacion', :as => :notificacion
  match '/enviarnotificacion' => 'mensajes#enviarnotificacion', :as => :enviarnotificacion

  match 'busquedaciudades' => 'ciudades#busqueda', :as => :busquedaciudades
  match '/clusters/activar/:id' => 'clusters#activar', :constrants => { :id => /\d+/ }, :as => :activar_cluster
  match '/updateinfo' => 'clusters#updateinfo', :as => :updateinfo
  match "/actividad/dashboard" => "actividades#dashboard"
  
  match "/favorito/addfav" => "favoritos#addfav"
  match "/favorito/delfav" => "favoritos#delfav"  
  match "/favorito/dashboard" => "favoritos#dashboard"

  match "/busquedapaises" => "paises#busqueda"
  
  match "/avisos/dashboard" => 'home#avisos'
  
  scope '/translate' do
    match '/translate_list', :to => 'translate#index'
    match '/translate', :to => 'translate#translate'
    match '/translate_reload', :to => 'translate#reload', :as => 'translate_reload'
  end

# API routes

 
  match '/api/index' => 'api#index'
  match '/api/info' => 'api#info'
  match '/api/empresas' => 'api#empresas'
  match '/api/perfiles' => 'api#perfiles'
  match '/api/paises' => 'api#paises'
  match '/api/infoempresa(.:format)/:id' => "api#infoempresa", :constrants => { :id => /\d+/ }

  match '/api/ejemplos' => 'api#ejemplos'
  match '/api/ejemploinfo' => 'api#ejemploinfo'
  match '/api/ejemploempresas' => 'api#ejemploempresas'
  match '/api/ejemploinfoempresa' => 'api#ejemploinfoempresa'
  match '/api/ejemploperfiles' => 'api#ejemploperfiles'
  match '/api/ejemplopaises' => 'api#ejemplopaises'


  scope '/translate' do
    match '/translate_list', :to => 'translate#index'
    match '/translate', :to => 'translate#translate'
    match '/translate_reload', :to => 'translate#reload', :as => 'translate_reload'
  end
  
end
