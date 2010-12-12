
class Ciudad < ActiveRecord::Base
  belongs_to :pais
  has_many :ubicaciones
  default_scope :order => 'descripcion'

  def to_s;self.descripcion;end

end
