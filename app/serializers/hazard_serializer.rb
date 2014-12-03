class HazardSerializer < ActiveModel::Serializer
  attributes :priority,
    :hazard_type

  def hazard_type
    object.hazard_select.name
  end

end
