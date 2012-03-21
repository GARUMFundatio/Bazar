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
  match '/home/micuenta/:id' => "home#micuenta", :constrants => { :id => /\d+/ }
  match '/home/actualizamicuenta/:id' => "home#actualizamicuenta", :constrants => { :id => /\d+/ } 
  
  match 'home' => "home#index"
  match '/home/bazares' => "home#bazares"
  match '/home/datos' => "home#datos"
  match '/home/open' => "home#open"
  match '/home/dashboardbazar' => "home#dashboardbazar"
  match '/home/busquedageneral' => "home#busquedageneral"
  match '/home/redirigebusqueda' => "home#redirigebusqueda"

  match '/home/ofertas/:tipo' => "home#ofertas"
  match '/home/fichaoferta/:bazar/:id' => "home#fichaoferta", :constrants => { :id => /\d+/ , :bazar => /\d+/ }
  match '/busqueda-oferta' => "home#busquedaoferta"
  match '/home/ofertadatosgenerales/:bazar/:id' => "home#ofertadatosgenerales", :constrants => { :id => /\d+/ , :bazar => /\d+/ }
  match '/home/actofertadatosgenerales/:bazar/:id' => "home#actofertadatosgenerales", :constrants => { :id => /\d+/ , :bazar => /\d+/ }
  match '/home/crearoferta/:bazar/:id' => "home#crearoferta", :constrants => { :id => /\d+/ , :bazar => /\d+/ }
  
  match '/home/empresas/' => "home#empresas"
  match '/home/fichaempresa/:bazar/:id' => "home#fichaempresa", :constrants => { :id => /\d+/ , :bazar => /\d+/ }
  match '/busqueda-empresa' => "home#busquedaempresa"
  match '/home/empresadatosgenerales/:bazar/:id' => "home#empresadatosgenerales", :constrants => { :id => /\d+/ , :bazar => /\d+/ }
  match '/home/empresadatosgenerales2/:bazar/:id' => "home#empresadatosgenerales2", :constrants => { :id => /\d+/ , :bazar => /\d+/ }
  match '/home/actempresadatosgenerales/:bazar/:id' => "home#actempresadatosgenerales", :constrants => { :id => /\d+/ , :bazar => /\d+/ }
  match '/home/crearimagenempresa' => "home#crearimagenempresa"
  match '/home/delempresaimagen/:empresa/:id' => "home#delempresaimagen", :constrants => { :id => /\d+/ , :empresa => /\d+/ }
  match '/home/empresasestimadas' => "home#empresasestimadas"
  match '/home/filtraresultadosempresas/:resu/:tipo' => "home#filtraresultadosempresas", :constrants => { :resu => /\d+/ , :tipo => /\s+/ }
  match '/home/addsede/:id' => "home#addsede", :constrants => { :id => /\d+/ }
  match '/home/grabasede/' => "home#grabasede"
  match '/home/delsede/:empresa/:id' => "home#delsede", :constrants => { :empresa => /\d+/, :id => /\d+/ }
  match '/home/cambiarlogo' => "home#cambiarlogo"

  
  match '/home/favoritos/' => "home#favoritos"
  match '/home/delfav/:bazar/:id' => "home#delfav", :constrants => { :id => /\d+/ , :bazar => /\d+/ }
  match '/home/addfav/:bazar/:id' => "home#addfav", :constrants => { :id => /\d+/ , :bazar => /\d+/ }
  match '/home/delofefav/:bazar/:id/:class' => "home#delofefav", :constrants => { :id => /\d+/ , :bazar => /\d+/ }
  match '/home/addofefav/:bazar/:id/:class' => "home#addofefav", :constrants => { :id => /\d+/ , :bazar => /\d+/ }
  match '/home/crearimagenoferta/:id/:empresa' => "home#crearimagenoferta", :constrants => { :id => /\d+/ , :empresa => /\d+/ }
  match '/home/delofertaimagen/:oferta/:id' => "home#delofertaimagen", :constrants => { :id => /\d+/ , :oferta => /\d+/ }
  match '/home/editaroferta/:oferta/:id' => "home#editaroferta", :constrants => { :id => /\d+/ , :oferta => /\d+/ }
  match '/home/imagenesoferta/:oferta' => "home#imagenesoferta", :constrants => {:oferta => /\d+/ }
  match '/home/subirimagenoferta/:oferta' =>  "home#subirimagenoferta", :constrants => {:oferta => /\d+/ }
  match '/home/cancelaroferta/:oferta' =>  "home#cancelaroferta", :constrants => {:oferta => /\d+/ }
  match '/home/publicaroferta/:oferta' =>  "home#publicaroferta", :constrants => {:oferta => /\d+/ }
  match '/home/filtraresultadosofertas/:resu/:tipo' => "home#filtraresultadosofertas", :constrants => { :resu => /\d+/ , :tipo => /\s+/ }
  
  match '/home/test/' => "home#test"
  match '/home/editarcorreo/:bazar/:id' =>  "home#editarcorreo", :constrants => {:bazar => /\d+/ , :id => /\d+/ }
  match '/home/enviarcorreo/:id' =>  "home#enviarcorreo", :constrants => {:id => /\d+/ }

  match '/home/rating/:bazar/:id/:valor' => "home#rating", :constrants => {:bazar => /\d+/ , :id => /\d+/, :valor => /\d+/}

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
  match '/api/infooferta(.:format)/:id' => "api#infooferta", :constrants => { :id => /\d+/ }
  match '/api/buscaempresas' => 'api#buscaempresas'
  
  match '/api/ejemplos' => 'api#ejemplos'
  match '/api/ejemploinfo' => 'api#ejemploinfo'
  match '/api/ejemploempresas' => 'api#ejemploempresas'
  match '/api/ejemploinfoempresa' => 'api#ejemploinfoempresa'
  match '/api/ejemploinfooferta' => 'api#ejemploinfooferta'  
  match '/api/ejemploperfiles' => 'api#ejemploperfiles'
  match '/api/ejemplopaises' => 'api#ejemplopaises'


