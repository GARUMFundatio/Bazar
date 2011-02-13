xml.instruct!
  xml.empresa do
      xml.id @info[:id]
      xml.nombre @info[:nombre]
      xml.url @info[:url]
      xml.consultas @info[:consultas]
      xml.fundada @info[:fundada]
  end
