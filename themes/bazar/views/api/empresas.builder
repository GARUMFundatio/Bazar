xml.instruct!
xml.empresas do
  @info.each { |empresa|
  xml.empresa do
      xml.id empresa[:id]
      xml.nombre empresa[:nombre]
      xml.url empresa[:url]
      xml.logo empresa[:logo_url]
      xml.consultas empresa[:consultas]
      xml.fundada empresa[:fundada]
  end
  }
end