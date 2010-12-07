
class Ciudad < ActiveRecord::Base
  belongs_to :pais
  default_scope :order => 'descripcion'

  def to_s;self.descripcion;end

end
