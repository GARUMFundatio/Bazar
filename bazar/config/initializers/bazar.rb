parametros = {}
Conf.all.each do |c|
  parametros[c.nombre] = c
  puts parametros.inspect
end  


