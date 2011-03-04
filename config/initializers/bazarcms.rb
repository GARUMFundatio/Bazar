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
    end
     
  end
end