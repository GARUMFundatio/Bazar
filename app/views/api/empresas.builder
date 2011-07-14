xml.instruct!
xml.empresas do
  @info.each { |empresa|
  xml.empresa do
      xml.id empresa[:id]
      xml.rating empresa[:rating]
      xml.rating empresa[:rating_cliente]
      xml.rating empresa[:rating_total_cliente]
      xml.rating empresa[:rating_proveedor]
      xml.rating empresa[:rating_total_proveedor]
      xml.nombre empresa[:nombre]
      xml.url empresa[:url]
      xml.consultas empresa[:consultas]
      xml.fundada empresa[:fundada]
  end
  }
end