#    scope '/translate' do
#      match '/translate_list', :to => 'translate#index'
#      match '/translate', :to => 'translate#translate'
#      match '/translate_reload', :to => 'translate#reload', :as => 'translate_reload'
#    end
#  
#   Translate::Routes.translation_ui(map) if RAILS_ENV != "production"
  
  
end
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
  match '/home/busquedageneral' => "home#busquedageneral"
  match '/home/redirigebusqueda' => "home#redirigebusqueda"

  match '/home/ofertas/:tipo' => "home#ofertas"
  match '/home/fichaoferta/:bazar/:id' => "home#fichaoferta", :constrants => { :id => /\d+/ , :bazar => /\d+/ }
  match '/busqueda-oferta' => "home#busquedaoferta"
  match '/home/ofertadatosgenerales/:bazar/:id' => "home#ofertadatosgenerales", :constrants => { :id => /\d+/ , :bazar => /\d+/ }
  match '/home/actofertadatosgenerales/:bazar/:id' => "home#actofertadatosgenerales", :constrants => { :id => /\d+/ , :bazar => /\d+/ }
  match '/home/crearoferta/:bazar/:id' => "home#crearoferta", :constrants => { :id => /\d+/ , :bazar => /\d+/ }
  
  match '/home/empresas/' => "home#empresas"
  match '/home/fichaempresa/:bazar/:id' => "home#fichaempresa", :constrants => { :id => /\d+/ , :bazar => /\d+/ }
  match '/busqueda-empresa' => "home#busquedaempresa"
  match '/home/empresadatosgenerales/:bazar/:id' => "home#empresadatosgenerales", :constrants => { :id => /\d+/ , :bazar => /\d+/ }
  match '/home/empresadatosgenerales2/:bazar/:id' => "home#empresadatosgenerales2", :constrants => { :id => /\d+/ , :bazar => /\d+/ }
  match '/home/actempresadatosgenerales/:bazar/:id' => "home#actempresadatosgenerales", :constrants => { :id => /\d+/ , :bazar => /\d+/ }
  match '/home/crearimagenempresa' => "home#crearimagenempresa"
  match '/home/delempresaimagen/:empresa/:id' => "home#delempresaimagen", :constrants => { :id => /\d+/ , :empresa => /\d+/ }
  match '/home/empresasestimadas' => "home#empresasestimadas"
  match '/home/filtraresultadosempresas/:resu/:tipo' => "home#filtraresultadosempresas", :constrants => { :resu => /\d+/ , :tipo => /\s+/ }
  match '/home/addsede/:id' => "home#addsede", :constrants => { :id => /\d+/ }
  match '/home/grabasede/' => "home#grabasede"
  match '/home/delsede/:empresa/:id' => "home#delsede", :constrants => { :empresa => /\d+/, :id => /\d+/ }
  
  match '/home/favoritos/' => "home#favoritos"
  match '/home/delfav/:bazar/:id' => "home#delfav", :constrants => { :id => /\d+/ , :bazar => /\d+/ }
  match '/home/addfav/:bazar/:id' => "home#addfav", :constrants => { :id => /\d+/ , :bazar => /\d+/ }
  match '/home/delofefav/:bazar/:id/:class' => "home#delofefav", :constrants => { :id => /\d+/ , :bazar => /\d+/ }
  match '/home/addofefav/:bazar/:id/:class' => "home#addofefav", :constrants => { :id => /\d+/ , :bazar => /\d+/ }
  match '/home/crearimagenoferta/:id/:empresa' => "home#crearimagenoferta", :constrants => { :id => /\d+/ , :empresa => /\d+/ }
  match '/home/delofertaimagen/:oferta/:id' => "home#delofertaimagen", :constrants => { :id => /\d+/ , :oferta => /\d+/ }
  match '/home/editaroferta/:oferta/:id' => "home#editaroferta", :constrants => { :id => /\d+/ , :oferta => /\d+/ }
  match '/home/imagenesoferta/:oferta' => "home#imagenesoferta", :constrants => {:oferta => /\d+/ }
  match '/home/subirimagenoferta/:oferta' =>  "home#subirimagenoferta", :constrants => {:oferta => /\d+/ }
  match '/home/cancelaroferta/:oferta' =>  "home#cancelaroferta", :constrants => {:oferta => /\d+/ }
  match '/home/publicaroferta/:oferta' =>  "home#publicaroferta", :constrants => {:oferta => /\d+/ }
  match '/home/filtraresultadosofertas/:resu/:tipo' => "home#filtraresultadosofertas", :constrants => { :resu => /\d+/ , :tipo => /\s+/ }
  
  match '/home/test/' => "home#test"
  match '/home/editarcorreo/:bazar/:id' =>  "home#editarcorreo", :constrants => {:bazar => /\d+/ , :id => /\d+/ }
  match '/home/enviarcorreo/:id' =>  "home#enviarcorreo", :constrants => {:id => /\d+/ }

  match '/home/rating/:bazar/:id/:valor' => "home#rating", :constrants => {:bazar => /\d+/ , :id => /\d+/, :valor => /\d+/}

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
  match '/api/infooferta(.:format)/:id' => "api#infooferta", :constrants => { :id => /\d+/ }
  match '/api/buscaempresas' => 'api#buscaempresas'
  
  match '/api/ejemplos' => 'api#ejemplos'
  match '/api/ejemploinfo' => 'api#ejemploinfo'
  match '/api/ejemploempresas' => 'api#ejemploempresas'
  match '/api/ejemploinfoempresa' => 'api#ejemploinfoempresa'
  match '/api/ejemploinfooferta' => 'api#ejemploinfooferta'  
  match '/api/ejemploperfiles' => 'api#ejemploperfiles'
  match '/api/ejemplopaises' => 'api#ejemplopaises'


