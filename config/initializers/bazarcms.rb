module Bazarcms
  class Engine < Rails::Engine

    config.montar_en = '/bazarcms'
    config.bazarcms_factory_name = 'Bazarcms'
    puts "bazarcms:: inicializo el engine <---------------------"
    
    ActiveSupport::Inflector.inflections do |inflect|
      puts "inflectors de la gema bazarcms"
      inflect.irregular 'interes', 'intereses'
      inflect.irregular 'ubicacion', 'ubicaciones'
      inflect.irregular 'empresa', 'empresas'
      inflect.irregular 'empresasdato', 'empresasdatos'
      inflect.irregular 'empresasconsulta', 'empresasconsultas'
      inflect.irregular 'empresasresultado', 'empresasresultados'
      inflect.irregular 'empresasperfil', 'empresasperfiles'
      inflect.irregular 'perfil', 'perfiles'
      inflect.irregular 'oferta', 'ofertas'
      inflect.irregular 'ofertasconsulta', 'ofertasconsultas'
      inflect.irregular 'ofertasresultado', 'ofertasresultados'
      inflect.irregular 'ofertasperfil', 'ofertasperfiles'
      inflect.irregular 'ofertaspais', 'ofertaspaises'
      inflect.irregular 'ofertasfavorito', 'ofertasfovoritos'
      
    end
     
#     config.middleware.use "::ExceptionNotifier",
#        :email_prefix => "[Bazar Garum] ",
#        :sender_address => %{"Notifier" <juantomas@geofun.es>},
#        :exception_recipients => %w{juantomas.garcia@gmail.com}
     
  end
end
