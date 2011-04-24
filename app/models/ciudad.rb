
class Ciudad < ActiveRecord::Base
  belongs_to :pais
  has_many :ubicaciones
  default_scope :order => 'descripcion'
  
  has_friendly_id :descripcion, :use_slug => true, :strip_non_ascii => true
  
  def to_s;self.descripcion;end

end
