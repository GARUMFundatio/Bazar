class Cluster < ActiveRecord::Base
  has_friendly_id :nombre, :use_slug => true, :approximate_ascii => true
end
