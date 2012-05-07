xml.instruct!
xml.info do 
  xml.nombre @info[:nombre]
  xml.desc @info[:desc]
  xml.url @info[:url]
  xml.empresas @info[:empresas]
  xml.consultas @info[:consultas]
  xml.consultasofertas @info[:consultasofertas]
  xml.clusteractivos @info[:clusteractivos]
end