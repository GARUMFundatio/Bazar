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
  end

