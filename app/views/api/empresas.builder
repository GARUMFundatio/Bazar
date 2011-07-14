xml.instruct!
xml.empresas do
  @info.each { |empresa|
  xml.empresa do
      xml.id empresa[:id]
      xml.nombre empresa[:nombre]
      xml.rating empresa[:rating]
      xml.rating_cliente empresa[:rating_cliente]
      xml.rating_total_cliente empresa[:rating_total_cliente]
      xml.rating_proveedor empresa[:rating_proveedor]
      xml.rating_total_proveedor empresa[:rating_total_proveedor]
      xml.url empresa[:url]
      xml.consultas empresa[:consultas]
      xml.fundada empresa[:fundada]
  end
  }
end