@parametros = {}
Conf.all.each do |c|
  @parametros[c.nombre] = c.valor
  puts @parametros.inspect
end  


