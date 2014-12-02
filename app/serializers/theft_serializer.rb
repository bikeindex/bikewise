class TheftSerializer < ActiveModel::Serializer
  attributes :has_police_report,
    :locking_type,
    :locking_defeat_type,

  def locking_type
    object.locking_select.name
  end
  def locking_defeat_type
    object.locking_defeat_select.name
  end

end
