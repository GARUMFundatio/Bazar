xml.instruct!
  xml.empresa do
      xml.id @info[:id]
      xml.nombre @info[:nombre]
      xml.rating @info[:rating]
      xml.rating_cliente @info[:rating_cliente]
      xml.rating_total_cliente @info[:rating_total_cliente]
      xml.rating_proveedor @info[:rating_proveedor]
      xml.rating_total_proveedor @info[:rating_total_proveedor]
      xml.url @info[:url]
      xml.consultas @info[:consultas]
      xml.fundada @info[:fundada]
  end
