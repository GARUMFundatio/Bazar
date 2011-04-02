xml.instruct!
xml.perfiles do
  @info.each { |perfil|
  xml.perfil do
      xml.id perfil[:id]
      xml.desc perfil[:desc]
      xml.nivel perfil[:nivel]
      xml.total_empresas_bazar perfil[:total_empresas_bazar]
      xml.total_empresas_mercado perfil[:total_empresas_mercado]
  end
  }
end