#    scope '/translate' do
#      match '/translate_list', :to => 'translate#index'
#      match '/translate', :to => 'translate#translate'
#      match '/translate_reload', :to => 'translate#reload', :as => 'translate_reload'
#    end
#  
#   Translate::Routes.translation_ui(map) if RAILS_ENV != "production"
  
  
end
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
  match '/home/busquedageneral' => "home#busquedageneral"
  match '/home/redirigebusqueda' => "home#redirigebusqueda"

  match '/home/ofertas/:tipo' => "home#ofertas"
  match '/home/fichaoferta/:bazar/:id' => "home#fichaoferta", :constrants => { :id => /\d+/ , :bazar => /\d+/ }
  match '/busqueda-oferta' => "home#busquedaoferta"
  match '/home/ofertadatosgenerales/:bazar/:id' => "home#ofertadatosgenerales", :constrants => { :id => /\d+/ , :bazar => /\d+/ }
  match '/home/actofertadatosgenerales/:bazar/:id' => "home#actofertadatosgenerales", :constrants => { :id => /\d+/ , :bazar => /\d+/ }
  match '/home/crearoferta/:bazar/:id' => "home#crearoferta", :constrants => { :id => /\d+/ , :bazar => /\d+/ }
  
  match '/home/empresas/' => "home#empresas"
  match '/home/fichaempresa/:bazar/:id' => "home#fichaempresa", :constrants => { :id => /\d+/ , :bazar => /\d+/ }
  match '/busqueda-empresa' => "home#busquedaempresa"
  match '/home/empresadatosgenerales/:bazar/:id' => "home#empresadatosgenerales", :constrants => { :id => /\d+/ , :bazar => /\d+/ }
  match '/home/empresadatosgenerales2/:bazar/:id' => "home#empresadatosgenerales2", :constrants => { :id => /\d+/ , :bazar => /\d+/ }
  match '/home/actempresadatosgenerales/:bazar/:id' => "home#actempresadatosgenerales", :constrants => { :id => /\d+/ , :bazar => /\d+/ }
  match '/home/crearimagenempresa' => "home#crearimagenempresa"
  match '/home/delempresaimagen/:empresa/:id' => "home#delempresaimagen", :constrants => { :id => /\d+/ , :empresa => /\d+/ }
  match '/home/empresasestimadas' => "home#empresasestimadas"
  match '/home/filtraresultadosempresas/:resu/:tipo' => "home#filtraresultadosempresas", :constrants => { :resu => /\d+/ , :tipo => /\s+/ }
  match '/home/addsede/:id' => "home#addsede", :constrants => { :id => /\d+/ }
  match '/home/grabasede/' => "home#grabasede"
  match '/home/delsede/:empresa/:id' => "home#delsede", :constrants => { :empresa => /\d+/, :id => /\d+/ }
  
  match '/home/favoritos/' => "home#favoritos"
  match '/home/delfav/:bazar/:id' => "home#delfav", :constrants => { :id => /\d+/ , :bazar => /\d+/ }
  match '/home/addfav/:bazar/:id' => "home#addfav", :constrants => { :id => /\d+/ , :bazar => /\d+/ }
  match '/home/delofefav/:bazar/:id/:class' => "home#delofefav", :constrants => { :id => /\d+/ , :bazar => /\d+/ }
  match '/home/addofefav/:bazar/:id/:class' => "home#addofefav", :constrants => { :id => /\d+/ , :bazar => /\d+/ }
  match '/home/crearimagenoferta/:id/:empresa' => "home#crearimagenoferta", :constrants => { :id => /\d+/ , :empresa => /\d+/ }
  match '/home/delofertaimagen/:oferta/:id' => "home#delofertaimagen", :constrants => { :id => /\d+/ , :oferta => /\d+/ }
  match '/home/editaroferta/:oferta/:id' => "home#editaroferta", :constrants => { :id => /\d+/ , :oferta => /\d+/ }
  match '/home/imagenesoferta/:oferta' => "home#imagenesoferta", :constrants => {:oferta => /\d+/ }
  match '/home/subirimagenoferta/:oferta' =>  "home#subirimagenoferta", :constrants => {:oferta => /\d+/ }
  match '/home/cancelaroferta/:oferta' =>  "home#cancelaroferta", :constrants => {:oferta => /\d+/ }
  match '/home/publicaroferta/:oferta' =>  "home#publicaroferta", :constrants => {:oferta => /\d+/ }
  match '/home/filtraresultadosofertas/:resu/:tipo' => "home#filtraresultadosofertas", :constrants => { :resu => /\d+/ , :tipo => /\s+/ }
  
  match '/home/test/' => "home#test"
  match '/home/editarcorreo/:bazar/:id' =>  "home#editarcorreo", :constrants => {:bazar => /\d+/ , :id => /\d+/ }
  match '/home/enviarcorreo/:id' =>  "home#enviarcorreo", :constrants => {:id => /\d+/ }

  match '/home/rating/:bazar/:id/:valor' => "home#rating", :constrants => {:bazar => /\d+/ , :id => /\d+/, :valor => /\d+/}

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
  match '/api/infooferta(.:format)/:id' => "api#infooferta", :constrants => { :id => /\d+/ }
  match '/api/buscaempresas' => 'api#buscaempresas'
  
  match '/api/ejemplos' => 'api#ejemplos'
  match '/api/ejemploinfo' => 'api#ejemploinfo'
  match '/api/ejemploempresas' => 'api#ejemploempresas'
  match '/api/ejemploinfoempresa' => 'api#ejemploinfoempresa'
  match '/api/ejemploinfooferta' => 'api#ejemploinfooferta'  
  match '/api/ejemploperfiles' => 'api#ejemploperfiles'
  match '/api/ejemplopaises' => 'api#ejemplopaises'


