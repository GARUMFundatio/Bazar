class Gruposconf < ActiveRecord::Base
  belongs_to :confs, :foreign_key => "grupo_id"
end
