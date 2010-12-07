class Pais < ActiveRecord::Base
  has_many :ciudades

  default_scope :order => 'descripcion'

  def to_s;self.descripcion;end

end