#    scope '/translate' do
#      match '/translate_list', :to => 'translate#index'
#      match '/translate', :to => 'translate#translate'
#      match '/translate_reload', :to => 'translate#reload', :as => 'translate_reload'
#    end
#  
#   Translate::Routes.translation_ui(map) if RAILS_ENV != "production"
  
  
end
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
  match '/home/busquedageneral' => "home#busquedageneral"
  match '/home/redirigebusqueda' => "home#redirigebusqueda"

  match '/home/ofertas/:tipo' => "home#ofertas"
  match '/home/fichaoferta/:bazar/:id' => "home#fichaoferta", :constrants => { :id => /\d+/ , :bazar => /\d+/ }
  match '/busqueda-oferta' => "home#busquedaoferta"
  match '/home/ofertadatosgenerales/:bazar/:id' => "home#ofertadatosgenerales", :constrants => { :id => /\d+/ , :bazar => /\d+/ }
  match '/home/actofertadatosgenerales/:bazar/:id' => "home#actofertadatosgenerales", :constrants => { :id => /\d+/ , :bazar => /\d+/ }
  match '/home/crearoferta/:bazar/:id' => "home#crearoferta", :constrants => { :id => /\d+/ , :bazar => /\d+/ }
  
  match '/home/empresas/' => "home#empresas"
  match '/home/fichaempresa/:bazar/:id' => "home#fichaempresa", :constrants => { :id => /\d+/ , :bazar => /\d+/ }
  match '/busqueda-empresa' => "home#busquedaempresa"
  match '/home/empresadatosgenerales/:bazar/:id' => "home#empresadatosgenerales", :constrants => { :id => /\d+/ , :bazar => /\d+/ }
  match '/home/empresadatosgenerales2/:bazar/:id' => "home#empresadatosgenerales2", :constrants => { :id => /\d+/ , :bazar => /\d+/ }
  match '/home/actempresadatosgenerales/:bazar/:id' => "home#actempresadatosgenerales", :constrants => { :id => /\d+/ , :bazar => /\d+/ }
  match '/home/crearimagenempresa' => "home#crearimagenempresa"
  match '/home/delempresaimagen/:empresa/:id' => "home#delempresaimagen", :constrants => { :id => /\d+/ , :empresa => /\d+/ }
  match '/home/empresasestimadas' => "home#empresasestimadas"
  match '/home/filtraresultadosempresas/:resu/:tipo' => "home#filtraresultadosempresas", :constrants => { :resu => /\d+/ , :tipo => /\s+/ }
  match '/home/addsede/:id' => "home#addsede", :constrants => { :id => /\d+/ }
  match '/home/grabasede/' => "home#grabasede"
  match '/home/delsede/:empresa/:id' => "home#delsede", :constrants => { :empresa => /\d+/, :id => /\d+/ }
  
  match '/home/favoritos/' => "home#favoritos"
  match '/home/delfav/:bazar/:id' => "home#delfav", :constrants => { :id => /\d+/ , :bazar => /\d+/ }
  match '/home/addfav/:bazar/:id' => "home#addfav", :constrants => { :id => /\d+/ , :bazar => /\d+/ }
  match '/home/delofefav/:bazar/:id/:class' => "home#delofefav", :constrants => { :id => /\d+/ , :bazar => /\d+/ }
  match '/home/addofefav/:bazar/:id/:class' => "home#addofefav", :constrants => { :id => /\d+/ , :bazar => /\d+/ }
  match '/home/crearimagenoferta/:id/:empresa' => "home#crearimagenoferta", :constrants => { :id => /\d+/ , :empresa => /\d+/ }
  match '/home/delofertaimagen/:oferta/:id' => "home#delofertaimagen", :constrants => { :id => /\d+/ , :oferta => /\d+/ }
  match '/home/editaroferta/:oferta/:id' => "home#editaroferta", :constrants => { :id => /\d+/ , :oferta => /\d+/ }
  match '/home/imagenesoferta/:oferta' => "home#imagenesoferta", :constrants => {:oferta => /\d+/ }
  match '/home/subirimagenoferta/:oferta' =>  "home#subirimagenoferta", :constrants => {:oferta => /\d+/ }
  match '/home/cancelaroferta/:oferta' =>  "home#cancelaroferta", :constrants => {:oferta => /\d+/ }
  match '/home/publicaroferta/:oferta' =>  "home#publicaroferta", :constrants => {:oferta => /\d+/ }
  match '/home/filtraresultadosofertas/:resu/:tipo' => "home#filtraresultadosofertas", :constrants => { :resu => /\d+/ , :tipo => /\s+/ }
  
  match '/home/test/' => "home#test"
  match '/home/editarcorreo/:bazar/:id' =>  "home#editarcorreo", :constrants => {:bazar => /\d+/ , :id => /\d+/ }
  match '/home/enviarcorreo/:id' =>  "home#enviarcorreo", :constrants => {:id => /\d+/ }

  match '/home/rating/:bazar/:id/:valor' => "home#rating", :constrants => {:bazar => /\d+/ , :id => /\d+/, :valor => /\d+/}

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
  match '/api/infooferta(.:format)/:id' => "api#infooferta", :constrants => { :id => /\d+/ }
  match '/api/buscaempresas' => 'api#buscaempresas'
  
  match '/api/ejemplos' => 'api#ejemplos'
  match '/api/ejemploinfo' => 'api#ejemploinfo'
  match '/api/ejemploempresas' => 'api#ejemploempresas'
  match '/api/ejemploinfoempresa' => 'api#ejemploinfoempresa'
  match '/api/ejemploinfooferta' => 'api#ejemploinfooferta'  
  match '/api/ejemploperfiles' => 'api#ejemploperfiles'
  match '/api/ejemplopaises' => 'api#ejemplopaises'


