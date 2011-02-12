xml.instruct!
xml.empresas do
  @info.each { |empresa|
 
  xml.nombre empresa.nombre
  xml.fundada empresa.fundada
  xml.url empresa.url
  xml.consultas empresa.consultas
  
  }
end