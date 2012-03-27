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

      conf = Conf.find_by_nombre('BazarId')
      if !conf.nil? 
	valor = conf.valor
      else 
        valor = 99
      end 
      puts "Configurando el prefix de Dalli #{valor}"
      config.cache_store = :dalli_store, '127.0.0.1',
          { :namespace => "#{valor}_", :expires_in => 1.day, :debug => true, :compress => true, :compress_threshold => 64*1024 }
 

    end 
    
  end