#    scope '/translate' do
#      match '/translate_list', :to => 'translate#index'
#      match '/translate', :to => 'translate#translate'
#      match '/translate_reload', :to => 'translate#reload', :as => 'translate_reload'
#    end
#  
#   Translate::Routes.translation_ui(map) if RAILS_ENV != "production"
  
  
end
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
  match '/home/busquedageneral' => "home#busquedageneral"
  match '/home/redirigebusqueda' => "home#redirigebusqueda"

  match '/home/ofertas/:tipo' => "home#ofertas"
  match '/home/fichaoferta/:bazar/:id' => "home#fichaoferta", :constrants => { :id => /\d+/ , :bazar => /\d+/ }
  match '/busqueda-oferta' => "home#busquedaoferta"
  match '/home/ofertadatosgenerales/:bazar/:id' => "home#ofertadatosgenerales", :constrants => { :id => /\d+/ , :bazar => /\d+/ }
  match '/home/actofertadatosgenerales/:bazar/:id' => "home#actofertadatosgenerales", :constrants => { :id => /\d+/ , :bazar => /\d+/ }
  match '/home/crearoferta/:bazar/:id' => "home#crearoferta", :constrants => { :id => /\d+/ , :bazar => /\d+/ }
  
  match '/home/empresas/' => "home#empresas"
  match '/home/fichaempresa/:bazar/:id' => "home#fichaempresa", :constrants => { :id => /\d+/ , :bazar => /\d+/ }
  match '/busqueda-empresa' => "home#busquedaempresa"
  match '/home/empresadatosgenerales/:bazar/:id' => "home#empresadatosgenerales", :constrants => { :id => /\d+/ , :bazar => /\d+/ }
  match '/home/empresadatosgenerales2/:bazar/:id' => "home#empresadatosgenerales2", :constrants => { :id => /\d+/ , :bazar => /\d+/ }
  match '/home/actempresadatosgenerales/:bazar/:id' => "home#actempresadatosgenerales", :constrants => { :id => /\d+/ , :bazar => /\d+/ }
  match '/home/crearimagenempresa' => "home#crearimagenempresa"
  match '/home/delempresaimagen/:empresa/:id' => "home#delempresaimagen", :constrants => { :id => /\d+/ , :empresa => /\d+/ }
  match '/home/empresasestimadas' => "home#empresasestimadas"
  match '/home/filtraresultadosempresas/:resu/:tipo' => "home#filtraresultadosempresas", :constrants => { :resu => /\d+/ , :tipo => /\s+/ }
  match '/home/addsede/:id' => "home#addsede", :constrants => { :id => /\d+/ }
  match '/home/grabasede/' => "home#grabasede"
  match '/home/delsede/:empresa/:id' => "home#delsede", :constrants => { :empresa => /\d+/, :id => /\d+/ }
  
  match '/home/favoritos/' => "home#favoritos"
  match '/home/delfav/:bazar/:id' => "home#delfav", :constrants => { :id => /\d+/ , :bazar => /\d+/ }
  match '/home/addfav/:bazar/:id' => "home#addfav", :constrants => { :id => /\d+/ , :bazar => /\d+/ }
  match '/home/delofefav/:bazar/:id/:class' => "home#delofefav", :constrants => { :id => /\d+/ , :bazar => /\d+/ }
  match '/home/addofefav/:bazar/:id/:class' => "home#addofefav", :constrants => { :id => /\d+/ , :bazar => /\d+/ }
  match '/home/crearimagenoferta/:id/:empresa' => "home#crearimagenoferta", :constrants => { :id => /\d+/ , :empresa => /\d+/ }
  match '/home/delofertaimagen/:oferta/:id' => "home#delofertaimagen", :constrants => { :id => /\d+/ , :oferta => /\d+/ }
  match '/home/editaroferta/:oferta/:id' => "home#editaroferta", :constrants => { :id => /\d+/ , :oferta => /\d+/ }
  match '/home/imagenesoferta/:oferta' => "home#imagenesoferta", :constrants => {:oferta => /\d+/ }
  match '/home/subirimagenoferta/:oferta' =>  "home#subirimagenoferta", :constrants => {:oferta => /\d+/ }
  match '/home/cancelaroferta/:oferta' =>  "home#cancelaroferta", :constrants => {:oferta => /\d+/ }
  match '/home/publicaroferta/:oferta' =>  "home#publicaroferta", :constrants => {:oferta => /\d+/ }
  match '/home/filtraresultadosofertas/:resu/:tipo' => "home#filtraresultadosofertas", :constrants => { :resu => /\d+/ , :tipo => /\s+/ }
  
  match '/home/test/' => "home#test"
  match '/home/editarcorreo/:bazar/:id' =>  "home#editarcorreo", :constrants => {:bazar => /\d+/ , :id => /\d+/ }
  match '/home/enviarcorreo/:id' =>  "home#enviarcorreo", :constrants => {:id => /\d+/ }

  match '/home/rating/:bazar/:id/:valor' => "home#rating", :constrants => {:bazar => /\d+/ , :id => /\d+/, :valor => /\d+/}

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
  match '/api/infooferta(.:format)/:id' => "api#infooferta", :constrants => { :id => /\d+/ }
  match '/api/buscaempresas' => 'api#buscaempresas'
  
  match '/api/ejemplos' => 'api#ejemplos'
  match '/api/ejemploinfo' => 'api#ejemploinfo'
  match '/api/ejemploempresas' => 'api#ejemploempresas'
  match '/api/ejemploinfoempresa' => 'api#ejemploinfoempresa'
  match '/api/ejemploinfooferta' => 'api#ejemploinfooferta'  
  match '/api/ejemploperfiles' => 'api#ejemploperfiles'
  match '/api/ejemplopaises' => 'api#ejemplopaises'


