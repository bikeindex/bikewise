class IncidentSerializer < ActiveModel::Serializer
  attributes :id,
    :title,
    :description,
    :address,
    :type,
    :occurred_at,
    :updated_at,
    :url,
    :source,
    :media

  def type
    object.type_name
  end

  def media
    {
      image_url: object.image_url,
      image_url_thumb: object.image_url_thumb
    }
  end

  def url
    "#{BASE_URL}/api/v1/incidents/#{object.id}"
  end

end
