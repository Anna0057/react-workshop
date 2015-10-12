class Location < ActiveRecord::Base
  belongs_to :parent, class_name: :Location, foreign_key: :parent_id

  def serializable_hash(options = {})
    { id: id,
      name: name,
      parent: parent }
  end
end
