xml.instruct!
  xml.empresa do
      xml.id @info[:id]
      xml.nombre @info[:nombre]
      xml.rating empresa[:rating]
      xml.rating_cliente empresa[:rating_cliente]
      xml.rating_total_cliente empresa[:rating_total_cliente]
      xml.rating_proveedor empresa[:rating_proveedor]
      xml.rating_total_proveedor empresa[:rating_total_proveedor]
      xml.url @info[:url]
      xml.consultas @info[:consultas]
      xml.fundada @info[:fundada]
  end
