class HazardSerializer < ActiveModel::Serializer
  attributes :priority_type,
    :hazard_type

  def hazard_type
    object.hazard_select.name
  end

  def priority_type
    object.priority_select.name
  end

end
