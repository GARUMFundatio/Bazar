class Pais < ActiveRecord::Base
  has_many :ciudades

  default_scope :order => 'descripcion'

  has_friendly_id :descripcion , :use_slug => true, :strip_non_ascii => true

  def to_s;self.descripcion;end

  def self.paisestocsv
    csv = "country_code,value\\n"
    max = Pais.count_by_sql("select max(total_empresas_mercado) from paises")
    for pais in Pais.where ('total_empresas_mercado > 0')
      csv += "#{pais.cod3},#{(pais.total_empresas_mercado*10)/max}\\n"
    end
    
    return csv
  end  
end