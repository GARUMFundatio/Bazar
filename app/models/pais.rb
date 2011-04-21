class Pais < ActiveRecord::Base
  has_many :ciudades

  default_scope :order => 'descripcion'

  def to_s;self.descripcion;end

  def paisestocsv
    csv = "country,value\n"
    
    for pais in Pais.where("tot_mercado > 0")
      
      csv += "#{pais.codigo},#{tot_mercado}\n"
      
    end
    
    return csv
  end  
end