xml.instruct!
xml.empresas do
  @info.each { |empresa|
  xml.empresa do
      xml.nombre empresa[:nombre]
      xml.url empresa[:url]
      xml.consultas empresa[:consultas]
      xml.fundada empresa[:fundada]
  end
  }
end