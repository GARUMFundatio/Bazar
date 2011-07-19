@parametros = {}

  begin
    Conf.all.each do |c|
      @parametros[c.nombre] = c.valor
    end 
    puts @parametros.inspect
  rescue
    printf "[FALLO]\n"
    printf "No existe el fichero de configuración!"
    printf "Si está haciendo la instalación inicial esto es normal\n"
  else
    printf "Configuración [OK]\n"
    
    
    Bazar::Application.configure do

      puts "Configurandos el prefix de Dalli #{Conf.find_by_nombre('BazarId').valor}"

      config.cache_store = :dalli_store, '127.0.0.1',
          { :namespace => "#{Conf.find_by_nombre('BazarId').valor}_", :expires_in => 1.day, :debug => true, :compress => true, :compress_threshold => 64*1024 }
    end 
    
  end

