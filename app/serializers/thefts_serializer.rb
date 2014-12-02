class TheftsSerializer < ActiveModel::Serializer
  attributes :locking_select_id,
    :locking_defeat_select_id,
    :has_police_report

end