#    scope '/translate' do
#      match '/translate_list', :to => 'translate#index'
#      match '/translate', :to => 'translate#translate'
#      match '/translate_reload', :to => 'translate#reload', :as => 'translate_reload'
#    end
#  
#   Translate::Routes.translation_ui(map) if RAILS_ENV != "production"
  
  
end
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
  match '/home/busquedageneral' => "home#busquedageneral"
  match '/home/redirigebusqueda' => "home#redirigebusqueda"

  match '/home/ofertas/:tipo' => "home#ofertas"
  match '/home/fichaoferta/:bazar/:id' => "home#fichaoferta", :constrants => { :id => /\d+/ , :bazar => /\d+/ }
  match '/busqueda-oferta' => "home#busquedaoferta"
  match '/home/ofertadatosgenerales/:bazar/:id' => "home#ofertadatosgenerales", :constrants => { :id => /\d+/ , :bazar => /\d+/ }
  match '/home/actofertadatosgenerales/:bazar/:id' => "home#actofertadatosgenerales", :constrants => { :id => /\d+/ , :bazar => /\d+/ }
  match '/home/crearoferta/:bazar/:id' => "home#crearoferta", :constrants => { :id => /\d+/ , :bazar => /\d+/ }
  
  match '/home/empresas/' => "home#empresas"
  match '/home/fichaempresa/:bazar/:id' => "home#fichaempresa", :constrants => { :id => /\d+/ , :bazar => /\d+/ }
  match '/busqueda-empresa' => "home#busquedaempresa"
  match '/home/empresadatosgenerales/:bazar/:id' => "home#empresadatosgenerales", :constrants => { :id => /\d+/ , :bazar => /\d+/ }
  match '/home/empresadatosgenerales2/:bazar/:id' => "home#empresadatosgenerales2", :constrants => { :id => /\d+/ , :bazar => /\d+/ }
  match '/home/actempresadatosgenerales/:bazar/:id' => "home#actempresadatosgenerales", :constrants => { :id => /\d+/ , :bazar => /\d+/ }
  match '/home/crearimagenempresa' => "home#crearimagenempresa"
  match '/home/delempresaimagen/:empresa/:id' => "home#delempresaimagen", :constrants => { :id => /\d+/ , :empresa => /\d+/ }
  match '/home/empresasestimadas' => "home#empresasestimadas"
  match '/home/filtraresultadosempresas/:resu/:tipo' => "home#filtraresultadosempresas", :constrants => { :resu => /\d+/ , :tipo => /\s+/ }
  match '/home/addsede/:id' => "home#addsede", :constrants => { :id => /\d+/ }
  match '/home/grabasede/' => "home#grabasede"
  match '/home/delsede/:empresa/:id' => "home#delsede", :constrants => { :empresa => /\d+/, :id => /\d+/ }
  
  match '/home/favoritos/' => "home#favoritos"
  match '/home/delfav/:bazar/:id' => "home#delfav", :constrants => { :id => /\d+/ , :bazar => /\d+/ }
  match '/home/addfav/:bazar/:id' => "home#addfav", :constrants => { :id => /\d+/ , :bazar => /\d+/ }
  match '/home/delofefav/:bazar/:id/:class' => "home#delofefav", :constrants => { :id => /\d+/ , :bazar => /\d+/ }
  match '/home/addofefav/:bazar/:id/:class' => "home#addofefav", :constrants => { :id => /\d+/ , :bazar => /\d+/ }
  match '/home/crearimagenoferta/:id/:empresa' => "home#crearimagenoferta", :constrants => { :id => /\d+/ , :empresa => /\d+/ }
  match '/home/delofertaimagen/:oferta/:id' => "home#delofertaimagen", :constrants => { :id => /\d+/ , :oferta => /\d+/ }
  match '/home/editaroferta/:oferta/:id' => "home#editaroferta", :constrants => { :id => /\d+/ , :oferta => /\d+/ }
  match '/home/imagenesoferta/:oferta' => "home#imagenesoferta", :constrants => {:oferta => /\d+/ }
  match '/home/subirimagenoferta/:oferta' =>  "home#subirimagenoferta", :constrants => {:oferta => /\d+/ }
  match '/home/cancelaroferta/:oferta' =>  "home#cancelaroferta", :constrants => {:oferta => /\d+/ }
  match '/home/publicaroferta/:oferta' =>  "home#publicaroferta", :constrants => {:oferta => /\d+/ }
  match '/home/filtraresultadosofertas/:resu/:tipo' => "home#filtraresultadosofertas", :constrants => { :resu => /\d+/ , :tipo => /\s+/ }
  
  match '/home/test/' => "home#test"
  match '/home/editarcorreo/:bazar/:id' =>  "home#editarcorreo", :constrants => {:bazar => /\d+/ , :id => /\d+/ }
  match '/home/enviarcorreo/:id' =>  "home#enviarcorreo", :constrants => {:id => /\d+/ }

  match '/home/rating/:bazar/:id/:valor' => "home#rating", :constrants => {:bazar => /\d+/ , :id => /\d+/, :valor => /\d+/}

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
  match '/api/infooferta(.:format)/:id' => "api#infooferta", :constrants => { :id => /\d+/ }
  match '/api/buscaempresas' => 'api#buscaempresas'
  
  match '/api/ejemplos' => 'api#ejemplos'
  match '/api/ejemploinfo' => 'api#ejemploinfo'
  match '/api/ejemploempresas' => 'api#ejemploempresas'
  match '/api/ejemploinfoempresa' => 'api#ejemploinfoempresa'
  match '/api/ejemploinfooferta' => 'api#ejemploinfooferta'  
  match '/api/ejemploperfiles' => 'api#ejemploperfiles'
  match '/api/ejemplopaises' => 'api#ejemplopaises'


#    scope '/translate' do
#      match '/translate_list', :to => 'translate#index'
#      match '/translate', :to => 'translate#translate'
#      match '/translate_reload', :to => 'translate#reload', :as => 'translate_reload'
#    end
#  
#   Translate::Routes.translation_ui(map) if RAILS_ENV != "production"
  
  
end
