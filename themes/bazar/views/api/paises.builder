xml.instruct!
xml.paises do
  @info.each { |pais|
  xml.pais do
      xml.id pais[:id]
      xml.codigo pais[:codigo]
      xml.descripcion pais[:descripcion]
      xml.capital pais[:capital]
      xml.total_empresas_bazar pais[:total_empresas_bazar]
      xml.total_empresas_mercado pais[:total_empresas_mercado]
  end
  }
end